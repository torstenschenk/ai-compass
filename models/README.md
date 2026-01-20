# AI Compass Models API

This folder contains the production-ready API for the AI Compass ML v5 model.

## Production Status

✅ **The API is production-ready!** 

You can now call:
```python
from models.ai_compass_api import analyze_company
result = analyze_company(company_id=46, response_id=46)
```

And it returns a complete JSON response ready for your frontend! 🚀

## Usage

```python
from models.ai_compass_api import analyze_company

# Analyze a company
result = analyze_company(company_id=46, response_id=46)

# Result is a JSON-formatted dict ready for frontend
print(result)
```

## API Response Format

The API returns a comprehensive JSON object with:

- **Company Profile**: Industry, size, etc.
- **Assessment Results**: Dimension scores and total maturity
- **AI Compass Intelligence**:
  - Cluster segment assignment
  - Strategic gap analysis with findings
  - Transformation roadmap with 3 phases
  - Each recommendation includes detailed explanations with:
    - Analysis (1 bullet)
    - Action 1 (1 bullet)
    - Action 2 (1 bullet)

## Models

The API uses trained models from `benchmarking_ai/ml_v5/model_artifacts/v5/`:
- Cluster Engine
- Strategic Gap Analyzer
- Roadmap Generator

## Requirements

- Database connection (via DATABASE_URL or individual env vars)
- Trained ml_v5 models
- Python dependencies: pandas, psycopg2, python-dotenv

## Testing

Run the test script to verify the API:
```bash
python test_api.py
```

This will generate `models/sample_output.json` with a complete example response.
