# AI-Compass User Journey (MVP) — React + FastAPI + Postgres

**Scope decisions locked in (per your latest inputs):**
- ✅ Autosave: **yes (asynchronous)**
- ✅ Language: **English only** (no language switch)                            *?1
- ✅ Token: **store locally** (browser storage recommended: localStorage*)
- ✅ History: **yes**                                                           *?2
- ✅ Snapshot fields: **Company Name (text)**, **Industry (dropdown)**, **Employee Band (dropdown: classic ranges)**
- ✅ Export: **PDF only**
- ✅ Completion: **Automatic** — assessment becomes **completed when the last question is answered**
- ✅ Wizard UI: **One question per screen**
- ✅ Final button label: **Finish** (instead of Next) on the last question
- ✅ Terminology: maturity levels are called **clusters** in the UI

---

## 1) Entry & Start

### 1.1 Landing / Home
**User intent:** Get quick, credible clarity on AI readiness and next steps.

**UI elements**
- Value proposition: deterministic scoring, explainable drivers, benchmark context, executive-ready PDF
- CTA: **Start Assessment**
- Secondary CTA (optional): **View Sample PDF** (static)

**Outcome**
- User starts the assessment flow.

---

## 2) Company Snapshot (Create Assessment)

### 2.1 Company Snapshot Form
**Goal:** Capture minimal context + create a draft assessment session.

**Fields**
1. **Company Name** (text input) — required
2. **Industry** (dropdown) — required  
   - Example values (MVP): Manufacturing, Retail, Healthcare, Finance, Services, Logistics, IT/Software, Other
3. **Employee Band** (dropdown) — required  
   - Classic ranges, e.g.:
   - 1–10
   - 11–50
   - 51–250
   - 251–1000
   - 1000+

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

---

## 3) Load Questionnaire (Schema-driven)

### 3.1 Questionnaire Fetch
**Goal:** Load the currently active questionnaire schema (English).

**Backend**
- `GET /api/v1/questionnaires`

**Client behavior**
- Cache schema in memory (or short-lived cache), keyed by `questionnaire_hash`.

**Outcome**
- UI can render the wizard from schema (no hardcoded IDs).

---

## 4) Assessment Wizard (7 Dimensions, One Question per Screen, Async Autosave)

### 4.1 Wizard Structure (One-question screens)
**Goal:** Let the user focus on a single decision at a time; keep progress transparent.

**UI (per screen)**
- **Dimension title** as header (always visible)
- **Progress / Status Bar**:
  - Shows all 7 dimensions
  - For each dimension: answered questions count, and completion status
  - Example: `Data Maturity 2/3` (complete indicator when all answered)
- **One question only**
  - Single choice → radio
  - Multi choice → selectable chips/tags

**Navigation controls**
- Buttons: **Back** and **Next**
- On the last question: **Finish** instead of Next
- **Next/Finish is disabled** until:
  - Radio: an option is selected
  - Multi choice: at least one option is checked (and within max_select if applicable)

---

### 4.2 Async Autosave Rules (non-blocking UX)
**Principle:** UI never “waits” for saving to allow navigation; saving runs asynchronously.

**Behavior**
- When user selects/toggles options:
  1. UI state updates immediately
  2. An async save request is fired in the background
  3. A small status indicator reflects state:
     - `Saving…` → `Saved ✓` → `Save failed (retrying…)`

**Retry behavior**
- On transient failures: automatic retries with exponential backoff
- If persistent failure: show clear error + prevent completion (Finish) until the last save is confirmed

---

### 4.3 Persisting Responses (analytics-safe, uniquely stored)
**Backend**
- `POST /api/v1/assessments/{assessment_id}/responses?token={access_token}`
  - Body example:
    ```json
    {
      "responses": [
        {
          "question_key": "sbv_01_strategy_defined",
          "selected_option_keys": ["sbv_01_o3"]
        }
      ]
    }
    ```

**Backend rules**
- Validate question/option keys exist in the assessment’s questionnaire hash/version
- Upsert per question for this assessment
- Persist all entities uniquely so future analysis is always possible:
  - questionnaire (versioned)
  - dimension
  - question
  - option
  - response + selections

**Outcome**
- Every answered question is persisted in a structured, queryable format.

---

## 5) Completion (Automatic at the last question)

### 5.1 Finish Action
**Goal:** User completes the assessment without a separate review step.

**Trigger**
- User clicks **Finish** on the last question (only enabled if answered and saved)

**Backend**
- `POST /api/v1/assessments/{assessment_id}/complete?token={access_token}`

**Backend orchestration**
1. Deterministic scoring → store in `maturity_scores`
2. ML benchmarking (K-Means) → store in `benchmark_cluster_result`
3. LLM recommendations (Groq) → strict JSON validation → cache in `llm_enrichment_cache`
   - If invalid / failure: deterministic fallback template
4. Update assessment `status=completed`, set `completed_at`

**Outcome**
- User is redirected to the Results page immediately after completion.

**Failure states**
- If final save is not confirmed: Finish remains disabled / blocked with “Waiting for save…”
- LLM unavailable: completion still succeeds using fallback recommendations

---

## 6) Results Dashboard (Decision Clarity)

### 6.1 Results Page
**Goal:** Provide immediate clarity and action plan.

**UI components**
- Overall score (0–100) + **cluster (1–5)**  *(label in UI: “Cluster”, not “Level”)*
- Dimension scores table (7 items) + **cluster** per dimension
- Radar chart (all 7 dimensions)
- Bar chart (sorted low → high)
- Top Focus Areas (lowest 3 dimensions)
- Drivers per dimension (2–3 lowest-scoring questions):
  - question text
  - selected labels (array)
  - points

**Benchmark panel**
- peer cluster label
- percentile
- mismatch note (if mismatch_flag=true)

**Recommendations panel**
- Executive summary
- Quick wins (0–30 days)
- Roadmap: 90 days / 6 months / 12 months
- Risks

**Data source**
- `GET /api/v1/assessments/{assessment_id}?token={access_token}`

**Outcome**
- User sees “where we are” and “what to do next” without ambiguity.

---

## 7) PDF Export (Only Export Channel)

### 7.1 Download PDF
**Goal:** Produce a consulting-ready artifact.

**Action**
- Button: **Download PDF**

**Backend (Option B)**
- `GET /api/v1/assessments/{assessment_id}/pdf?token={access_token}`

**PDF contents**
- Title page (company name, date, questionnaire version/hash)
- Overall score + **cluster**
- Dimension breakdown + drivers
- Benchmark section
- Recommendations
- Footer with versions:
  - scoring_engine_version, ml_model_version, llm_prompt_version, llm_model_name

**Outcome**
- User has a shareable report.

---

## 8) History (Multiple Assessments per Company)

### 8.1 History List
**Goal:** Allow users to view and reopen prior assessments.

**UI**
- List items show:
  - company name
  - created_at / completed_at
  - overall score + cluster (if completed)
  - status (draft/completed)
  - actions: **Open**, **Download PDF** (if completed)

**Backend**
- `GET /api/v1/assessments?company_name=...&limit=...&offset=...&status=...&token={access_token}`
  - If you don’t want filtering initially:
    - `GET /api/v1/assessments?limit=20&offset=0&token={access_token}`

**Outcome**
- User can run multiple assessments over time and retrieve them reliably.

---

## 9) Key UX Rules (MVP)

1. **English only**: no language switching.
2. **One question per screen**: dimension is always visible as header.
3. **Async autosave**: UI remains responsive; background saving with retry.
4. **Next/Finish gated by answer**:
   - Radio: selection required
   - Multi: at least one checked required
5. **Completion is automatic**:
   - No separate “Review & Complete”
   - Completion happens via **Finish** on the last question
6. **PDF is the only export**.
7. **Auditability is visible**: show questionnaire hash/version somewhere (e.g., small “Details” section).

---

## 10) Primary Happy Path (One-line)

Home → Company Snapshot → Wizard (one-question screens + async autosave) → Finish → Results → Download PDF → History





---
Legende:
- localStorage = Browser Storage (recommended because it is persistent also if the user closes the browser)
- sessionStorage = Browser Storage (not recommended because it is only persistent for the current session)


---
Questions:
  - Option A: `Authorization: Bearer {access_token}`
  - Option B: `?token={access_token}`
  difference between the two options: 
    - Option A: is more secure, has less risk of being exposed and is more reliable 
    - Option B: is less secure, has more risk of being exposed and is less reliable 

- *?1
    did we need more than one language?
- *?2
    did we want to have a history of the assessments?
    