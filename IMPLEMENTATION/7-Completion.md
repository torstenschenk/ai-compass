# completion_finish_action.md

## Goal
Complete the assessment directly from the wizard (no review step). Completion runs only when the last **required** or last **optional** question is answered **and saved**.

---

## Trigger (Frontend)
- User clicks **Finish** on the last question of the active section.
- Button is enabled only if:
  - current question is valid (selection rules met)
  - current question save state is `saved`
  - no pending saves for required questions (strict MVP: all required are `saved`)

---

## Endpoint
**POST** `/api/v1/assessments/{assessment_id}/complete?token={access_token}`

### Response (minimum)
```json
{
  "assessment_id": "uuid",
  "status": "completed",
  "completed_at": "timestamptz",
  "redirect_to": "/results/{assessment_id}",
  "versions": {
    "questionnaire_version_id": "uuid",
    "schema_hash": "sha256",
    "scoring_engine_version": "v1",
    "ml_model_version": "v1",
    "llm_prompt_version": "v1",
    "llm_model_name": "string"
  }
}
```

## Backend orchestration (must be atomic)

Run as a single transaction where possible. If a step fails, the assessment must not end up half-completed.

### Step 1 — Validate completion readiness

* Assessment exists and token is valid.
* Assessment is `draft`.
* All **required** questions for this assessment’s `questionnaire_version_id` are answered (and selections valid).
* (Optional section) If your product supports optional questions:

  * optional answers are allowed to be partial; they should not block completion unless the UI forced them.

### Step 2 — Deterministic scoring (source of truth)

* Compute overall score (0–100) and per-dimension scores.
* Map overall score to **cluster 1–5** using your agreed rule logic.
* Persist:

  * `assessment_scores`
  * `assessment_dimension_scores`
  * `assessment_drivers` (top drivers per dimension, if part of MVP)

### Step 3 — ML benchmarking (optics only)

* Use the saved answers/scores to produce:

  * `benchmark_cluster_id`
  * `benchmark_cluster_label` (rank-based profile mapping)
  * `percentile`
  * `mismatch_flag` / `mismatch_note` (optional)
* Persist to `benchmark_results`.

### Step 4 — LLM recommendations (non-blocking for completion)

* Generate strict JSON output.
* Validate JSON schema.
* If LLM fails or output invalid:

  * produce deterministic fallback recommendations.
* Persist to `llm_enrichment_cache` (keyed by inputs + prompt_version).

### Step 5 — Mark assessment completed

* Update `assessments`:

  * `status = 'completed'`
  * `completed_at = now()`

---

## Failure handling rules

* If required answers are missing or invalid:

  * return `409 Conflict` with a machine-readable list of missing/invalid question_keys
* If scoring fails (unexpected):

  * return `500` and keep assessment in `draft`
* If ML fails:

  * either (recommended) store a safe fallback benchmark payload (e.g., percentile null, mismatch_note),
  * or skip benchmark write but still complete (your choice; document it)
* If LLM fails:

  * always complete using fallback recommendations

---

## Frontend behavior on success

* Redirect immediately to Results:

  * `GET /api/v1/assessments/{assessment_id}?token={access_token}` for rendering
* Enable PDF download from results page.

---

## Frontend behavior on “not ready” (strict gating)

* If API returns `409` missing/invalid answers:

  * show message: “Some answers are missing. Please complete all required questions.”
  * navigate user to the first missing required question.
