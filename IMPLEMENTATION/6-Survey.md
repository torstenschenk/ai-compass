# Survey (Assessment Wizard)

## Purpose
Render the assessment as a **one-question-per-screen wizard** with **async autosave** and a clear progress/status bar across **7 dimensions**, including an optional questions section after required questions.

## UI Contract (per screen)

### Header
- Show current **Dimension title** (always visible).

### Progress / Status Bar
- Show all **7 dimensions**.
- For each dimension show:
  - `answered_count / total_count`
  - completion indicator when `answered_count == total_count`
- Show progress bar for overall assessment.

### Question Body
- Render exactly **one question** at a time.
- Supported types:
  - `single_choice` → radio (also used for statements/sliders if modeled as single-choice)
  - `multi_choice` → chips/tags/checklist (at least one selected)

### Navigation
- Buttons:
  - `Back`
  - `Next` (for required questions, except last required)
  - `Finish` (on last required question triggers final calculation/results generation without optional questions)
- After required section is finished:
  - show button `Optional Questions` to continue with optional questions
- Optional section:
  - uses `Back` + `Next`
  - last optional question uses `Finish` (triggers final calculation/results generation with optional questions)

### Button enable/disable rules
- `Back` is enabled if `current_index > 0` within the current section.
- `Next/Finish` is **disabled until the current question is valid**:
  - radio: one option selected
  - multi: at least one selected AND within `min_select/max_select` if provided
- `Optional Questions` is enabled only after last required question is completed (and saved).

---

## Async Autosave (non-blocking)

### Behavior
On every answer change:
1) Update UI state immediately
2) Trigger async save in background
3) Show save state indicator:
   - `Saving…` → `Saved ✓` → `Save failed (retrying…)`

### Retry
- Retry transient failures with exponential backoff.
- If still failing:
  - show clear error
  - **block Finish** (required/optional) until the last save for the current question is confirmed as saved.

### Rule
- Navigation can continue while saving is in-flight.
- **Completion cannot be triggered** unless the last required (or last optional) question is saved successfully.

## Persisting Responses (Backend Contract)

### Endpoint
`POST /api/v1/assessments/{assessment_id}/responses?token={access_token}`

### Body (single question or batch)
```json
{
  "responses": [
    {
      "question_key": "...  (e.g. sbv_01_strategy_defined)",
      "selected_option_keys": ["...", "..."]
    }
  ]
}
```

### Backend rules

#### Validate:

- `question_key` exists in the assessment’s questionnaire_version_id
- `all selected_option_keys` belong to that question and questionnaire version

##### Upsert per (assessment_id, question_key):

- `assessment_answers` (1 row per question)
- `assessment_answer_selections` (1 row per selected option)

#### Store data so it stays queryable forever:

- `questionnaire version`
- `dimensions`
- `questions`
- `options`
- `responses + selections`

### Response
```json 
{
  "ok": true,
  "saved_questions": ["sbv_01_strategy_defined"],
  "server_timestamp": "2026-01-20T10:00:00Z"
}
```

### Error
```json
{
  "ok": false,
  "error": "Invalid question_key: sbv_01_strategy_defined"
}
```

### Required vs Optional Questions
Questionnaire data requirement
Each question must indicate whether it is required or optional:
- required: true|false (recommended)

#### Wizard logic
- Required section = all questions where required == true
- Optional section = all questions where required == false

#### Completion Trigger (Wizard -> Results)

  ##### Required section Finish:

- marks required section completed
- if user does NOT go to optional questions → triggers results generation (7-Completion.md)
- if user clicks Optional Questions → continue without final calculation

##### Optional section Finish:

- triggers final calculation/results generation (7-Completion.md)



## Frontend Contract
# frontend_state_models.md

## Goal
Define the minimal, implementable frontend state objects to run the wizard with:
- one-question-per-screen
- async autosave with retries
- dimension progress UI
- required + optional sections with separate Finish behavior

No code, only data shapes + invariants.

---

## 1) WizardState (single source of truth for UI)

### Shape
- `assessmentId: string`
- `token: string` (loaded from localStorage)
- `questionnaireVersionId: string`
- `schemaHash: string`

- `section: "required" | "optional"`
- `requiredQuestionKeys: string[]` (ordered)
- `optionalQuestionKeys: string[]` (ordered)

- `currentIndex: number`  
  - index into the active section array (`requiredQuestionKeys` or `optionalQuestionKeys`)

- `answers: Record<string, AnswerState>`
  - keyed by `question_key`

- `saveStatus: Record<string, SaveState>`
  - keyed by `question_key`

- `ui:`
  - `globalError?: string`
  - `showOptionalEntry: boolean`  
    - true only after required section last question is valid+saved
  - `completionBlocked: boolean`
    - true if last question save is not confirmed or has a persistent error

### AnswerState (per question_key)
- `questionKey: string`
- `selectedOptionKeys: string[]` (empty allowed while unanswered)
- `lastChangedAt: number` (ms epoch; used to ignore outdated saves)

### SaveState (per question_key)
- `state: "idle" | "dirty" | "saving" | "saved" | "error"`
- `lastSaveAttemptAt?: number`
- `retryCount: number`
- `lastServerTimestamp?: string`
- `errorMessage?: string`

### Invariants
- One question screen renders only `activeQuestionKey = sectionKeys[ currentIndex ]`
- `Next/Finish` enabled **only if**:
  - current question is valid (selection rules) AND
  - `saveStatus[currentQuestionKey].state` is `"saved"` (or `"saving"` is allowed for navigation, but not for finishing)
- `Finish` (required last question):
  - allowed only when current is valid+saved
  - then either:
    - trigger completion immediately (if user skips optional), OR
    - enable `showOptionalEntry = true`
- `Finish` (optional last question):
  - allowed only when current is valid+saved
  - triggers completion

---

## 2) SaveQueue (async autosave scheduler)

## Purpose
Manage background persistence without blocking UI, with retry + stale-request protection.

### Shape
- `pending: Map<string, QueueItem>` keyed by `question_key`
- `inFlight: Set<string>` keyed by `question_key`
- `maxRetries: number` (e.g. 5)
- `baseDelayMs: number` (e.g. 400)
- `maxDelayMs: number` (e.g. 8000)

### QueueItem
- `questionKey: string`
- `payload: { question_key: string, selected_option_keys: string[] }`
- `clientVersion: number`  
  - monotonic per question (or use `lastChangedAt`) to detect stale responses
- `enqueuedAt: number`

### Processing rules
- Debounce per question (e.g. 300–600ms): only latest payload per question is kept.
- Only one in-flight save per question at a time.
- If a newer change arrives while saving:
  - keep it queued; after current save finishes, send the newest payload.
- On success:
  - mark `SaveState.state = "saved"` and clear retry info
- On failure:
  - classify transient vs persistent
  - transient → retry with exponential backoff
  - persistent → `SaveState.state = "error"` and surface `errorMessage`
- Stale response rule:
  - if response corresponds to an older `clientVersion/lastChangedAt`, ignore it.

### Endpoint contract used by SaveQueue
`POST /api/v1/assessments/{assessment_id}/responses?token={token}`
- batch allowed, but SaveQueue can send single-question payloads.

---

## 3) ProgressModel (for status bar + gating logic)

## Purpose
Compute per-dimension progress and overall progress from questionnaire structure + answers.

### Inputs
- `questionMetaByKey: Record<string, { dimensionKey: string, required: boolean }>`
- `dimensionOrder: string[]` (ordered keys)
- `dimensionTitles: Record<string, string>`
- `dimensionQuestionKeys: Record<string, string[]>` (ordered keys)
- `answers: WizardState.answers`

### Outputs
- `dimensions: DimensionProgress[]`
- `overallRequired: { answered: number, total: number }`
- `overallOptional: { answered: number, total: number }`

### DimensionProgress
- `dimensionKey: string`
- `title: string`
- `requiredAnswered: number`
- `requiredTotal: number`
- `optionalAnswered: number`
- `optionalTotal: number`
- `requiredComplete: boolean` (`requiredAnswered == requiredTotal`)

### Answered definition
A question counts as answered when:
- `answers[q].selectedOptionKeys.length > 0`  
AND (if applicable) `min_select/max_select` rules are satisfied.

### Used for
- Status bar display (counts + completion)
- Determine:
  - last required question reached and completed
  - whether to enable optional entry button
  - whether Finish may trigger completion

---

## 4) Minimal completion gate (strict MVP rule)

Completion can be triggered only if:
- Required section:
  - all required questions are answered (valid)
  - and for every required question: `saveStatus[q].state == "saved"`
- Optional section (if entered):
  - same rule applies for optional questions that were shown/answered
  - and last optional question is saved

Pragmatic MVP option:
- Only enforce “saved” for the current question and allow earlier “saving” states,
  but before calling `/complete` run a final flush:
  - `await saveQueue.drain()` (conceptually) then call complete.

