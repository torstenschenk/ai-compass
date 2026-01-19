# AI-Compass User Journey (MVP) — React + FastAPI + Postgres

**Scope decisions locked in (per your latest inputs):**
- ✅ Autosave: **yes (asynchronous)**
- ✅ Language: **English only** (no language switch)
- ✅ Token: **store locally** (browser storage recommended: localStorage*)
- ✅ Snapshot fields: **Company Name (text)**, **Industry (dropdown)**, **Website (text)**, **City(text)**, **Employee Band (dropdown: classic ranges)**
- ✅ Export: **PDF only**
- ✅ Completion: **Automatic** — assessment becomes **completed when the last question is answered**
- ✅ Wizard UI: **One question per screen**
- ✅ Final button label: On the last required question, the button is Finish (instead of Next). After finishing the required section, the user can optionally continue via Optional Questions to answer additional (non-mandatory) questions. The optional section also ends with Finish, which then triggers the final calculation/results generation.
- ✅ Terminology: For each answered question, a level-based score is calculated using the answer’s points and the question weight stored in the database. These scores are aggregated to compute the AI maturity score, which is then mapped into one of five company clusters.

  
---

## 1) Entry & Start

### 1.1 Landingpage / Home
**User intent:** Get quick, credible clarity on AI readiness and next steps.

**UI elements**
- Value proposition:  scoring, explainable drivers, benchmark context, executive-ready 
   - navigation
   - hero section
   - value proposition
   - three step process
   - outcome preview
   - CTA: **Start Assessment**
   - footer

**Outcome**
- User starts the assessment flow.

---

## 2) Company Snapshot (Create Assessment)


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
  - Shows all 7 dimensions tbd
  - For each overall: answered questions count, and completion status
  - Example: `overall 2/3` (complete indicator when all answered)
- **One question only**
  - Single choice (statement, slider, choice) → radio
  - Multi choice (checklist) → selectable chips/tags

**Navigation controls**
- Buttons: **Back** and **Next**
- On the last question: **Finish** instead of Next
- **Next/Finish is disabled** until:
  - Radio: an option is selected
  - Multi choice: at least one option is checked (and within max_select if applicable)
 
- additional button Optional questions after last optional question finish button instead of next
- buttons are always enabled

  
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

## 6) Results Page (Analysis and Recommendations)

### 6.1 Results Page
**Goal:** Recive instant analysis on AI-Readyness and provide immediate roadmap and action plan.

**UI components**
- navigation
- header
  - Title & subtitle
  - Overall score (0–100) + **cluster profile** + percentile
- cluster profile (Bar chart -> sorted low → high)
- The Multi-Dimensional Maturity Profile (Radar chart all 7 dimensions)
- Strategic gap analysis
- Roadmap
- Expert Consultation & Next Steps
- Download Report 
- footer

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
- header
  - Title & subtitle
  - Overall score (0–100) + **cluster profile** + percentile
- cluster profile (Bar chart -> sorted low → high)
- The Multi-Dimensional Maturity Profile (Radar chart all 7 dimensions)
- Strategic gap analysis
- Roadmap
- Expert Consultation & Next Steps
- Footer with versions:
  - scoring_engine_version, ml_model_version, llm_prompt_version, llm_model_name

**Outcome**
- User has a shareable report.


## 8) Primary Happy Path (One-line)

Landing Page → Company Snapshot → Wizard (one-question screens + async autosave) → Results → Download PDF

