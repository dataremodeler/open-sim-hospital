# Open Sim Hospital

Getting realistic test data in healthcare is hard. Access requests take weeks. Anonymisation pipelines are fragile. Homegrown fake data lacks clinical coherence. Open Sim Hospital gives you two live PostgreSQL databases filled with realistic synthetic patient data — no setup, no PHI, no approval process.

## USA Database — `dr_open_sim_demo_usa`

**10,000+ synthetic patients in Tuva Input Layer format** — ready to run [Tuva Health](https://thetuvaproject.com/) dbt models against a production-scale dataset on day one.

**Input Layer**

| Schema | Table | Rows | Description |
|--------|-------|------|-------------|
| `tuva_input` | `medical_claim` | ~180,000 | Inpatient, outpatient, and professional claims with ICD-10-CM diagnoses and CPT procedures |
| `tuva_input` | `eligibility` | ~10,000+ | Member enrollment spans with payer, demographics, and coverage dates |
| `tuva_input` | `lab_result` | ~120,000 | LOINC-coded lab results with numeric values and reference ranges |
| `tuva_input` | `pharmacy_claim` | ~90,000 | NDC-coded prescription fills with days supply and costs |
| `tuva_input` | `observation` | ~60,000 | Vital signs and clinical observations |

**Tuva Core Model**

| Schema | Tables | Description |
|--------|--------|-------------|
| `core` | 8 tables | Tuva Core data model — normalized patient, encounter, condition, procedure, medication, lab, observation, and eligibility |

**Tuva Data Marts**

| Schema | Description |
|--------|-------------|
| `readmissions` | 30-day unplanned readmission flags and summary |
| `cms_hcc` | CMS-HCC risk scores, patient risk factors, and demographic coefficients |
| `chronic_conditions` | Tuva chronic condition flags (long format) with prevalence tracking |
| `ccsr` | Clinical Classifications Software Refined — diagnosis and procedure groupings |
| `financial_pmpm` | Per-member-per-month cost summaries by payer and service category |

**Multi-Format**

| Schema | Table | Rows | Description |
|--------|-------|------|-------------|
| `fhir_r4` | `resources` | ~27,601 | FHIR R4 resources (Patient, Encounter, Condition, Observation) as JSONB |
| `hl7v2` | `messages` | *(coming soon)* | HL7v2 ADT, ORU, ORM messages |

### What makes this different from Tuva's own demo data

Tuva's open demo (Synthea-based) has ~1,000 patients and claims only. This dataset has:

- **10x the patient volume** — meaningful cohort sizes for every condition
- **Labs behind the claims** — HbA1c values, glucose readings, creatinine — the data that actually drives clinical decisions
- **Pharmacy** — NDC-coded fills that match the diagnoses
- **Multi-format** — the same patients exist as Tuva inputs, FHIR R4 bundles, and HL7v2 messages
- **Refreshable** — nightly pipeline can re-run with any date range, patient count, or condition mix

### Quick Start

Connect with any PostgreSQL client and run your first query in under a minute:

```bash
# Connect using psql
psql "postgresql://dr_open_sim_demo:OpenDemoData2026!@db-open-demo-do-user-25666328-0.l.db.ondigitalocean.com:25060/dr_open_sim_demo_usa?sslmode=require"
```

```sql
-- What's in the database?
SELECT 'medical_claim' AS table_name, COUNT(*) AS rows FROM tuva_input.medical_claim
UNION ALL
SELECT 'eligibility',  COUNT(*) FROM tuva_input.eligibility
UNION ALL
SELECT 'lab_result',   COUNT(*) FROM tuva_input.lab_result
UNION ALL
SELECT 'pharmacy_claim', COUNT(*) FROM tuva_input.pharmacy_claim
UNION ALL
SELECT 'observation',  COUNT(*) FROM tuva_input.observation
ORDER BY rows DESC;
```

Or use DBeaver / DataGrip — paste the connection details from the [Connect](#connect) section below. All schemas are visible to the `dr_open_sim_demo` user.

### Quick Start — Tuva dbt

```bash
# 1. Clone Tuva's dbt package and point it at this database
git clone https://github.com/tuva-health/tuva
cd tuva

# 2. Configure profiles.yml with the connection details below

# 3. Build all marts
dbt build

# 4. Run demo queries
psql "postgresql://dr_open_sim_demo:OpenDemoData2026!@db-open-demo-do-user-25666328-0.l.db.ondigitalocean.com:25060/dr_open_sim_demo_usa?sslmode=require"
```

---

## NHS Database — `dr_open_sim_demo_nhs`

| Schema | Table | Rows | Description |
|--------|-------|------|-------------|
| `hl7v2` | `messages` | 277,700 | HL7v2 messages — NHS context |
| `fhir_r4` | `resources` | 27,471 | FHIR R4 resources stored as JSONB |
| `sus` | `submissions` | 32,112 | Secondary Uses Service datasets (APC, OP, AE, ECDS) |
| `ecds` | `attendances` | *(pending)* | Emergency Care Data Set attendances |

---

## Connect

Use any PostgreSQL client (psql, DBeaver, DataGrip, etc.):

```
Host:     db-open-demo-do-user-25666328-0.l.db.ondigitalocean.com
Port:     25060
User:     dr_open_sim_demo
Password: OpenDemoData2026!
SSL:      required
```

**USA database:**
```
Database: dr_open_sim_demo_usa
Connection String: postgresql://dr_open_sim_demo:OpenDemoData2026!@db-open-demo-do-user-25666328-0.l.db.ondigitalocean.com:25060/dr_open_sim_demo_usa?sslmode=require
```

**NHS database:**
```
Database: dr_open_sim_demo_nhs
Connection String: postgresql://dr_open_sim_demo:OpenDemoData2026!@db-open-demo-do-user-25666328-0.l.db.ondigitalocean.com:25060/dr_open_sim_demo_nhs?sslmode=require
```

> These are **read-only** connections. All data is entirely synthetic — no real patient information is included.

---

## Demo Queries

Ready-to-run SQL queries for the USA (Tuva) database:

| Query | What It Shows |
|-------|--------------|
| [01 — Data Overview](demo/01_data_overview.sql) | Row counts across all five Tuva input tables |
| [02 — Patient Demographics](demo/02_patient_demographics.sql) | Payer mix, age bands, gender, race |
| [03 — Diagnosis Distribution](demo/03_diagnosis_distribution.sql) | Top ICD-10-CM codes, chapter breadth, claims per patient |
| [04 — Readmissions Mart](demo/04_readmissions_mart.sql) | 30-day readmission rates (requires dbt build) |
| [05 — CMS-HCC Risk Scores](demo/05_cms_hcc_risk_scores.sql) | HCC risk score distribution (requires dbt build) |
| [06 — Chronic Conditions](demo/06_chronic_conditions.sql) | Condition prevalence and multi-morbidity (requires dbt build) |
| [07 — Financial PMPM](demo/07_financial_pmpm.sql) | Per-member-per-month costs by payer type |
| [08 — Clinical Depth](demo/08_clinical_depth.sql) | **The differentiator** — labs and claims side by side for diabetic patients |
| [09 — Multi-Format](demo/09_multi_format.sql) | Same patients in Tuva input, FHIR R4, and HL7v2 |
| [10 — Comparison vs Tuva Demo](demo/10_comparison_vs_tuva_demo.sql) | Head-to-head metrics against Tuva's own open dataset |

Run from the terminal:
```bash
# Single query
./demo/run_demo.sh 1

# All queries in sequence
./demo/run_demo.sh
```

See [demo/README.md](demo/README.md) for suggested demo flows and talking points.

---

### Sample Queries (existing)

#### NHS
- [Browse HL7v2 Messages](sample_queries/nhs/browse_hl7v2_messages.sql) — Message type counts and samples
- [Browse SUS Submissions](sample_queries/nhs/browse_sus_submissions.sql) — Dataset type counts and sample APC record
- [SUS Admitted Patient Care](sample_queries/nhs/sus_admitted_patient_care.sql) — Parse APC submissions, count by HRG/diagnosis

#### USA
- [Browse HL7v2 Messages](sample_queries/usa/browse_hl7v2_messages.sql) — Message type counts and sample ADT^A01
- [Query FHIR Resources](sample_queries/usa/query_fhir_resources.sql) — Resource type counts, Patient queries, Condition code extraction
- [FHIR Patient Summary](sample_queries/usa/fhir_patient_summary.sql) — Join Patient + Encounter + Condition resources

#### Cross-Country
- [Compare Patient Volumes](sample_queries/cross_country/compare_patient_volumes.sql) — Patient counts USA vs NHS
- [Message Type Distribution](sample_queries/cross_country/message_type_distribution.sql) — HL7v2 message breakdown across both countries

---

## The data is clinically coherent, not just schema-valid

Events are generated in clinical order — care pathways first, documentation second. A diabetic patient's HbA1c lab result ties to the encounter, the encounter ties to the claim, and the claim ties to the FHIR Condition resource. Observations match diagnoses. Referral-to-treatment pathways follow the right rules. Lab values are physiologically plausible.

This is what you need to build models that will hold up against real data — not schema-valid noise.

## Data Dictionary

See [docs/data_dictionary.md](docs/data_dictionary.md) for column-by-column descriptions of every table, message types, dataset types, and FHIR resource structures.

## About

This data is generated by the DataRemodeler synthetic data platform — a deterministic engine that produces clinically realistic patient records across multiple healthcare data standards. No AI is used at generation time; all records are produced through rule-based clinical models.

All data is entirely synthetic. No real patient data is used or included.

Built by Adam Canton of Insight Sage Consulting and [DataRemodeler](https://dataremodeler.com).

## Need more?

The open databases contain a representative sample. If your project needs a larger patient population (10K–100K+), specific conditions or care pathways, your own legacy system format (Lorenzo, BadgerNet, Diabeta3, and others), or bidirectional format conversion between standards — contact DataRemodeler: [dataremodeler.com/contact](https://dataremodeler.com/contact)

## Built on real NHS architecture

The data model and clinical logic were developed by the team that designed the Long Term Archive at Guy's & St Thomas' NHS Foundation Trust — delivering approximately £6M in annual savings through legacy system decommissioning.

## License

Apache 2.0 — see [LICENSE](LICENSE).
