"""
Test script for AI Compass API
Run this to generate sample JSON output
"""

from models.ai_compass_api import analyze_company
import json

# Test with company 46
print("Testing AI Compass API...")
print("Analyzing company 46...")

try:
    result = analyze_company(company_id=46, response_id=46)
    
    # Save to file
    with open('models/sample_output.json', 'w', encoding='utf-8') as f:
        json.dump(result, f, indent=2)
    
    print("\nSuccess! Output saved to models/sample_output.json")
    print(f"\nPreview (first 1000 characters):")
    print(json.dumps(result, indent=2)[:1000])
    
except Exception as e:
    print(f"\nError: {e}")
    import traceback
    traceback.print_exc()
