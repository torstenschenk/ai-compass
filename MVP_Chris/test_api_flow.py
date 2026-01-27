import requests
import json
import sys

BASE_URL = "http://127.0.0.1:8000/api/v1"

def test_flow():
    # 1. Create Response
    print("Creating Response...")
    
    payload = {
        "company": {
            "company_name": "ML Integration Test Co",
            "industry": "Software",
            "website": "example.com",
            "number_of_employees": "100-500",
            "city": "Remote"
        }
    }

    try:
        resp = requests.post(f"{BASE_URL}/responses", json=payload)
        if resp.status_code != 200:
            print(f"Failed to create response: {resp.text}")
            return
        
        data = resp.json()
        response_id = data["response_id"]
        print(f"Response ID: {response_id}")

        # 2. Fetch Questionnaire to get valid IDs
        print("Fetching Questionnaire to get valid Q/A IDs...")
        q_resp = requests.get(f"{BASE_URL}/questionnaire")
        if q_resp.status_code != 200:
            print(f"Failed to fetch questionnaire: {q_resp.text}")
            return
            
        dimensions = q_resp.json()
        
        # Construct answers for first few questions
        items = []
        for dim in dimensions:
            for q in dim['questions']:
                # Pick first answer if available
                if q['answers'] and len(q['answers']) > 0:
                   items.append({
                       "question_id": q['id'],
                       "answer_ids": [q['answers'][0]['id']]
                   })
        
        print(f"Submitting {len(items)} Items...")
        
        # 3. Submit Items
        save_resp = requests.post(f"{BASE_URL}/responses/{response_id}/items", json={"items": items})
        if save_resp.status_code != 200:
            print(f"Failed to save items: {save_resp.text}")
            return
        print("Items saved.")

        # 4. Complete Response (Triggers ML)
        print("Completing Response (Running ML)...")
        comp_resp = requests.post(f"{BASE_URL}/responses/{response_id}/complete")
        if comp_resp.status_code != 200:
            print(f"Failed to complete: {comp_resp.text}")
            return
        
        result = comp_resp.json()
        print("Completion Result:", json.dumps(result, indent=2))
        
        # 5. Get Summary
        print("Fetching Summary...")
        sum_resp = requests.get(f"{BASE_URL}/responses/{response_id}")
        if sum_resp.status_code != 200:
            print(f"Failed to get summary: {sum_resp.text}")
            return
        
        summary = sum_resp.json()
        print("Summary Retrieved successfully.")
        # print("Summary:", json.dumps(summary, indent=2)) # Too verbose

    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    test_flow()
