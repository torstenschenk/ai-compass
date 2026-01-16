
import nbformat as nbf

nb = nbf.v4.new_notebook()

# ------------------------------------------------------------------------------
# 1. Setup & Imports
# ------------------------------------------------------------------------------
text_intro = """# AI-Compass: Strategic Gap Analysis (Status Quo)
### Objective
To analyze the current AI maturity profile and identify exactly **two (2) major weaknesses or gaps**. This analysis focuses exclusively on the "Status Quo"—where we are today—using a robust two-stage logic:
1.  **Statistical Thresholding (Z-Scores)**: Identifying "Risky Structural Gaps" where dimension pairs are significantly imbalanced compared to the peer group.
2.  **Weighted Strategic Weakness**: Identifying high-impact missing capabilities based on expert weighting, if no statistical anomalies are found.

**Note on Methodology:**
-   **Standard Questions**: Scored on a 1-5 Maturity Scale.
-   **Checklist Items**: Scored using their dedicated `question_weight` if the capability is missing, reflecting their binary but high-impact nature.
"""

code_imports = """import os
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from scipy.stats import zscore
from dotenv import load_dotenv
import psycopg2

# Visualization
sns.set_theme(style="whitegrid")
plt.rcParams['figure.figsize'] = [10, 6]

# DB Connection
load_dotenv()
db_url = os.getenv("DATABASE_URL")
conn = psycopg2.connect(db_url)
print("✓ Connected to Database")
"""

# ------------------------------------------------------------------------------
# 2. Data Loading & Feature Engineering
# ------------------------------------------------------------------------------
text_data_loading = """## 1. Data Retrieval & Logic Handling
We fetch response data including `question_type`.
*   **Slider/Statement**: Normalized to 1-5 scale.
*   **Checklist**: Utilizes `question_weight` directly for gap analysis if the answer indicates a gap (low maturity).
"""

code_data_prep = """query = \"\"\"
SELECT 
    r.company_id,
    d.dimension_name,
    q.header as tactical_theme,
    q.question_text,
    q.type as question_type,
    q.weight as question_weight,
    a.answer_weight
FROM response_items ri
JOIN responses r ON r.response_id = ri.response_id
JOIN questions q ON q.question_id = ri.question_id
JOIN dimensions d ON d.dimension_id = q.dimension_id
JOIN answers a ON a.answer_id = ri.answers[1]
WHERE d.dimension_name != 'General Psychology'
\"\"\"

df_raw = pd.read_sql(query, conn)

# 1. Dimension Level Features (for Z-Score Gap Analysis)
# This remains on the 1-5 scale for comparability across dimensions
df_dim_features = df_raw.groupby(['company_id', 'dimension_name'])['answer_weight'].mean().reset_index()
df_dim_features = df_dim_features.pivot(index='company_id', columns='dimension_name', values='answer_weight').fillna(0)
df_dim_features = 1 + 4 * (df_dim_features - df_dim_features.min()) / (df_dim_features.max() - df_dim_features.min())

# 2. Question Level Impact Score (The "Weighted Gap")
def calculate_impact(row):
    # Logic: How big is the gap?
    if row['question_type'] == 'checklist':
        # For checklist: If answer is low (<3 or 0), the gap is the full weight.
        # If answer is high (5), gap is 0.
        if row['answer_weight'] < 3: # Assuming threshold for 'missing' capability
            return row['question_weight'] * 2 # Amplify checklist gaps as they are binary blockers
        else:
            return 0
    else:
        # Standard: Weight * (Target - Actual)
        return row['question_weight'] * (5.0 - row['answer_weight'])

df_raw['weighted_impact'] = df_raw.apply(calculate_impact, axis=1)

print(f"Dataset prepared with {len(df_dim_features)} companies.")
df_dim_features.head()
"""

# ------------------------------------------------------------------------------
# 3. Stage 1: Statistical Imbalance (Z-Scores)
# ------------------------------------------------------------------------------
text_gap_analysis = """## 2. Stage 1: Detecting Structural Imbalances
We calculate Z-scores for critical dimension pairs to find "Risky Gaps" (e.g., High Tech vs Low Culture).
**Threshold**: Z-Score > 1.5 indicates a significant anomaly.
"""

code_gaps = """risk_pairs = [
    ('Tech Infrastructure', 'People & Culture'),
    ('Tech Infrastructure', 'Strategy & Business Vision'),
    ('Data Readiness & Literacy', 'Use Cases & Business Value'),
    ('Processes & Scaling', 'Governance & Compliance')
]

for p1, p2 in risk_pairs:
    col_name = f'gap_{p1[:4]}_{p2[:4]}'
    # Absolute difference tells us magnitude of gap regardless of direction for Z-scoring
    df_dim_features[col_name] = (df_dim_features[p1] - df_dim_features[p2]).abs()

gap_cols = [c for c in df_dim_features.columns if c.startswith('gap_')]
df_zscores = df_dim_features[gap_cols].apply(zscore)
print("Gap Z-Scores calculated.")
"""

# ------------------------------------------------------------------------------
# 4. Selection Logic (2 Findings)
# ------------------------------------------------------------------------------
text_selection_logic = """## 3. Analysis Selection Logic
We strictly select the **Top 2 Findings**:
1.  **Priority A**: Structural Anomalies (Z-Score > 1.5). These represent fundamental "broken" pairings.
2.  **Priority B**: High-Impact Strategic Weaknesses. If anomalies don't fill the quota, we plug in the highest `weighted_impact` gaps (especially from Checklist items).
"""

code_selection = """def get_strategic_analysis(company_id):
    findings_list = []
    
    # --- Step 1: Check Anomalies ---
    if company_id in df_zscores.index:
        company_z = df_zscores.loc[company_id]
        anomalies = company_z[company_z > 1.5].sort_values(ascending=False)
        
        for gap_name, z_val in anomalies.items():
            if len(findings_list) >= 2: break
            
            # Map back to names
            if "Tech_Peop" in gap_name: d1, d2 = 'Tech Infrastructure', 'People & Culture'
            elif "Tech_Stra" in gap_name: d1, d2 = 'Tech Infrastructure', 'Strategy & Business Vision'
            elif "Data_Use" in gap_name: d1, d2 = 'Data Readiness & Literacy', 'Use Cases & Business Value'
            elif "Proc_Gove" in gap_name: d1, d2 = 'Processes & Scaling', 'Governance & Compliance'
            else: continue
            
            s1 = df_dim_features.loc[company_id, d1]
            s2 = df_dim_features.loc[company_id, d2]
            
            # Construct Funding Object
            findings_list.append({
                "type": "Anomaly",
                "title": f"Structural Imbalance: {d1} vs {d2}",
                "score": z_val,
                "context": f"Gap of {abs(s1-s2):.1f} points (Z-Score: {z_val:.1f}). Disconnect between {d1} ({s1:.1f}) and {d2} ({s2:.1f})."
            })

    # --- Step 2: Check Weighted Gaps (Fill Quota) ---
    if len(findings_list) < 2:
        company_items = df_raw[df_raw['company_id'] == company_id].copy()
        
        # Sort by Weighted Impact (Highest First)
        # We assume Phase logic is implicit in the weights, but we can boost 'Foundation' if needed.
        # Here we trust the 'weighted_impact' metric we engineered.
        company_items = company_items.sort_values('weighted_impact', ascending=False)
        
        for _, row in company_items.iterrows():
            if len(findings_list) >= 2: break
            
            # Check if this theme is already covered by an anomaly (roughly)
            # Simple check: avoid duplicates if we had question-level detail in anomaly, but here anomaly is dimension-level.
            # We just add it.
            
            msg_type = "Checklist Gap" if row['question_type'] == 'checklist' else "Maturity Gap"
            
            findings_list.append({
                "type": "Weakness",
                "title": f"Critical Gap: {row['tactical_theme']}",
                "score": row['weighted_impact'],
                "context": f"High Strategic Impact ({row['question_weight']:.1f}). Current Maturity: {row['answer_weight']:.1f}. Type: {msg_type}."
            })
            
    return findings_list
"""

# ------------------------------------------------------------------------------
# 5. Output Generation (LLM Prompt)
# ------------------------------------------------------------------------------
text_output = """## 4. Generating the Consultant's Prompt
We format the findings into a strict prompt object for the LLM, ensuring no raw question text is leaked.
"""

code_output = """def generate_consultant_prompt(company_id):
    findings = get_strategic_analysis(company_id)
    
    # Extract detailed scores for context
    scores = df_dim_features.loc[company_id, [c for c in df_dim_features.columns if not c.startswith('gap_')]].to_dict()
    avg_scores = df_dim_features[[c for c in df_dim_features.columns if not c.startswith('gap_')]].mean().to_dict()
    
    prompt = f\"\"\"
    ### 🎖️ Executive Briefing: Strategic Gap Context (Enhanced for LLM)
    
    **Analysis Metadata:**
    - **Target Company ID:** {{company_id}}
    - **Current Maturity Profile:** {{scores}}
    - **Benchmark Averages:** {{avg_scores}}
    
    **Detected Strategic Findings:**
    - **FINDING 1:** {{findings[0]['title']}} ({{findings[0]['type']}})
      * Context: {{findings[0]['context']}}
      * Severity Score: {{findings[0]['score']:.2f}}
    
    - **FINDING 2:** {{findings[1]['title']}} ({{findings[1]['type']}})
      * Context: {{findings[1]['context']}}
      * Severity Score: {{findings[1]['score']:.2f}}
    
    **Narrative Synthesis Prompt:**
    \"You are a Tier-1 AI Strategy Consultant. Synthesize these 2 specific findings into a cohesive cohesive 'Current State Assessment' for the CEO. 
    Do NOT use list format. Using the Maturity Profile and Benchmark data provided, write 2-3 powerful paragraphs 
    analyzing the structural risks. Specifically, explain how their current maturity levels create either a 
    'Competitive Advantage' or a 'Strategic Debt' that must be addressed immediately.\"
    \"\"\"
    
    return prompt

# Demo
test_cid = df_dim_features.index[42]
print(generate_consultant_prompt(test_cid))
"""

# --- New: User-Facing Synthesis Demo ---
text_synthesis = """## 5. Final Output: The Consultant's Briefing
This is how the findings are translated for the end-user (SME Executive). We use the data from the previous steps to generate a professional, narrative-driven assessment.
"""

code_synthesis = """def synthesize_analysis(company_id):
    findings = get_strategic_analysis(company_id)
    
    # Mocking the LLM output for the purpose of this demonstration
    # In production, the prompt generated in step 4 would be sent to an LLM.
    
    header = f"### 🎖️ AI-Compass Strategic Briefing: Company {company_id}"
    
    finding_1_text = f"**{findings[0]['title']}**: {findings[0]['context']}"
    finding_2_text = f"**{findings[1]['title']}**: {findings[1]['context']}"
    
    narrative = f\"\"\"
{header}

Our analysis of your current AI maturity profile identifies two primary structural risks that require immediate executive attention.

Firstly, we have identified a **{findings[0]['title']}**. {findings[0]['context']} This suggests that your current organizational trajectory may be creating 'Strategic Debt'—where technical capabilities outpace leadership alignment or vice versa. This often leads to wasted budget and internal friction during adoption.

Secondly, the **{findings[1]['title']}** indicates a critical gap in your foundational readiness. Currently, this maturity level ({findings[1]['score']:.1f} impact score) acts as a significant bottleneck. Addressing this specific area will unlock higher ROI for your existing and future AI use cases.

**Strategic Verdict**: Your profile shows high potential but is currently decoupled. Prioritizing these two areas over the next 3 months will transform your AI initiatives from experimental to scalable.
\"\"\"
    return narrative

print(synthesize_analysis(test_cid))
"""

# Assemble
cells = [
    nbf.v4.new_markdown_cell(text_intro),
    nbf.v4.new_code_cell(code_imports),
    nbf.v4.new_markdown_cell(text_data_loading),
    nbf.v4.new_code_cell(code_data_prep),
    nbf.v4.new_markdown_cell(text_gap_analysis),
    nbf.v4.new_code_cell(code_gaps),
    nbf.v4.new_markdown_cell(text_selection_logic),
    nbf.v4.new_code_cell(code_selection),
    nbf.v4.new_markdown_cell(text_output),
    nbf.v4.new_code_cell(code_output),
    nbf.v4.new_markdown_cell(text_synthesis),
    nbf.v4.new_code_cell(code_synthesis)
]
nb.cells.extend(cells)

with open('strategic_gap_analysis.ipynb', 'w') as f:
    nbf.write(nb, f)

print("✓ Jupyter Notebook 'strategic_gap_analysis.ipynb' created successfully.")
