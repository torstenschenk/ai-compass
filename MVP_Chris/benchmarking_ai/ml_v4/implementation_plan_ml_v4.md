# Implementation Plan - ML v4

## Goal
Create `benchmarking_ai/ml_v4` by evolving `ml_v3`. Integrate the advanced logic from `strategic_gap_analysis.ipynb` (Status Quo) and `roadmap.ipynb` (Future Path) to provide a comprehensive "Consultant-Grade" assessment.

## User Review Required
> [!IMPORTANT]
> **Data Input Requirement**: `StrategicGapAnalyzer` and `RoadmapGenerator` require access to **Question-Level Data** (not just Dimension scores) to calculate "Weighted Impacts" correctly (handling Checklists vs Sliders). I will need to ensure `inference.py` passes this detailed data.

## Proposed Changes

### [New Directory] benchmarking_ai/ml_v4

#### [NEW] `data_pipeline.py`
- Inherit/Copy from `ml_v3`.
- **Enhancement**: Add `get_question_metadata()` to export:
    - `question_id`, `tactical_theme`, `type` (Checklist/Slider), `weight`.
- Ensure `create_matrices` returns a rich `question_level_df` (or similar) alongside the matrices, or handles the logic to allow mapping back.

#### [NEW] `utils.py`
- **Mandatory**:
    - `RISK_PAIRS`: List of the 4 dimension pairs.
    - `PHASE_MAPPING`: Dict mapping Dimensions to Phases.
    - `generate_narrative_template(findings, benchmarks)`: Helper for text generation.

#### [NEW] `models.py`
- **ClusterEngine**: Port from `ml_v3` (unchanged).

- **[NEW] StrategicGapAnalyzer**:
    - **Methods**:
        - `fit(data)`: Learn population stats (Mean/Std for Risk Pairs, Benchmark Averages for Dimensions).
        - `analyze(company_dim_data, company_question_data)`:
            1. **Z-Score Analysis**: Check the 4 Risk Pairs for anomalies (Z > 1.5). Calculate `Gap = ABS(d1 - d2)`.
            2. **Weighted Impact Analysis**: Calculate `impact` for all questions per Company.
                - Checklist: `(weight * 2)` if missing.
                - Slider: `weight * (5 - score)`.
            3. **Selection**: Pick Top 2 Findings (Priority: Anomalies -> Weighted Gaps).
        - `synthesize_narrative(findings, company_scores)`:
            - Generate a "Consultant Briefing" using the notebook's template logic ("Strategic Debt", "Bottleneck", "Competitive Advantage").
            - compare company scores to `self.benchmark_averages`.

- **[NEW] RoadmapGenerator**:
    - **Methods**:
        - `fit(data)`: Train NearestNeighbors (k=15, metric='cosine').
        - `generate(company_dim_data, company_question_data, strategic_gaps)`:
            1. **Peer Selection**: Find logic "Next Level" peers (15-30% better total maturity).
            2. **Mandatory Gaps**: Insert the 2 `strategic_gaps` into their mapped Phases.
            3. **Fill Phases**: Ensure **ALL 3 Phases** (Foundation, Implementation, Scale) have items.
                - Use "Growth Opportunities" (High Impact Questions) to fill gaps.
                - Validation: Prefer items where Peers > Company.
        - `synthesize_briefing(roadmap)`:
            - Generate the "Strategic Roadmap" text (Phase 1, 2, 3 narrative).

#### [NEW] `inference.py`
- Orchestrates the full flow:
    1. Load all models.
    2. Get `Cluster` prediction.
    3. Run `StrategicGapAnalyzer` -> Get `findings` and `narrative`.
    4. Run `RoadmapGenerator` (inputs: `findings`) -> Get `roadmap` and `briefing`.
    5. Construct final object.

### Verification Plan

### Automated Verification
- **Unit Tests**:
    - `tests/test_gap_analysis.py`:
        - Test Z-Score logic with mock data (ensure Threshold > 1.5 triggers).
        - Test "Checklist" weight boosting in `analyze`.
        - Test Narrative Generation produces expected strings.
    - `tests/test_roadmap.py`:
        - Test that 3 Phases are ALWAYS returned.
        - Test that Strategic Gaps are correctly placed.

### Manual Verification
- **Output Inspection**:
    - Run `inference.py` on the 5 Cluster Representatives.
    - Save output to `ml_v4/cluster_representative_test_findings.md`.
    - **Success Criteria**: The file must contain a rich "Consultant Briefing" and a "3-Phase Roadmap" for each company, matching the quality of the notebook demos.
