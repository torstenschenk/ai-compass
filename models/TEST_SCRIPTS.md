# Models Folder - Test Scripts

This directory contains the production API and test scripts.

## Files

### ai_compass_api.py
Production API endpoint for ML v5 analysis.

**Usage:**
```python
from models.ai_compass_api import analyze_company
result = analyze_company(company_id=46, response_id=46)
```

---

### test_api.py
Test script for the AI Compass API.

**Usage:**
```bash
python models/test_api.py
```

**What it does:**
- Tests the API with company 46
- Generates `models/sample_output.json` with complete API response
- Displays preview of the output

---

### sample_output.json
Example API response showing the complete JSON structure including:
- Company profile
- Assessment results with dimension scores
- Cluster segment with industry percentile
- Strategic gap analysis
- Transformation roadmap with theme-specific explanations
