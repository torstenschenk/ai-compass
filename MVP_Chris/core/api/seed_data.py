
# Full Questionnaire Seed Data
# Based on dimensions: Strategy, People, Data, Processes, Tech, Use Cases, Governance

DATA = {
    "dimensions": [
        {"name": "Strategy & Business Vision", "weight": 25.0},
        {"name": "People & Culture", "weight": 15.5},
        {"name": "Data Readiness & Literacy", "weight": 18.5},
        {"name": "Processes & Scaling", "weight": 10.0},
        {"name": "Tech Infrastructure", "weight": 10.0},
        {"name": "Use Cases & Business Value", "weight": 14.0},
        {"name": "Governance & Compliance", "weight": 7.0}
    ],
    "questions": [
        # --- Strategy ---
        {
            "dimension": "Strategy & Business Vision",
            "header": "Strategic Alignment",
            "text": "Does your company have a defined AI strategy?",
            "type": "single_choice",
            "weight": 4.5,
            "answers": [
                {"text": "No strategy yet", "level": 1, "weight": 1.0},
                {"text": "Informal discussions only", "level": 2, "weight": 2.0},
                {"text": "In development / Pilot phase", "level": 3, "weight": 3.0},
                {"text": "Defined strategy linked to business goals", "level": 4, "weight": 4.0},
                {"text": "Fully integrated into corporate strategy", "level": 5, "weight": 5.0}
            ]
        },
        {
            "dimension": "Strategy & Business Vision",
            "header": "Leadership",
            "text": "Who is responsible for driving AI initiatives?",
            "type": "single_choice",
            "weight": 4.0,
            "answers": [
                {"text": "No clear ownership", "level": 1, "weight": 1.0},
                {"text": "Individual enthusiasts (Bottom-up)", "level": 2, "weight": 2.0},
                {"text": "IT Department / CTO", "level": 3, "weight": 3.0},
                {"text": "Dedicated Head of AI / CDO", "level": 4, "weight": 4.0},
                {"text": "C-Level with cross-functional committee", "level": 5, "weight": 5.0}
            ]
        },
        {
            "dimension": "Strategy & Business Vision",
            "header": "Budgeting",
            "text": "How is budget allocated for AI projects?",
            "type": "single_choice",
            "weight": 3.5,
            "answers": [
                {"text": "No budget allocated", "level": 1, "weight": 1.0},
                {"text": "Ad-hoc / Experimental budget", "level": 2, "weight": 2.0},
                {"text": "Project-based funding", "level": 3, "weight": 3.0},
                {"text": "Dedicated annual AI budget", "level": 4, "weight": 4.0},
                {"text": "Strategic investment portfolio", "level": 5, "weight": 5.0}
            ]
        },
        # --- People ---
        {
            "dimension": "People & Culture",
            "header": "AI Literacy",
            "text": "How would you rate the general AI literacy of your workforce?",
            "type": "slider",
            "weight": 4.0,
            "answers": [ # Slider mapped to levels
                 {"text": "Low (Skeptical/Unaware)", "level": 1, "weight": 1.0},
                 {"text": "Basic Awareness", "level": 2, "weight": 2.0},
                 {"text": "Some Skilled Users", "level": 3, "weight": 3.0},
                 {"text": "Broad Proficiency", "level": 4, "weight": 4.0},
                 {"text": "High (AI Native Culture)", "level": 5, "weight": 5.0}
            ]
        },
        {
            "dimension": "People & Culture",
            "header": "Training",
            "text": "Do you offer AI training and upskilling programs?",
            "type": "single_choice",
            "weight": 3.5,
            "answers": [
                {"text": "None", "level": 1, "weight": 1.0},
                {"text": "Ad-hoc / Self-learning encouraged", "level": 2, "weight": 2.0},
                {"text": "Basic workshops / Webinars", "level": 3, "weight": 3.0},
                {"text": "Structured training for specific roles", "level": 4, "weight": 4.0},
                {"text": "Comprehensive academy & certifications", "level": 5, "weight": 5.0}
            ]
        },
        # --- Data ---
        {
            "dimension": "Data Readiness & Literacy",
            "header": "Data Availability",
            "text": "Is your data accessible and centralized?",
            "type": "single_choice",
            "weight": 4.5,
            "answers": [
                {"text": "Siloed / Paper-based / Hard to access", "level": 1, "weight": 1.0},
                {"text": "Mostly siloed digital fragments", "level": 2, "weight": 2.0},
                {"text": "Data Warehouse exists but limited access", "level": 3, "weight": 3.0},
                {"text": "Centralized Data Lake / Warehouse", "level": 4, "weight": 4.0},
                {"text": "Democratized real-time data access", "level": 5, "weight": 5.0}
            ]
        },
        {
            "dimension": "Data Readiness & Literacy",
            "header": "Data Quality",
            "text": "How reliable is your data for AI models?",
            "type": "single_choice",
            "weight": 4.0,
            "answers": [
                {"text": "Unknown / Poor", "level": 1, "weight": 1.0},
                {"text": "Inconsistent, requires heavy cleaning", "level": 2, "weight": 2.0},
                {"text": "Acceptable for basic reporting", "level": 3, "weight": 3.0},
                {"text": "Good, with some governance", "level": 4, "weight": 4.0},
                {"text": "High quality, automated validation", "level": 5, "weight": 5.0}
            ]
        },
        # --- Tech ---
        {
            "dimension": "Tech Infrastructure",
            "header": "Cloud & Compute",
            "text": "What does your technical setup look like?",
            "type": "single_choice",
            "weight": 3.5,
            "answers": [
                {"text": "Legacy on-prem only", "level": 1, "weight": 1.0},
                {"text": "Hybrid / basic cloud usage", "level": 2, "weight": 2.0},
                {"text": "Cloud-first for new apps", "level": 3, "weight": 3.0},
                {"text": "Scalable Cloud Native architecture", "level": 4, "weight": 4.0},
                {"text": "Cutting edge (MLOps, Serverless)", "level": 5, "weight": 5.0}
            ]
        },
        {
            "dimension": "Tech Infrastructure",
            "header": "Tools",
            "text": "Which AI tools are currently in use?",
            "type": "multi_choice", # Checklist
            "weight": 3.0,
            "answers": [
                {"text": "ChatGPT / GenAI (Individual accounts)", "level": 0, "weight": 0.5},
                {"text": "Copilot / Enterprise GenAI", "level": 0, "weight": 1.0},
                {"text": "AutoML tools", "level": 0, "weight": 1.0},
                {"text": "Custom ML Models (Python/R)", "level": 0, "weight": 1.5},
                {"text": "MLOps Platform", "level": 0, "weight": 2.0}
            ]
        },
         # --- Use Cases ---
        {
             "dimension": "Use Cases & Business Value",
             "header": "Deployment",
             "text": "How many AI use cases are in production?",
             "type": "single_choice",
             "weight": 5.0,
             "answers": [
                 {"text": "None", "level": 1, "weight": 1.0},
                 {"text": "Proof of Concepts (PoCs) only", "level": 2, "weight": 2.0},
                 {"text": "1-2 Pilots live", "level": 3, "weight": 3.0},
                 {"text": "Multiple use cases in production", "level": 4, "weight": 4.0},
                 {"text": "AI at scale across core business", "level": 5, "weight": 5.0}
             ]
        },
        # --- Governance ---
        {
            "dimension": "Governance & Compliance",
            "header": "Ethics & Security",
            "text": "How do you handle AI ethics and data privacy?",
            "type": "single_choice",
            "weight": 3.0,
            "answers": [
                {"text": "Not addressed yet", "level": 1, "weight": 1.0},
                {"text": "Basic GDPR compliance only", "level": 2, "weight": 2.0},
                {"text": "Internal guidelines exist", "level": 3, "weight": 3.0},
                {"text": "Formal AI Ethics Board / Policy", "level": 4, "weight": 4.0},
                {"text": "Automated compliance & auditing", "level": 5, "weight": 5.0}
            ]
        },
        # --- Process ---
        {
            "dimension": "Processes & Scaling",
            "header": "Agility",
            "text": "How agile are your development processes?",
            "type": "single_choice",
            "weight": 3.0,
            "answers": [
                {"text": "Traditional Waterfall", "level": 1, "weight": 1.0},
                {"text": "Mix of Agile and Waterfall", "level": 2, "weight": 2.0},
                {"text": "Agile (Scrum/Kanban) adopted", "level": 3, "weight": 3.0},
                {"text": "DevOps culture established", "level": 4, "weight": 4.0},
                {"text": "Continuous Delivery & Learning", "level": 5, "weight": 5.0}
            ]
        }
    ]
}
