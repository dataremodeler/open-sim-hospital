-- =============================================================================
-- Demo Query 04: 30-Day Readmissions (Tuva Mart)
-- Requires: dbt build to have run against tuva_input.*
-- Schema prefix: adjust <tuva_schema> to match your dbt output (e.g. tuva, dbt_tuva)
-- Database: dr_open_sim_demo_usa
-- =============================================================================

-- NOTE: Run `dbt build` first. Tuva outputs land in the schema configured in
-- dbt_project.yml (typically named after the mart, e.g. readmissions).
-- Replace <tuva_schema> with your actual output schema name.

-- 30-day readmission rate overall
SELECT
    COUNT(*)                                               AS total_index_admissions,
    SUM(CASE WHEN unplanned_readmit_30_flag::int = 1 THEN 1 ELSE 0 END) AS readmissions_30d,
    ROUND(
        100.0 * SUM(CASE WHEN unplanned_readmit_30_flag::int = 1 THEN 1 ELSE 0 END)
              / NULLIF(COUNT(*), 0),
        2
    )                                                      AS readmission_rate_pct
FROM tuva_readmissions.readmission_summary;   -- adjust schema name if needed

-- Readmission rate by diagnosis CCS category
SELECT
    diagnosis_ccs                                          AS dx_category,
    COUNT(*)                                               AS index_admissions,
    SUM(CASE WHEN unplanned_readmit_30_flag::int = 1 THEN 1 ELSE 0 END) AS readmits,
    ROUND(
        100.0 * SUM(CASE WHEN unplanned_readmit_30_flag::int = 1 THEN 1 ELSE 0 END)
              / NULLIF(COUNT(*), 0),
        1
    )                                                      AS readmit_rate_pct
FROM tuva_readmissions.readmission_summary
GROUP BY 1
ORDER BY index_admissions DESC
LIMIT 15;
