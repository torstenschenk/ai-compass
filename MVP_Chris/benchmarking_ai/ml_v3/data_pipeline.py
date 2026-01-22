
import os
import pandas as pd
import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv

load_dotenv()

class DataPipeline:
    def __init__(self):
        self.conn = None
        self._connect()

    def _connect(self):
        try:
            self.conn = psycopg2.connect(
                user=os.getenv("user"),
                password=os.getenv("password"),
                host=os.getenv("host"),
                port=os.getenv("port"),
                dbname=os.getenv("dbname")
            )
        except Exception as e:
            print(f"Connection Error: {e}")

    def fetch_data(self):
        """Fetches and merges data into a single DataFrame."""
        if not self.conn:
            return None

        queries = {
            "responses": "SELECT * FROM responses",
            "companies": "SELECT * FROM companies",
            "response_items": "SELECT * FROM response_items",
            "questions": "SELECT * FROM questions",
            "dimensions": "SELECT * FROM dimensions",
            "cluster_profiles": "SELECT * FROM cluster_profiles ORDER BY cluster_id",
            # We assume answers tables maps the numeric answer to weights?
            # Creating a simpler join strategy for now based on schema
        }
        
        dfs = {}
        cur = self.conn.cursor(cursor_factory=extras.RealDictCursor)
        
        for name, query in queries.items():
            cur.execute(query)
            dfs[name] = pd.DataFrame(cur.fetchall())
        
        cur.close()
        return dfs

    def create_matrices(self, dfs):
        """
        Creates QuestionMatrix and DimensionMatrix.
        Returns:
            question_matrix (pd.DataFrame): Index=company_id, Cols=question_text/id
            dimension_matrix (pd.DataFrame): Index=company_id, Cols=dimension_name
            cluster_profiles (pd.DataFrame): Cluster naming metadata
        """
        # Unpack
        responses = dfs['responses']
        items = dfs['response_items']
        questions = dfs['questions']
        dimensions = dfs['dimensions']
        companies = dfs['companies']

        # items.answers is an ARRAY. We need to explode or take the first element (assuming single choice for now for simplicity, or sum).
        # Schema sample: answers -> [2]
        
        # 1. Flatten Items
        # We need to map item's answer to a score. 
        # Schema: items has 'answers' (list of IDs? or Values?). 
        # 'answers' table has answer_id, answer_weight.
        # It seems items.answers contains answer_ids.
        
        # Let's fetch answers table too to map weights
        cur = self.conn.cursor(cursor_factory=extras.RealDictCursor)
        cur.execute("SELECT * FROM answers")
        answers_ref = pd.DataFrame(cur.fetchall())
        cur.close()

        # 1. Flatten Items and merge with metadata
        items_exploded = items.explode('answers')
        items_exploded = items_exploded.rename(columns={'answers': 'answer_id'})
        
        # Merge to get answer weights
        full_df = items_exploded.merge(answers_ref, on=['answer_id', 'question_id'], how='left')
        full_df = full_df.merge(questions, on='question_id', how='left')
        full_df = full_df.merge(dimensions, on='dimension_id', how='left')
        full_df = full_df.merge(responses, on='response_id', how='left')
        
        # 2. Calculate Reference Weights (Max and Total possible per question)
        # We need this for the normalization formula provided by the user
        ans_stats = answers_ref.groupby('question_id').agg(
            total_possible_weight=('answer_weight', 'sum'),
            max_possible_weight=('answer_weight', 'max')
        ).reset_index()
        
        full_df = full_df.merge(ans_stats, on='question_id', how='left')

        # 3. Aggregating Selected Answer Weights per Question per Company
        grouped_questions = full_df.groupby([
            'company_id', 'question_id', 'dimension_name', 'weight', 'type', 
            'total_possible_weight', 'max_possible_weight'
        ])['answer_weight'].sum().reset_index()
        
        grouped_questions = grouped_questions.rename(columns={'weight': 'question_weight', 'answer_weight': 'sum_selected_weight'})

        # 4. Apply Scoring Logic (Directly from User Formula)
        def calculate_question_score(row):
            # Formulas:
            # Checklist: ((Sum_selected / Total_possible) * q_weight) / 100
            # Others: ((Selected / Max) * q_weight) / 100
            
            if row['type'] == 'Checklist':
                total_w = row['total_possible_weight']
                ratio = row['sum_selected_weight'] / total_w if total_w > 0 else 0
            else:
                max_w = row['max_possible_weight']
                ratio = row['sum_selected_weight'] / max_w if max_w > 0 else 0
            
            # The Question_Score contributes to the total 1.0 (or 100 points if not /100)
            return (ratio * row['question_weight']) / 100

        grouped_questions['question_score_contrib'] = grouped_questions.apply(calculate_question_score, axis=1)
        
        # Keep a 1-5 version for the Question Matrix for readability
        grouped_questions['score_1to5'] = (grouped_questions['question_score_contrib'] / (grouped_questions['question_weight'] / 100)) * 4 + 1
        # Handle cases where weight is 0
        grouped_questions['score_1to5'] = grouped_questions['score_1to5'].fillna(1.0)

        # 5. Question Matrix (1-5 Scale)
        q_matrix = grouped_questions.pivot_table(
            index='company_id', 
            columns='question_id', 
            values='score_1to5', 
            aggfunc='mean'
        ).fillna(1.0)

        # 6. Dimension Matrix (Weighted Average -> 1-5 Scale)
        # Sum contributions in dimension and normalize by dimension's weight share
        dim_groups = grouped_questions.groupby(['company_id', 'dimension_name'])
        
        dim_results = dim_groups.apply(
            lambda x: (x['question_score_contrib'].sum() / (x['question_weight'].sum() / 100)) * 4 + 1 if x['question_weight'].sum() > 0 else 1.0
        ).reset_index(name='dimension_score')
        
        d_matrix = dim_results.pivot_table(
            index='company_id', 
            columns='dimension_name', 
            values='dimension_score'
        ).fillna(1.0)
        
        # EXCLUSION: Drop 'General Psychology' if present
        if 'General Psychology' in d_matrix.columns:
            d_matrix = d_matrix.drop(columns=['General Psychology'])
        
        # Merge with Company Metadata
        try:
            # Robust Logic:
            valid_ids = pd.DataFrame({'company_id': d_matrix.index.unique()})
            
            if 'company_id' not in companies.columns and companies.index.name == 'company_id':
                companies = companies.reset_index()
                
            meta = valid_ids.merge(companies, on='company_id', how='left')
            meta = meta[['company_id', 'industry', 'number_of_employees']]
            meta = meta.set_index('company_id')
        except Exception as e:
            print(f"WARNING: Metadata extraction failed: {e}")
            meta = pd.DataFrame(index=d_matrix.index, columns=['industry', 'number_of_employees'])
        
        return q_matrix, d_matrix, dfs.get('cluster_profiles', pd.DataFrame())

if __name__ == "__main__":
    dp = DataPipeline()
    dfs = dp.fetch_data()
    if dfs:
        qm, dm, profiles = dp.create_matrices(dfs)
        print("Question Matrix Shape:", qm.shape)
        print("Dimension Matrix Shape:", dm.shape)
        print("Profiles Loaded:", len(profiles))
        print(dm.head())
