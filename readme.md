# AI-Compass

AI-Compass is a self-service AI maturity assessment and benchmarking tool for SMEs (Mittelstand). It converts structured questions plus free-form text/voice input into explainable maturity scores, peer benchmarks, and an actionable roadmap—replacing costly initial consulting workshops with a fast, affordable starting point.

---

## What problem it solves

Many SMEs want to “do something with AI” but lack clarity on readiness, realistic use cases, data/tech prerequisites, and internal capabilities. Traditional first-phase consulting workshops are expensive and hard to scale. AI-Compass provides a structured, explainable assessment and roadmap with near-zero marginal delivery cost.

---

## Target customers

**Primary segment:** Small and medium-sized enterprises (SMEs / Mittelstand)

**Typical characteristics**
- 20–500 employees
- low to medium digital/AI maturity
- limited internal AI expertise
- cost-sensitive, pragmatic decision makers (CEO, COO, Head of IT/Digital)

**Market note (Germany)**
- ~2.5M SMEs total; realistically addressable subset estimated at **50k–200k** via digital channels + partners

---

## Value proposition

**Core value:** A fast, affordable, and understandable first AI maturity assessment that replaces expensive initial consulting workshops.

**Why it’s better than alternatives**
- Faster and cheaper than traditional consulting
- More contextual and explainable than static questionnaires
- Combines LLM reasoning + ML clustering/benchmarking (rare in SME tools)

---

## Product (MVP scope)

### Inputs (10–15 minutes)
1) **Company Snapshot (form)**
- Industry, employee band, optional revenue band
- location/country
- IT team size
- current systems (ERP/CRM/BI), data sources (high-level)
- current pain points (checklist + free text)

2) **Maturity Interview (chat-like)**
- 8–12 adaptive questions (based on company profile + prior answers)
- text input and optional voice input (Whisper → transcript)

### Outputs (paid deliverable)
- **Maturity Score (0–100)** + **Level (1–5)** per dimension
- **Benchmark** vs. similar companies (peer cluster + percentile)
- **Top 5 Quick Wins (0–30 days)**
- **Roadmap** (90 days / 6 months / 12 months), prioritized with effort/impact/prereqs
- **Risks & prerequisites** (data quality, security, skills, process)
- **PDF report download** and saved history (re-assessments)

---

## Maturity framework

6 pragmatic dimensions (SME-friendly, benchmarkable):
1) Strategy & Use Cases  
2) Data  
3) Tech & Architecture  
4) People & Skills  
5) Process & Delivery  
6) Governance, Risk & Compliance  

Each dimension maps to **Level 1–5** with clear criteria. These level definitions are the core “consulting IP” inside the product.

---

## Business model

### Revenue streams
**Primary**
- SaaS subscription (self-service assessment tool)

**Secondary (later)**
- pay-per-assessment
- white-label for consultancies
- lead generation for AI service providers

### Indicative pricing (MVP)
- **€49–99** per assessment (one-off)
- **€29–59 / month** subscription (limited assessments)

### Customer relationships
- Acquisition: content, guides, benchmarks, demos, partnerships
- Retention: reassessments, progress tracking, updated benchmarks/recommendations
- Support: self-service + minimal human support (email/chat)

---

## Architecture (MVP)

**UI:** Streamlit (desktop-first, mobile-compatible)  
**API:** FastAPI (clean separation)  
**DB:** PostgreSQL (users, companies, assessments, history, reports)  
**Vector DB:** ChromaDB (RAG knowledge base, framework text blocks)  
**Embeddings:** sentence-transformers *or* provider embeddings  
**Voice input:** Whisper (local or API)  
**Payments:** Stripe Checkout  
**Deployment:** Docker Compose

### Why this architecture
- Streamlit accelerates UI iteration
- FastAPI + Postgres prevents early lock-in and supports scaling
- ChromaDB supports explainability, references, and consistent recommendations

---

## Data model (minimum)

- `users`
- `companies` (belongs to user)
- `assessments` (company_id, created_at, status, language, paid_at)
- `responses` (assessment_id, question_id, raw_text, transcript, metadata)
- `scores` (assessment_id, dimension, score, level, rationale)
- `benchmarks` (assessment_id, cluster_id, percentile, peers_summary)
- `roadmap_items` (assessment_id, horizon, title, description, effort, impact, prerequisites)
- `reports` (assessment_id, pdf_path, version)

---

## Key features (current / planned)

### Current (target MVP)
- Stepper-based assessment flow
- Adaptive interview (question routing)
- Text + voice input (transcription)
- LLM analysis pipeline -> structured JSON output
- Payment gate before PDF/benchmark export
- PDF report generation and persistence
- Assessment history + re-assessment

### Planned (beyond MVP)
- Improved benchmarking (real peer data over time)
- White-label mode for consultancies
- Team collaboration and roles
- Follow-up modules (roadmap execution tracking, templates, playbooks)

---

## Benchmarking approach (LLM + ML)

**LLM responsibilities (strict JSON outputs)**
- Extract structured signals from unstructured input
- Score dimensions and generate rationale (explainability)
- Generate roadmap items using rules + knowledge base (RAG)

**ML responsibilities (lightweight, credible)**
- Cluster / peer group assignment from:
  - industry + size bands + system landscape + pain points
  - embeddings of interview responses
- Output: `cluster_id`, `peer_summary`, `percentile`

**Note on synthetic peers (MVP)**
Benchmarking can start using synthetic profiles. If used, the product should state transparently that benchmarks are model-based and will improve with real-world data.

---

## Repository structure (suggested)

```text
.
├── apps/
│   ├── web/                # Streamlit UI
│   └── api/                # FastAPI backend
├── packages/
│   ├── core/               # scoring, schemas, question logic
│   ├── rag/                # vector store, retrieval, KB ingestion
│   └── ml/                 # clustering, embeddings, benchmarking
├── data/
│   ├── kb/                 # curated framework + playbooks
│   └── synthetic/          # synthetic SME profiles for benchmarking (MVP)
├── infra/
│   ├── docker/             # Dockerfiles, compose, env templates
│   └── migrations/         # DB migrations (Alembic or similar)
├── scripts/
│   ├── setup.sh            # install + init db + seed kb
│   └── start.sh            # start stack
└── docs/
    ├── framework.md        # maturity dimensions + level definitions
    ├── prompts.md          # prompt contracts + JSON schemas
    └── privacy-security.md # data handling rules

