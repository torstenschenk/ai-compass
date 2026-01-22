import pandas as pd
import os
import json
from datetime import datetime

TABLES_PATH = "/Users/christianmiething/Downloads/ai-compass/MVP_Chris/Tables"

class SessionDatabase:
    def __init__(self, path=TABLES_PATH):
        self.path = path
        # Tables that should stay in memory only (not written to CSV or DB)
        self.session_tables = ['companies', 'responses', 'response_items']
        self._memory_data = {}
        
        # Initialize session tables
        for table in self.session_tables:
            # Try to load from CSV first to persist state across restarts (Dev Mode convenience)
            p = self._get_path(table)
            if os.path.exists(p):
                 try:
                     df = pd.read_csv(p, keep_default_na=False)
                     df = df.replace(r'^\s*$', None, regex=True)
                     # Sanitize NaN (though keep_default_na=False reduces them)
                     df = df.where(pd.notnull(df), None)
                     self._memory_data[table] = df
                 except Exception as e:
                     print(f"Failed to load {table} from CSV, starting empty. Error: {e}")
                     self._memory_data[table] = pd.DataFrame()
            else:
                self._memory_data[table] = pd.DataFrame()

    def _get_path(self, table_name):
        return os.path.join(self.path, f"{table_name}.csv")

    def read_table(self, table_name):
        # Use memory if it's a transactional session table
        if table_name in self.session_tables:
            return self._memory_data[table_name]

        # Static metadata tables are read from CSV
        p = self._get_path(table_name)
        if not os.path.exists(p):
            print(f"CSV Not Found: {p}")
            return pd.DataFrame()
        
        try:
            # keep_default_na=False ensures "None" is read as string "None", not NaN
            df = pd.read_csv(p, keep_default_na=False)
            # Convert actual empty strings to None to maintain compatibility
            df = df.replace(r'^\s*$', None, regex=True)
            df = df.where(pd.notnull(df), None)
            return df
        except Exception as e:
            print(f"Error reading {table_name}: {e}")
            return pd.DataFrame()

    def save_table(self, table_name, df):
        # Only save to memory if it's a session table
        if table_name in self.session_tables:
            self._memory_data[table_name] = df
            return

        # Static tables shouldn't really be updated via the app, 
        # but if they are, we save them back to CSV.
        p = self._get_path(table_name)
        df.to_csv(p, index=False)

    async def get_all(self, table_name):
        df = self.read_table(table_name)
        return df.to_dict('records')

    async def get_by_id(self, table_name, id_col, id_val):
        df = self.read_table(table_name)
        if df.empty or id_col not in df.columns:
            return None
        
        # Convert to string for comparison to avoid type mismatch issues
        subset = df[df[id_col].astype(str) == str(id_val)]
        if subset.empty:
            return None
        return subset.iloc[0].to_dict()

    async def add_record(self, table_name, record):
        df = self.read_table(table_name)
        
        # ID generation logic mapping
        id_map = {
            'companies': 'company_id',
            'responses': 'response_id',
            'response_items': 'item_id',
            'dimensions': 'dimension_id',
            'questions': 'question_id',
            'answers': 'answer_id'
        }
        id_col = id_map.get(table_name, 'id')

        # Auto-increment ID if not provided
        if id_col not in record or record[id_col] is None:
            if df.empty or id_col not in df.columns:
                record[id_col] = 1
            else:
                record[id_col] = int(pd.to_numeric(df[id_col]).max()) + 1
        
        # Use pd.concat for safer appending
        new_record_df = pd.DataFrame([record])
        new_df = pd.concat([df, new_record_df], ignore_index=True)
        self.save_table(table_name, new_df)
        return record[id_col]

    async def update_record(self, table_name, id_col, id_val, updates):
        df = self.read_table(table_name)
        if df.empty or id_col not in df.columns:
            return False
            
        mask = df[id_col].astype(str) == str(id_val)
        if not mask.any():
            return False
            
        idx = df[mask].index[0]
        for k, v in updates.items():
            df.at[idx, k] = v
            
        self.save_table(table_name, df)
        return True

    async def delete_where(self, table_name, filters):
        df = self.read_table(table_name)
        if df.empty: return
        
        for k, v in filters.items():
            if k in df.columns:
                df = df[df[k] != v]
            
        self.save_table(table_name, df)

# Singleton instance
csv_db = SessionDatabase()
