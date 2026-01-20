# Load Questionnaire (DB-driven)

## Questionnaire Fetch
**Goal:** Load the questionnaire dynamically from the database so the React wizard can render **all questions** (no hardcoded IDs).

**Backend**
- `GET /api/v1/questionnaire`

**Data Source**
The questionnaire is assembled from database tables:
- `dimensions` - provides dimension metadata
- `questions` - provides question text and metadata (joined to dimensions)
- `answers` - provides selectable options and scoring parameters (joined to questions)

**Outcome**
- UI can render the wizard from DB-driven questionnaire structure (no hardcoded IDs).

## Response Structure (minimum required shape)
```json
{
  "dimensions": [
    {
      "dimension_id": 1,
      "dimension_name": "Strategy",
      "dimension_weight": 1.0,
      "questions": [
        {
          "question_id": 10,
          "header": "AI Strategy",
          "question_text": "Does your organization have a defined AI strategy?",
          "type": "single_choice",
          "weight": 1.0,
          "optional": false,
          "answers": [
            {
              "answer_id": 101,
              "answer_text": "No strategy defined",
              "answer_level": 1,
              "answer_weight": 0.0
            },
            {
              "answer_id": 102,
              "answer_text": "Informal exploration",
              "answer_level": 2,
              "answer_weight": 0.25
            },
            {
              "answer_id": 103,
              "answer_text": "Documented strategy",
              "answer_level": 3,
              "answer_weight": 0.5
            }
          ]
        }
      ]
    }
  ]
}
```

### Notes

**DB-driven loading:**
- Questions and options come from DB tables (`dimensions`, `questions`, `answers`)
- No JSON schema file or versioning required
- The questionnaire structure is determined by the current database content

**Ordering:**
- Dimensions: ordered by `dimension_id` (deterministic)
- Questions: ordered by `question_id` within each dimension
- Answers: ordered by `answer_id` within each question

**Required vs Optional:**
- `questions.optional` field indicates:
  - `false` = required question (answered first)
  - `true` = optional question (accessible only after required section is finished)

## React Implementation Rules

### When to call
- After `POST /api/v1/responses` succeeds (we have `response_id` + token stored locally).
- Before the wizard renders the first question.

### Caching
- Keep questionnaire in memory (state/store).
- Persist to sessionStorage to avoid refetch on refresh.

### Normalize for wizard navigation
- Create a flat ordered list of questions:
  - Sort dimensions by `dimension_id`
  - Sort questions by `question_id`
  - Keep a reference to dimension name for each question (header)
- Separate questions into two arrays:
  - Required questions (`optional = false`)
  - Optional questions (`optional = true`)

## Failure handling
- If request fails: show blocking error + retry button.
- Do not enter wizard without questionnaire data!