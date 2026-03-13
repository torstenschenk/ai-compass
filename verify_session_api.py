import requests
import json
import sys

BASE_URL = "http://localhost:8000/api/v1"

def test_session_flow():
    print("--- Starting Session API Flow Test ---")
    
    # 1. Create Session
    company_data = {
        "company_name": "Test Labs",
        "industry": "Technology",
        "website": "http://testlabs.com",
        "number_of_employees": "50-100",
        "city": "Berlin",
        "email": "test@testlabs.com"
    }
    
    print(f"1. Creating session with data: {company_data['company_name']}")
    resp = requests.post(f"{BASE_URL}/sessions", json=company_data)
    if resp.status_code != 200:
        print(f"FAILED: Create Session returned {resp.status_code}")
        print(resp.text)
        return
    
    session = resp.json()
    session_id = session['session_id']
    print(f"SUCCESS: Created session {session_id}")
    
    # 2. Save Answer
    answer_data = {
        "question_id": 1,
        "answer_ids": [101]
    }
    print(f"2. Saving answer for question 1")
    resp = requests.patch(f"{BASE_URL}/sessions/{session_id}/items", json=answer_data)
    if resp.status_code != 200:
        print(f"FAILED: Save Answer returned {resp.status_code}")
        return
    print("SUCCESS: Answer saved")
    
    # 3. Complete Assessment
    print(f"3. Completing assessment")
    resp = requests.post(f"{BASE_URL}/sessions/{session_id}/complete")
    if resp.status_code != 200:
        print(f"FAILED: Complete Assessment returned {resp.status_code}")
        print(resp.text)
        return
    print("SUCCESS: Assessment completed")
    
    # 4. Get Results
    print(f"4. Getting results")
    resp = requests.get(f"{BASE_URL}/sessions/{session_id}/results")
    if resp.status_code != 200:
        print(f"FAILED: Get Results returned {resp.status_code}")
        print(resp.text)
        return
    
    results = resp.json()
    print(f"SUCCESS: Results fetched. Score: {results['overall_score']}")
    print(f"Company in results: {results['company']['name']}")
    
    # 5. Delete Session
    print(f"5. Deleting session")
    resp = requests.delete(f"{BASE_URL}/sessions/{session_id}")
    if resp.status_code != 200:
        print(f"FAILED: Delete Session returned {resp.status_code}")
        return
    print("SUCCESS: Session deleted")

    print("\n--- All API Tests Passed ---")

if __name__ == "__main__":
    test_session_flow()
