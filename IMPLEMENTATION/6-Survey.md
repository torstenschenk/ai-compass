# Survey (Response Wizard)

## Purpose
Render the response collection as a **one-question-per-screen wizard** with **async autosave** and a clear progress/status bar across **7 dimensions**, including an optional questions section after required questions.

## UI Contract (per screen)

### Header
- Show current **Dimension title** (always visible).

### Progress / Status Bar
- Show all **7 dimensions**.
- For each dimension show:
  - `answered_count / total_count`
  - completion indicator when `answered_count == total_count`
- Show progress bar for overall response.

### Question Body
- Render exactly **one question** at a time.
- Supported types:
  - `single_choice` → radio (also used for statements/sliders if modeled as single-choice)
  - `multi_choice` → chips/tags/checklist (at least one selected)

### Navigation
- Buttons:
  - `Back`
  - `Next` (for required questions, except last required)
  - `Finish` (on last required question)
- After required section is finished:
  - show button `Optional Questions` to continue with optional questions
- Optional section:
  - uses `Back` + `Next`
  - last optional question uses `Finish` (triggers final calculation/results generation)

### Button enable/disable rules
- `Back` is enabled if `current_index > 0` within the current section.
- `Next/Finish` is **disabled until the current question is valid**:
  - radio: one option selected
  - multi: at least one selected AND within `min_select/max_select` if provided
- `Optional Questions` is enabled only after last required question is completed (and saved).

---

## Async Autosave (non-blocking, session state only)

### Behavior
On every answer change:
1) Update UI state immediately
2) Save to session state (not DB yet)
3) Show save state indicator:
   - `Saving to session...` → `Saved ✓` → `Save failed (retrying...)`

### Important: Session State Until Completion
- All answers are stored in **session state** (memory/sessionStorage) during the wizard
- Answers are **NOT written to database** until survey is completed
- On completion, all session state answers are persisted to `response_items` table

### Retry
- Retry transient session storage failures
- If still failing:
  - show clear error
  - **block Finish** (required/optional) until successfully saved to session

### Rule
- Navigation can continue while saving to session is in-flight.
- **Completion cannot be triggered** unless all answers are successfully saved to session state.

---

## Persisting Response Items (Backend Contract)

### Endpoint
`POST /api/v1/responses/{response_id}/items?token={access_token}`

### Body (batch of answered questions)
```json
{
  "items": [
    {
      "question_id": 10,
      "answer_ids": [101]
    },
    {
      "question_id": 11,
      "answer_ids": [205, 207]
    }
  ]
}
```

### Backend rules

#### Validate:
- Each `question_id` exists in the `questions` table
- All `answer_ids` belong to the corresponding `question_id` (FK validation)

#### Upsert per (response_id, question_id):
- Insert or update `response_items`:
  - `response_id` = from URL parameter
  - `question_id` = from payload
  - `answers` = integer array of `answer_ids`
- For single choice: exactly one answer_id in array
- For multi choice: 1..n answer_ids in array

#### Store data queryably:
- `response_items` rows link to:
  - `responses` (via `response_id`)
  - `questions` (via `question_id`)
- Answer IDs in the integer array link to `answers` table for scoring

### Response
```json 
{
  "ok": true,
  "saved_items_count": 2,
  "server_timestamp": "2026-01-20T10:00:00Z"
}
```

### Error
```json
{
  "ok": false,
  "error": "Invalid answer_id: 999 does not belong to question_id: 10"
}
```

---

## Required vs Optional Questions

### Question data requirement
Each question indicates whether it is required or optional via the `optional` field from `questions` table:
- `optional = false` → required question
- `optional = true` → optional question

### Wizard logic
- **Required section** = all questions where `optional = false`
- **Optional section** = all questions where `optional = true`

### Completion Trigger (Wizard → Results)

#### Required section Finish:
Endpoint: `POST /api/v1/responses/{response_id}/finish-required?token={access_token}`
- Marks required section as completed
- **Does NOT save to database yet** (still in session state)
- User can either:
  - Navigate to optional questions (continue without DB write)
  - Trigger final completion (writes to DB and calculates results)

#### Optional section Finish:
Endpoint: `POST /api/v1/responses/{response_id}/complete?token={access_token}`
- Triggers final calculation/results generation (see 7-Completion.md)
- **This is when session state is persisted to database**

---

## Frontend Contract

## Goal
Define the minimal frontend state objects to run the wizard with:
- one-question-per-screen
- async save to session state
- dimension progress UI
- required + optional sections with separate Finish behavior

---

## 1) WizardState (single source of truth for UI)

### Shape
- `responseId: number`
- `token: string` (loaded from localStorage)

- `section: "required" | "optional"`
- `requiredQuestions: Question[]` (ordered, where `optional=false`)
- `optionalQuestions: Question[]` (ordered, where `optional=true`)

- `currentIndex: number`  
  - index into the active section array

- `answers: Record<number, AnswerState>`
  - keyed by `question_id`

- `saveStatus: Record<number, SaveState>`
  - keyed by `question_id`

- `ui:`
  - `globalError?: string`
  - `showOptionalEntry: boolean`  
    - true only after required section last question is valid+saved
  - `completionBlocked: boolean`
    - true if last question save is not confirmed or has a persistent error

### AnswerState (per question_id)
- `questionId: number`
- `selectedAnswerIds: number[]` (empty allowed while unanswered)
- `lastChangedAt: number` (ms epoch)

### SaveState (per question_id)
- `state: "idle" | "dirty" | "saving" | "saved" | "error"`
- `lastSaveAttemptAt?: number`
- `retryCount: number`
- `errorMessage?: string`

### Invariants
- One question screen renders only `activeQuestion = sectionQuestions[currentIndex]`
- `Next/Finish` enabled **only if**:
  - current question is valid (selection rules) AND
  - `saveStatus[currentQuestionId].state` is `"saved"` to session
- `Finish` (required last question):
  - allowed only when current is valid+saved to session
  - enables `showOptionalEntry = true`
  - can trigger completion which persists to DB
- `Finish` (optional last question):
  - allowed only when current is valid+saved to session
  - triggers completion (persists session state to DB)

---

## 2) ProgressModel (for status bar)

### Purpose
Compute per-dimension progress and overall progress from questionnaire structure + answers.

### Inputs
- `questionMetaById: Record<number, { dimensionId: number, optional: boolean }>`
- `dimensionOrder: number[]` (ordered dimension IDs)
- `dimensionNames: Record<number, string>`
- `dimensionQuestions: Record<number, number[]>` (ordered question IDs per dimension)
- `answers: WizardState.answers`

### Outputs
- `dimensions: DimensionProgress[]`
- `overallRequired: { answered: number, total: number }`
- `overallOptional: { answered: number, total: number }`

### DimensionProgress
- `dimensionId: number`
- `name: string`
- `requiredAnswered: number`
- `requiredTotal: number`
- `optionalAnswered: number`
- `optionalTotal: number`
- `requiredComplete: boolean` (`requiredAnswered == requiredTotal`)

### Answered definition
A question counts as answered when:
- `answers[questionId].selectedAnswerIds.length > 0`

---

## 3) Completion gate (strict MVP rule)

### Completion can be triggered only if:

#### Required section:
- All required questions are answered (valid)
- All required questions saved to session state (`saveStatus[q].state == "saved"`)

#### Optional section (if entered):
- Same rule applies for optional questions
- Last optional question is saved to session
- Completion triggers write from session state to database

### Implementation approach:
- Maintain all answers in session/state until survey completion
- On calling `/complete`:
  - Send all session state answers to backend
  - Backend writes entire batch to `response_items` table
  - Backend computes scores and cluster
  - Backend updates `responses` table with `total_score` and `cluster_id`