# AI-Compass Scoring Methodology

This document explains the complete scoring calculation logic used in the AI-Compass benchmarking system.

## Overview

The scoring system uses a **weighted averaging approach** where:
- All final scores are on a **1-5 scale**
- Different question types have different calculation methods
- Dimension scores are weighted averages of question scores
- Total scores are NOT calculated (we use dimension-level analysis only)

---

## 1. Answer-Level Scoring

### Answer Weights
Each answer option in the database has an `answer_weight` field:
- **Range**: Typically 1-5 for standard questions, 0-100 for checklist items
- **Source**: Defined in the `answers` table

**Example**:
```
Question: "How mature is your AI strategy?"
- Answer: "No strategy" → answer_weight = 1
- Answer: "Fully integrated" → answer_weight = 5
```

---

## 2. Question-Level Scoring

### Formula by Question Type

#### A. Standard Questions (Choice, Slider, Statement)
```
Question_Score = ((Selected_Answer_Weight / Max_Weight) * Question_weight) / 100
```
- **Max_Weight**: The maximum possible weight value for answers associated with this question ID.
- **Logic**: Percent of maximum achievement multiplied by question weight.

#### B. Checklist Questions (Multiple Selection)
```
Question_Score = ((Sum_of_selected_answers_weight / Total_weight_of_all_answers) * Question_weight) / 100
```
- **Total_weight_of_all_answers**: The sum of weights for all possible answer options for this question.
- **Logic**: Total points earned as a fraction of the entire checklist's potential.

**Example**:
```
User selects 3 items: weights [20, 30, 25]
sum_weights = 75
capped_sum = MIN(75, 100) = 75
scaled_value = (75/100) × 4 + 1 = 4.0
Question score = 4.0
```

---

## 3. Dimension-Level Scoring

### Aggregation Formula
```
Dimension_Mastery = SUM(Question_Score_in_dim) / (SUM(Question_weight_in_dim) / 100)
Final_Dimension_Score = (Dimension_Mastery * 4) + 1
```

- **Dimension_Mastery**: The percentage of points earned in the dimension relative to the potential points (0.0 to 1.0).
- **Final_Dimension_Score**: Mapped to the standard 1-5 benchmarking scale.
- **Logic**: We normalize the weighted contributions to ensure every dimension is comparable on a 1-5 scale, regardless of its total weight.

**Example**:
```
Dimension: "Data Readiness & Literacy"
Questions in this dimension:

Q1: score=3.0, weight=4.5 → weighted_score = 13.5
Q2: score=4.5, weight=3.0 → weighted_score = 13.5
Q3: score=2.0, weight=2.5 → weighted_score = 5.0

dimension_score = (13.5 + 13.5 + 5.0) / (4.5 + 3.0 + 2.5)
                = 32.0 / 10.0
                = 3.2
```

---

## 4. Total Score

**NOT CALCULATED** in the current ML-based system.

**Rationale**: 
- The clustering algorithm uses the 7 dimension scores as features
- Total scores would lose granularity and hide important patterns
- Peer comparisons are done at the dimension level

---

## 5. Question Types Summary

| Question Type | Calculation Method | Score Range | Example Use Case |
|--------------|-------------------|-------------|------------------|
| **Statement** | Direct answer weight | 1-5 | "We have a clear AI strategy" |
| **Single Choice** | Direct answer weight | 1-5 | "What is your AI maturity level?" |
| **Checklist** | Sum weights → scale to 1-5 | 1-5 | "Which AI use cases have you deployed?" |

---

## 6. Implementation Details

### Database Schema
```sql
questions (
  question_id,
  dimension_id,
  type,           -- 'Statement', 'Checklist', etc.
  weight          -- Importance of this question (e.g., 4.5)
)

answers (
  answer_id,
  question_id,
  answer_weight   -- Score value (1-5 or 0-100)
)

dimensions (
  dimension_id,
  dimension_name,
  dimension_weight  -- NOT USED in current implementation
)
```

### Code Reference
- **Question scoring**: `data_pipeline.py` lines 107-117
- **Dimension aggregation**: `data_pipeline.py` lines 130-145
- **Checklist scaling**: `data_pipeline.py` lines 109-112

---

## 7. Example: Complete Calculation

**Scenario**: Company completes assessment

### Step 1: Answer Selection
```
Q1 (Statement, weight=4.5): "Somewhat agree" → answer_weight=3
Q2 (Checklist, weight=3.0): Selects 2 items → weights [30, 40]
Q3 (Statement, weight=2.5): "Strongly agree" → answer_weight=5
```

### Step 2: Question Scores
```
Q1: question_score = 3.0
Q2: sum=70 → scaled=(70/100)×4+1 = 3.8
Q3: question_score = 5.0
```

### Step 3: Dimension Score (all 3 questions in "Data Readiness")
```
dimension_score = (3.0×4.5 + 3.8×3.0 + 5.0×2.5) / (4.5 + 3.0 + 2.5)
                = (13.5 + 11.4 + 12.5) / 10.0
                = 37.4 / 10.0
                = 3.74
```

### Step 4: Final Output
```
Company Profile:
- Data Readiness & Literacy: 3.74
- Governance & Compliance: 4.12
- People & Culture: 3.56
- ... (7 dimensions total)

Cluster Assignment: "3 - Middle Pack"
```

---

## 8. Key Differences from Legacy System

| Aspect | Legacy | New ML System |
|--------|--------|---------------|
| **Question weighting** | ❌ Not applied | ✅ Weighted average |
| **Checklist scaling** | ❌ Simple average | ✅ Proper 1-5 scaling |
| **Dimension calculation** | ❌ Simple mean | ✅ Weighted mean |
| **Score range** | Inconsistent | Consistent 1-5 |

---

## 9. Validation

To verify correct implementation:
1. Check dimension scores are in range [1, 5]
2. Verify weighted averages (not simple means)
3. Confirm checklist questions scale properly
4. Test with edge cases (all min, all max answers)

**Test Query**:
```python
# Should show scores between 1-5
d_matrix.describe()
```
