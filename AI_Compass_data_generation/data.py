import pandas as pd
import numpy as np
import random

# 1. Configuration: Define Cluster Counts (L2 > L3 > L1 > L4 > L5)
clusters = {
    "1. The Traditionalist": {"count": 100, "base_level": 1},
    "2. The Curious Experimenter": {"count": 200, "base_level": 2},
    "3. The Structured Builder": {"count": 125, "base_level": 3},
    "4. The Value Scaler": {"count": 60, "base_level": 4},
    "5. The AI-Enabled Leader": {"count": 15, "base_level": 5}
}

# 2. Metadata from your Miro Tables
industries = ["Manufacturing", "Retail", "Healthcare", "Finance", "Services", "Logistics", "Tech SME"]
cities = ["Berlin", "Munich", "Hamburg", "Cologne", "Frankfurt", "Stuttgart"]
challenges = ["Customer Service Efficiency", "Task Automation", "Data Insights", "Search/Recommendations", "Document Processing", "Cost Reduction"]

# 3. Question Mapping (Derived from your 3 Miro Tables)
# Includes Strategy, Use Cases, Tech, Processes, and Psychology
questions = [
    "Motivation_for_AI", "Leadership_Alignment", "AI_Strategy_Cohesion", "Market_Hype_Impact",
    "Responsibility_Ownership", "AI_Budget_Allocation", "Compliance_Feasibility", 
    "Use_Case_Prioritization", "Business_Value_Tracking", "Operational_Integration",
    "Data_Collection_Breadth", "Data_Quality_Management", "Data_Accessibility", 
    "Cloud_Infrastructure", "Tooling_BI_Adoption", "API_Integration_Level",
    "Project_Mgmt_Effectiveness", "Deployment_Speed", "Scaling_Capability",
    "Workforce_AI_Skills", "Leadership_AI_Familiarity", "Training_Programs",
    "Psychological_Safety", "Internal_Innovation_Push", "Change_Mgmt_Readiness",
    "AI_Ethics_Awareness", "Vendor_Partnership_Mgmt", "Continuous_Model_Monitoring",
    "Data_Security_Standards", "Collaboration_IT_Business", "Customer_Data_Usage",
    "Employee_Data_Usage", "Operational_Metrics_Usage", "Automation_Degree", "Future_AI_Investment"
]

data_rows = []

# 4. Data Generation Logic
for cluster_name, config in clusters.items():
    for _ in range(config["count"]):
        base = config["base_level"]
        
        # Company Profile (Table 2)
        row = {
            "Company_ID": f"CMP-{random.randint(1000, 9999)}",
            "Cluster_Profile": cluster_name,
            "Industry": random.choice(industries),
            "Employees": random.choice(["1-50", "51-250", "251-500"]) if base < 4 else random.choice(["251-500", "500+"]),
            "City": random.choice(cities),
            "Primary_Challenge": random.choice(challenges)
        }
        
        # Maturity Level Generation (Tables 1 & 3)
        for q in questions:
            # Probability Matrix: 70% chance for base level, 20% for +/- 1, 10% for outliers
            levels = [1, 2, 3, 4, 5]
            weights = []
            for lvl in levels:
                dist = abs(lvl - base)
                if dist == 0: weights.append(0.70)
                elif dist == 1: weights.append(0.20)
                else: weights.append(0.033) # Distribute remaining 10%
            
            # Normalize and pick
            normalized_weights = [w/sum(weights) for w in weights]
            row[q] = np.random.choice(levels, p=normalized_weights)
            
        data_rows.append(row)

# 5. Export to CSV
df = pd.DataFrame(data_rows)
df.to_csv("maturity_assessment_data.csv", index=False)

print(f"Successfully generated {len(df)} observations.")
print(df['Cluster_Profile'].value_counts())