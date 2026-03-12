# Completion (Finalize Response)

## Goal
Complete the response directly from the wizard (no review step). Completion runs only when the last **required** or last **optional** question is answered **and saved** to session state.

## Trigger (Frontend)
- User clicks **Finish** on the last question of the active section.
- Button is enabled only if:
  - current question is valid (selection rules met)
  - current question save state is `saved` to session
  - all answers are saved to session state

## Endpoint
**POST** `/api/v1/responses/{response_id}/complete?token={access_token}`

### Request Body (contains all session state answers)
```json
{
  "items": [
    { "question_id": 10, "answer_ids": [101] },
    { "question_id": 11, "answer_ids": [205, 207] }
  ]
}
```

### Response (minimum)
```json
{
  "response_id": 123,
  "status": "completed",
  "completed_at": "2026-01-20T10:15:30Z",
  "total_score": "2.6",
  "cluster": {
    "cluster_id": 3,
    "cluster_name": "The Structured Builder"
  },
  "redirect_to": "/results/{response_id}"
}
```

---

## Backend Orchestration (must be atomic)

Run as a single transaction where possible. If a step fails, the response must not end up half-completed.

### Step 1 — Validate completion readiness

- Response exists and token is valid
- Response is not already completed
- All **required** questions are answered (validate incoming items)

### Step 2 — Persist all answers to database

Write all answers from request payload to `response_items` table:
- Insert/upsert per `(response_id, question_id)`
- Set `answers = answer_ids[]` (integer array)
- Validation: each answer_id must belong to its question_id (FK check)

### Step 3 — Deterministic scoring (source of truth)

Compute scores from saved `response_items`:
- For each response_item, join to `answers` and `questions` tables
- Calculate weighted score per dimension:
  - Each selected answer contributes: `answer_level` or `answer_weight`
  - Multiply by `questions.weight`
  - Multiply by `dimensions.dimension_weight`
- Aggregate to overall score (normalized to 1-5 scale)
- Map overall score to cluster:
  - Match score against `cluster_profiles.score_min` and `score_max`
  - Determine `cluster_id`

Persist scoring results:
- Update `responses` table:
  - `total_score` = computed overall score (stored as string, e.g., "2.6")
  - `cluster_id` = matched cluster ID (FK to `cluster_profiles`)

### Step 4 — ML benchmarking (computed at request time)

ML benchmarking data (percentile, peer comparisons) is **computed dynamically** when results are requested, not stored during completion.

Optional: If your implementation computes benchmark data during completion, ensure it uses only existing tables and does not require schema changes.

### Step 5 — LLM recommendations (optional, non-blocking)

LLM-generated recommendations can be:
- Computed at request time when results page loads, OR
- Cached externally (not in core schema)

If LLM fails:
- Use deterministic fallback recommendations
- Completion still succeeds

---

## Failure handling rules

- **If required answers are missing or invalid:**
  - return `409 Conflict` with a machine-readable list of missing/invalid question_ids

- **If scoring fails (unexpected):**
  - return `500` and do not mark response as completed

- **If ML fails:**
  - Log error but still complete response
  - Percentile/benchmark can be computed on-demand later

- **If LLM fails:**
  - Always complete using fallback recommendations

---

## Frontend behavior on success

- Redirect immediately to Results:
  - `GET /api/v1/responses/{response_id}?token={access_token}` for rendering
- Enable PDF download from results page

---

## Frontend behavior on "not ready" (strict gating)

- If API returns `409` missing/invalid answers:
  - show message: "Some answers are missing. Please complete all required questions."
  - navigate user to the first missing required question

---

## Notes

- No separate review step exists
- Completion happens directly from wizard Finish action
- Session state is persisted to `response_items` table during completion
- All scoring is derived from `response_items` + `answers` + `questions` + `dimensions` tables
- No schema changes allowed - work within fixed table structure
