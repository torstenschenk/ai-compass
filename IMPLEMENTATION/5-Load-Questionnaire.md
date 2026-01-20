# Load Questionnaire (Schema-driven)

## Questionnaire Fetch
**Goal:** Load the currently active questionnaire schema (English) so the React wizard can render **all questions dynamically** (no hardcoded IDs).

**Backend**
- `GET /api/v1/questions`

**Outcome**
- UI can render the wizard from schema (no hardcoded IDs).

## Response (minimum required shape)
```json
{
  "lang": "en",
  "dimensions": [
    {
      "dimension_key": "...",
      "title": "...",
      "display_order": 2,
      "weight": 1.0,
      "questions": [
        {
          "question_key": "...",
          "question_text": "…",
          "question_type": "single_choice | multi_choice | tags",
          "render_type": "radio | chips | checklist | slider",
          "required": true,
          "min_select": 0,
          "max_select": 1,
          "weight": 1.0,
          "display_order": 1,
          "options": [
            {
              "option_key": "...",
              "label": "…",
              "points": 0,
              "display_order": 1
            }
          ]
        }
      ]
    }
  ]
}
```

### Notes

Questions/Options come from DB (versioned entities), but the API returns them as a renderable nested structure.

schema_hash is used for caching and to detect changes.

Ordering is defined by display_order (dimensions → questions → options).

## React Implementation Rules
When to call
- After POST /api/v1/assessments succeeds (we have assessment_id + token stored locally).
- Before the wizard renders the first question.

## Caching
- Keep questionnaire in memory (state/store).
- Persist to session storage to avoid refetch on refresh.
- Cache key: schema_hash 

## Normalize for wizard navigation
- Create a flat ordered list of questions:

- Sort dimensions by display_order
- Sort questions by display_order
- Keep a reference to dimension title for each question (header)

## Failure handling
- If request fails: show blocking error + retry button.
- Do not enter wizard without questionnaire data!