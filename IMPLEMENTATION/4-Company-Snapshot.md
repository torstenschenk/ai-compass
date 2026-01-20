## 2) Company Snapshot (Create Response)

### 2.1 Company Snapshot Form
**Goal:** Capture minimal context + create a draft response session.

**Fields**
1. **Company Name** (text input) — required
2. **Industry** (dropdown) — required  
   - Example values (MVP): Manufacturing, Retail, Healthcare, Finance, Services, Logistics, IT/Software, Other
3. Website (text) 
4. **Employee Band** (dropdown) 
   - Classic ranges:
      - 1–10
      - 11–50
      - 51–250
      - 251–1000
      - 1000+
5.  City (text)


**Actions**
- Button: **Start Assessment**

**Backend**
- `POST /api/v1/responses`
  - Body:
    ```json
    {
      "company": {
        "company_name": "Acme Ltd",
        "industry": "IT/Software",
        "website": "https://acme.com",
        "city": "Berlin",
        "number_of_employees": "51-250",
        "email": "contact@acme.com"
      }
    }
    ```
  - Response:
    ```json
    {
      "response_id": 123,
      "access_token": "..."
    }
    ```

**Backend behavior**
- Creates row in `companies` table with provided company fields
- Creates row in `responses` table:
  - `company_id` = newly created company ID
  - `total_score` = NULL (initially)
  - `cluster_id` = NULL (initially)
  - `created_at` = NOW()
- Returns `response_id` and `access_token`

**Client behavior**
- Store `access_token` locally (e.g., localStorage):
  - `ai_compass_access_token:{response_id} = token`
- Navigate directly into the questionnaire wizard.

**Outcome**
- Response is created in DB with NULL scores (to be computed on completion).

**Failure states**
- Validation: missing fields → inline errors
- API error → "Could not create response" + retry
