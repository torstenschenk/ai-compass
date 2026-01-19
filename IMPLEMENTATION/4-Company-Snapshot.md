## 2) Company Snapshot (Create Assessment)

### 2.1 Company Snapshot Form
**Goal:** Capture minimal context + create a draft assessment session.

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
- Button: **Create Assessment**

**Backend**
- `POST /api/v1/assessments`
  - Body:
    ```json
    {
      "company_meta": {
        "company_name": "Acme Ltd",
        "industry": "IT/Software",
        "employee_band": "51-250"
      },
      "lang": "en"
    }
    ```
  - Response:
    ```json
    {
      "assessment_id": "...",
      "access_token": "..."
    }
    ```

**Client behavior**
- Store `access_token` locally (e.g., localStorage):
  - `ai_compass_access_token:{assessment_id} = token`
- Navigate directly into the questionnaire wizard.

**Outcome**
- Assessment is created in DB with `status=draft`.

**Failure states**
- Validation: missing fields → inline errors
- API error → “Could not create assessment” + retry
