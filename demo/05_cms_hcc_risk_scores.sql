-- =============================================================================
-- Demo Query 05: CMS-HCC Risk Score Distribution
-- Requires: dbt build (cms_hcc mart)
-- Schema prefix: adjust to match your dbt output schema
-- Database: dr_open_sim_demo_usa
-- =============================================================================

-- Overall risk score summary statistics
SELECT
    ROUND(AVG(risk_score), 3)           AS avg_risk_score,
    ROUND(MIN(risk_score), 3)           AS min_risk_score,
    ROUND(MAX(risk_score), 3)           AS max_risk_score,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY risk_score)::NUMERIC, 3)
                                        AS median_risk_score,
    ROUND(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY risk_score)::NUMERIC, 3)
                                        AS p90_risk_score
FROM cms_hcc.patient_risk_scores;      -- adjust schema name if needed

-- Risk score band distribution
SELECT
    CASE
        WHEN risk_score < 0.5   THEN 'Very Low (<0.5)'
        WHEN risk_score < 1.0   THEN 'Low (0.5-1.0)'
        WHEN risk_score < 1.5   THEN 'Moderate (1.0-1.5)'
        WHEN risk_score < 2.5   THEN 'High (1.5-2.5)'
        ELSE                         'Very High (2.5+)'
    END                                 AS risk_band,
    COUNT(*)                            AS patients,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct
FROM cms_hcc.patient_risk_scores
GROUP BY 1
ORDER BY MIN(risk_score);

-- Top 10 HCC conditions driving risk
SELECT
    hcc_code,
    hcc_description,
    COUNT(DISTINCT person_id)           AS patients_with_hcc,
    ROUND(AVG(risk_score_increment), 3) AS avg_risk_contribution
FROM cms_hcc.hcc_details
GROUP BY hcc_code, hcc_description
ORDER BY patients_with_hcc DESC
LIMIT 10;
