# Exploratory Data Analysis Report

## Overview
This report summarizes the analysis of the AI Compass assessment database, covering 500 companies, their demographics, and assessment scores.

## 1. Company Demographics
**Script:** `EDA/analyze_companies.py`
**Plots:** `EDA/plots/companies_*.png`

- **Total Companies:** 500
- **Industries:** 7 unique industries. Top represented:
  - Manufacturing (83)
  - Retail (77)
  - Construction (76)
- **Locations:** 7 major German cities. Top 3:
  - Düsseldorf (82)
  - Munich (81)
  - Hamburg (80)
- **Size:** Companies fall into 4 distinct size categories, with ~18,000 employees being the most common size grouping freq (~132 companies).

## 2. Assessment Scores
**Script:** `EDA/analyze_scores.py`
**Plots:** `EDA/plots/scores_*.png`

- **Score Range:** 0-5 Scale
- **Statistics:**
  - **Mean:** 2.50
  - **Min:** 1.23
  - **Max:** 4.47
  - **Std Dev:** 0.76
- **Distribution:** Scores follow a generally normal distribution centered around 2.5.
- **Outliers:** Several high-performing companies were identified (e.g., Zenith Solutions with 4.47).

## 3. Question Analysis
**Script:** `EDA/analyze_questions.py`
**Plots:** `EDA/plots/q*_dist.png`

- **Coverage:** Verified responses for Statement, Choice, Slider, and Checklist questions.
- **Completeness:** 100% of companies (500) have responses for all 33 questions.
- **Response Patterns:**
  - **Logic Check:** Checklist questions show varied multi-select patterns.
  - **Distribution:** detailed answer frequency analysis in `EDA/questions_analysis_summary.txt`.

## Generated Files
All raw analysis outputs are available in:
- `EDA/plots/`: 8 Visualizations (PNG)
  - `companies_by_industry.png`
  - `companies_by_city.png`
  - `companies_size_dist.png`
  - `scores_distribution.png`
  - `scores_boxplot.png`
  - `scores_by_industry.png`
  - `scores_vs_size.png`
  - `q*_dist.png` (Question distributions)
- `EDA/*_summary.txt`: Detailed text statistics.
