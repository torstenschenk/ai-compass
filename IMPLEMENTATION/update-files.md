# Prompt for Claude — Update IMPLEMENTATION Docs (1–8.7) to Fixed DB Schema

You are editing a set of Markdown implementation specs located in a folder named `IMPLEMENTATION` with files numbered `1` to `8.7` (e.g., `0-USER-Journey.md`, `4-Company-Snapshot.md`, `5-Load-Questionnaire.md`, `6-Survey.md`, `7-Completion.md`, `8.0-Results-Page.md`, and at least every one with a number in the beginning of file mame.).

analyse first the 0-USER-Journey.md to have a overview to the entire project

## Objective
Refactor ALL docs so they match our FIXED Postgres schema below. The team will NOT change DB tables/columns because the ML model was trained on it.

### Fixed DB Schema (do not propose schema changes)
Tables:
- `companies(company_id, industry, website, number_of_employees, city, company_name, email)`
- `dimensions(dimension_id, dimension_name, dimension_weight)`
- `questions(question_id, dimension_id, header, question_text, type, weight, optional)`
- `answers(answer_id, question_id, answer_text, answer_level, answer_weight)`
- `responses(response_id, company_id, total_score, created_at, cluster_id)`
- `response_items(item_id, response_id, question_id, answers integer[])`
- `cluster_profiles(cluster_id, cluster_name, score_min, score_max)`

FKs:
- questions.dimension_id -> dimensions.dimension_id
- answers.question_id -> questions.question_id
- responses.company_id -> companies.company_id
- response_items.response_id -> responses.response_id
- response_items.question_id -> questions.question_id
- responses.cluster_id -> cluster_profiles.cluster_id

## Key Product Decisions (must be reflected everywhere)
- Frontend: React
- Backend: FastAPI
- DB: Postgres (schema above)
- Language: English only (no language switch)
- Autosave: yes, asynchronous (non-blocking UI) save just in session state for every answered question
- Wizard: one question per screen; dimension title always visible
- Completion: automatic when the last question is answered then store everything in db
- Required vs Optional:
  - Required section ends with a **Finish** button (instead of Next)
  - After required Finish, user may continue via **Optional Questions**
  - Optional section also ends with **Finish**, which triggers the final calculation/results generation
- Export: PDF only
- Token: stored locally in browser storage (localStorage recommended)

## Critical Terminology Alignment (replace everywhere)
We DO NOT have an `assessments` table.
- Replace the concept “assessment” with:
  - `response` (session/run) in DB terms
  - `response_id` is the main identifier used by API and frontend
- “Assessment answers” become `response_items`
- Multi-select is represented as `response_items.answers` (integer array)
- Questions & options are loaded from DB tables, NOT from a JSON schema file:
  - `questions` provides the question and metadata
  - `answers` provides selectable options and scoring parameters

## Required Doc Updates (apply to all files 1–8.7)

### 1) Replace all Assessment-based API contracts with Response-based contracts
Wherever docs mention:
- `assessment_id` => change to `response_id`
- `assessments` table => change to `responses`
- endpoints like `/assessments/...` => rewrite as `/responses/...` (see endpoint design below)

### 2) Update “Load Questionnaire” section: DB-driven, not JSON schema
Old approach (schema_json, questionnaire_versions, etc.) must be removed or rewritten.
New approach:
- Questionnaire is derived from DB content:
  - Dimensions: `dimensions` (ordered as provided or by id)
  - Questions: `questions` joined to dimensions
  - Options: `answers` joined to questions
- Must support required vs optional:
  - `questions.optional = false` => required flow
  - `questions.optional = true` => optional flow (accessible only after required Finish)

Minimum required payload returned to frontend:
- dimensions: id, name, weight
- questions: id, dimension_id, header, question_text, type, weight, optional
- answers/options: id, question_id, answer_text, answer_level, answer_weight

### 3) Autosave & persistence must map to response_items
Autosave endpoint must upsert per (response_id, question_id):
- Insert or update `response_items` row:
  - `answers = [answer_id, ...]` (int array)
Rules:
- For single choice: exactly one answer_id in array
- For multi choice: 1..n answer_ids in array
- Validation: every answer_id must belong to that question_id
- autosave in session state until survey is not completed

### 4) Completion orchestration must map to responses / cluster_profiles
On completion (Finish):
- first save all responses in db from the session state
- Compute total score from saved response_items by joining answers + questions:
  - Each selected answer contributes:
    - base points/level: `answers.answer_level` (or answer_weight if that’s your scoring basis)
    - per-question weight: `questions.weight`
    - (optional) per-answer weight: `answers.answer_weight`
- Store computed values:
  - `responses.total_score` (use numeric stored as string if DB fixed; document conversion explicitly)
  - Determine `cluster_id` by matching total score against `cluster_profiles.score_min/score_max`
  - Update `responses.cluster_id`
- created_at already exists; if you need “completed_at” it must be handled in app layer (cannot add column)

### 5) Results page data source must be response-centric this:
Results endpoint must fetch:### 2) Company Snapshot (4-Company-Snapshot.md)
- Snapshot fields: company_name, industry, website, city, number_of_employees (employee band)
- On submit:
  - Create company row in `companies`
  - Create response row in `responses` with `company_id`, `created_at`, cluster_id NULL initially, total_score NULL initially
- Return `response_id` (+ token if your API uses it, but mention token is app-layer).

### 3) Load Questionnaire (5-Load-Questionnaire.md)
- Replace any JSON/schema_hash references with DB-driven loading:
  - GET endpoint returns nested structure assembled from:
    - dimensions → questions → answers
- Ordering:
  - If no explicit order columns exist, define deterministic ordering:
    - dimensions ordered by dimension_id
    - questions ordered by question_id within dimension
    - answers ordered by answer_id within question
- Must include `optional` attribute per question to support Required vs Optional flow.

### 4) Survey/Wizard (6-Survey.md)
- Autosave writes into `response_items`:
  - Upsert rule: one row per (response_id, question_id)
  - Save payload uses `answer_id` list (int array), not option_key
- Next/Finish gating:
  - Next enabled only if selection exists
  - Finish enabled only if last answered AND last save confirmed
- Required vs Optional:
  - Wizard runs required questions first (`optional=false`)
  - After last required question: show Finish (finalize required) AND Optional Questions button
  - Optional Questions starts optional question flow (`optional=true`)
  - Optional flow ends with Finish triggering final calculation

### 5) Completion (7-Completion.md)
- Replace “complete assessment” with “finalize response”.
- Completion endpoint uses response_id:
  - POST /api/v1/responses/{response_id}/complete?token=...
- Backend orchestration must write results back into existing tables only:
  - `responses.total_score` (store numeric as string if unavoidable; document format e.g. "2.6")
  - `responses.cluster_id` (FK to cluster_profiles)
- If you need benchmark, gap analysis, roadmap, etc.:
  - Document that these are computed dynamically at request time OR stored externally (but do NOT add DB tables).
- Explicitly note: “No separate review step; completion occurs via Finish”.

### 6) Results Page (8.0-Results-Page.md and 8.1–8.6)
**Critical change:** Results page data source must be response-centric.

Update all Results sections to fetch everything by response_id:
- GET /api/v1/responses/{response_id}/results?token=...

This endpoint must provide data for these sections:

2) Header (Executive Results Dashboard Header) (8.1-Header.md)
- Title + subtitle
- 3 data cards:
  - Total Overall Score (**2.6/5**) — derived from responses.total_score
  - Company Cluster — derived from responses.cluster_id join cluster_profiles
  - Percentile — dynamic, includes industry context (companies.industry)

3) Cluster Profile Visualization (8.2-Cluster-Profile.md)
- 5-bar chart (low → high), active cluster highlighted
- Description cards for all 5 clusters, active one highlighted
- Active cluster comes from responses.cluster_id

4) Multi-Dimensional Radar Chart (8.3-Multi-Dimensional-Radar-Chart.md)
- 7 dimensions: Strategy, People, Data, Use Cases, Processes, Compliance, Tech
- “Your Company” dimension scores are computed from response_items + questions/answers weights
- “Peer Benchmark” is the average across ALL companies in DB (all responses), optionally filtered by industry if you specify it
- Return radar dataset structure:
  - [{ dimension: "Strategy", userScore: x, peerScore: y }, ...] on a 1–5 scale

5) Strategic Gap Analysis (8.4-Strategic-Gap-Analysis.md)
- Must be derived from response-centric scores and peer averages
- Output exactly 2 gaps (status quo + strategic risk format) as defined in the spec
- If your previous spec referenced z-scores or checklist tables, adapt logic to existing schema only (no new tables):
  - Use dimension-level deltas computed from response + peer averages
  - For “missing checklist items” concept: treat specific questions/answers as checklist proxies using question type or answer_level thresholds

6) Roadmap (8.5-Roadmap.md)
- Must synthesize from:
  - gap analysis outputs
  - peer lookalike trajectories computed from existing responses dataset
- Output 3 phases with “Must-Win” and “Peer-Based” recommendations
- Ensure no recommendation is marked “complete” if the response already indicates completion (derive from answers)

7) Expert Consultation & Next Steps (8.6-Expert-Consultation.md)
- Pure UI section; CTA can link to external scheduling tool
- No DB changes required

### 7) PDF Download Module (8.7 / PDF doc)
- PDF generation must be driven by response_id (same results payload as above)
- GET /api/v1/responses/{response_id}/pdf?token=...
- Contents: header, cluster profile, radar chart, gap analysis, roadmap, consultation CTA
- Filename convention: AI_Compass_Report_[CompanyName]_[Date].pdf

### 6) Keep docs minimal and implementation-ready
- Remove conceptual overhead (no “maybe”, no optional architecture essays)
- Provide only what engineers need to implement: routes, payloads, validation rules, state requirements

## Proposed Minimal API (use consistently across docs)
You may adjust naming, but keep it consistent and response-based:

### Create Response (creates company + response)
POST `/api/v1/responses`
Body:
{
  "company": {
    "company_name": "Acme Ltd",
    "industry": "IT/Software",
    "website": "https://acme.com",
    "city": "Berlin",
    "number_of_employees": "51-250"
  }
}
Response:
{
  "response_id": 123,
  "access_token": "..."
}

### Load Questionnaire (DB-driven)
GET `/api/v1/questionnaire`
Response:
{
  "dimensions": [...],
  "questions": [...],
  "answers": [...]
}

### Autosave response item
POST `/api/v1/responses/{response_id}/items?token=...`
Body:
{
  "items": [
    { "question_id": 10, "answer_ids": [101] }
  ]
}

### Complete required section
POST `/api/v1/responses/{response_id}/finish-required?token=...`
Response:
{ "status": "required_finished" }

### Complete optional section + final calculation
POST `/api/v1/responses/{response_id}/complete?token=...`
Response:
{
  "status": "completed",
  "total_score": "2.6",
  "cluster": { "cluster_id": 3, "cluster_name": "The Structured Builder" }
}

### Get results
GET `/api/v1/responses/{response_id}?token=...`

### PDF
GET `/api/v1/responses/{response_id}/pdf?token=...`

## Frontend Rules to Preserve
- One question per screen
- Next/Finish disabled until valid selection exists
- Autosave is async; UI must show saving state; retries with backoff
- Finish must be blocked if the last save isn’t confirmed

## Your Task
1) Open every IMPLEMENTATION markdown file (1–8.7).
2) Rewrite sections so the above DB + API are the truth.
3) Replace every “assessment” concept with “response/response_id”.
4) Update “Load Questionnaire” to DB-driven (dimensions/questions/answers tables).
5) Ensure Required vs Optional flow is described exactly as specified.
6) Output the updated markdown files as final answer, preserving file names and numbering.

Do NOT propose schema migrations. Do NOT introduce new tables.
Only adjust the documentation and API contracts to fit the fixed schema.

Return:
- A short list of changes applied IN A SEPARATE FILE CALLED: imp-folder-updated.md
- Then the full updated contents for each file (1–8.7), clearly separated with headings like:
  `## FILE: IMPLEMENTATION/5-Load-Questionnaire.md`
