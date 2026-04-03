# Tuva Demo Status — From Henry

**Date:** 2026-04-03
**Status:** DuckDB complete, PostgreSQL deployment incomplete

## What's Done
- All Tuva data marts built in local DuckDB (`/tmp/tuva-demo/tuva_demo.duckdb`, 2.6GB)
- 8 DuckDB type-mismatch bugs patched in `dbt_packages/the_tuva_project/`
- Demo queries 04-06 updated with correct table names in `demo/` folder
- 23 mart table CSVs exported to droplet at `/tmp/*.csv`

## CRITICAL: Two Database Clusters

| Cluster | Host | Status |
|---------|------|--------|
| **Open-Demo (CORRECT target)** | `db-open-demo-do-user-25666328-0.l.db.ondigitalocean.com:25060` | Only `hl7v2` + `fhir_r4`. **Mart tables + tuva_input NOT loaded yet.** |
| **SageFusion (WRONG — data loaded here by mistake)** | `db-postgresql-nyc3-06258-sagefusion-...m.db.ondigitalocean.com:25060` | Has everything: tuva_input, all mart schemas, hl7v2, fhir_r4 |

Demo user: `dr_open_sim_demo` / `OpenDemoData2026!`

## What Needs Doing
1. Load `tuva_input` (5 tables) + mart CSVs (23 tables) to Open-Demo cluster
2. Create schemas owned by `dr_open_sim_demo` (required for DBeaver visibility)
3. Drop `public` schema on Open-Demo
4. Verify all 10 demo queries work against Open-Demo as `dr_open_sim_demo`

## Demo Query Fixes Applied
- `05_cms_hcc_risk_scores.sql`: `risk_score` → `payment_risk_score`, `hcc_details` → `patient_risk_factors`
- `06_chronic_conditions.sql`: `condition_flags` → `tuva_chronic_conditions_long`, removed `WHERE condition_flag = true`
- HCC gap: only demographic factors exist, no disease HCCs (ICD-10 codes may not map)

## Files on Droplet
- `/tmp/*.csv` — 23 mart CSVs (may be cleared on reboot)
- `/tmp/mart_export.tar.gz` — backup archive (7.4MB)
