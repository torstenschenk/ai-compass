# Missing Questions Issue - Summary

## Problem Identified

The database upload completed successfully, but **6-7 question columns are missing** from all 500 responses in the `response_items` table.

### Missing Question IDs
For response_id 1 (and likely all others): **13, 16, 18, 24, 26, 28, 30, 31**

### Root Cause

The `process_assessment_data.py` script failed to map some questions and answers:

1. **4 unmapped questions**: Question text in CSV doesn't exactly match `question_text` in database
2. **7 questions with unmapped answers**: Answer text matching failed (likely due to special characters, formatting differences, or the comma-in-text issue)

### Impact

- `company_answers_with_ids_v2.csv` has only **27 question columns** instead of 33
- Database `response_items` table is missing **6-7 questions per response**
- All 500 companies affected
- Total scores may be incorrect (missing question contributions)

## Proposed Solutions

### Option 1: Fix Matching Logic and Reprocess (Recommended)
1. Investigate exact question text differences between CSV and database
2. Fix the smart matching algorithm to handle:
   - Special characters (Æ, ü, etc.)
   - Whitespace differences
   - Punctuation variations
3. Regenerate v2 CSV files with all 33 questions
4. Delete existing responses and response_items from database
5. Re-upload with complete data

### Option 2: Manual Mapping
1. Create a manual mapping file for the 4 unmapped questions
2. Update processing script to use manual mappings
3. Reprocess and re-upload

### Option 3: Database Direct Fix
1. Identify missing data from original CSV
2. Manually insert missing response_items directly into database
3. Recalculate total_scores

## Recommendation

**Option 1** is recommended because:
- Ensures all future processing works correctly
- Provides complete audit trail
- Fixes the root cause
- Can be automated

## Next Steps

1. Run detailed analysis to identify exact question/answer text mismatches
2. Update matching logic in `process_assessment_data.py`
3. Regenerate CSV files
4. Clear database tables (responses, response_items)
5. Re-upload with complete data
