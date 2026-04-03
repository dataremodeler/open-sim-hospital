# Demo Queries — Run Guide

Pre-built SQL queries for live demonstrations against `dr_open_sim_demo_usa`.

## Before You Demo

**Checklist:**
- [ ] psql installed: `psql --version`
- [ ] Connection tested: `./run_demo.sh 1` returns row counts
- [ ] dbt built (for queries 04–06): `dbt build` in the Tuva project
- [ ] DBeaver/DataGrip open with connection pre-saved (for visual demos)

**dbt schema note:** Queries 04, 05, 06 use Tuva mart output. All Tuva mart schemas are prefixed with `tuva_` (e.g. `tuva_readmissions`, `tuva_cms_hcc`, `tuva_chronic_conditions`).

## Connection

```
Host:     db-open-demo-do-user-25666328-0.l.db.ondigitalocean.com
Port:     25060
User:     dr_open_sim_demo
Password: OpenDemoData2026!
Database: dr_open_sim_demo_usa
SSL:      required
```

## Query Guide

| File | What It Shows | Duration |
|------|--------------|----------|
| `01_data_overview.sql` | Row counts, date range, patient count | 30 sec |
| `02_patient_demographics.sql` | Payer mix, age bands, gender, race | 1 min |
| `03_diagnosis_distribution.sql` | Top ICD-10-CM codes, chapter breadth, claims per patient | 1 min |
| `04_readmissions_mart.sql` | 30-day readmission rate (requires dbt) | 1 min |
| `05_cms_hcc_risk_scores.sql` | HCC risk score distribution (requires dbt) | 1 min |
| `06_chronic_conditions.sql` | Condition prevalence and multi-morbidity (requires dbt) | 1 min |
| `07_financial_pmpm.sql` | PMPM costs by payer and claim type | 1 min |
| `08_clinical_depth.sql` | **THE DIFFERENTIATOR** — diabetic patient labs vs claims | 2 min |
| `09_multi_format.sql` | Same patients in Tuva + FHIR R4 + HL7v2 | 1 min |
| `10_comparison_vs_tuva_demo.sql` | Head-to-head vs Tuva's open demo dataset | 1 min |

## Run Options

```bash
# Single query (fast — use during live demo)
./run_demo.sh 1      # data overview
./run_demo.sh 8      # clinical depth (the differentiator)
./run_demo.sh 9      # multi-format

# All queries in sequence
./run_demo.sh
```

## Suggested 10-Minute Demo Flow

1. **01** — set the scene (10,000+ patients, 5 tables)
2. **02** — demographics (realistic payer mix, age distribution)
3. **08** — clinical depth (this is the moment — claims + HbA1c side by side)
4. **09** — multi-format (same patients, every standard)
5. **10** — comparison (we win on every metric)

## Suggested 20-Minute Demo Flow

All of the above, plus:
- **03** after 02 (ICD-10 breadth)
- **07** after 03 (financial analytics)
- **04 or 05** after 07 (Tuva mart output — if dbt is built)

## Key Talking Points

**Clinical depth (query 08):** "Tuva's open demo has claims. We have the labs, vitals, and medications that explain those claims. This is what you need to build predictive models, not just retrospective reports."

**Multi-format (query 09):** "Same patient — same person_id — exists as a Tuva input row, a FHIR R4 bundle, and an HL7v2 ADT message. That's the conversion capability, proven in the dataset itself."

**Comparison (query 10):** "Their sample is 1,000 patients and claims-only. Ours is 10,000+ with labs, pharmacy, observations, FHIR, and HL7v2. And it refreshes nightly."

**Refreshable:** "This isn't a static dump. The nightly pipeline can re-run with any date, any patient count, any condition mix you need. You tell us the scenario; we generate it."
