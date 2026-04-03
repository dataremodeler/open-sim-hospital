-- =============================================================================
-- Demo Query 05: CMS-HCC Risk Score Distribution
-- Requires: dbt build (cms_hcc mart)
-- Database: dr_open_sim_demo_usa
-- =============================================================================

-- Overall risk score summary statistics
SELECT
    ROUND(AVG(payment_risk_score::NUMERIC), 3)           AS avg_risk_score,
    ROUND(MIN(payment_risk_score::NUMERIC), 3)           AS min_risk_score,
    ROUND(MAX(payment_risk_score::NUMERIC), 3)           AS max_risk_score,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY payment_risk_score::NUMERIC)::NUMERIC, 3)
                                        AS median_risk_score,
    ROUND(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY payment_risk_score::NUMERIC)::NUMERIC, 3)
                                        AS p90_risk_score
FROM tuva_cms_hcc.patient_risk_scores;

-- Risk score band distribution
SELECT
    CASE
        WHEN payment_risk_score::NUMERIC < 0.5   THEN 'Very Low (<0.5)'
        WHEN payment_risk_score::NUMERIC < 1.0   THEN 'Low (0.5-1.0)'
        WHEN payment_risk_score::NUMERIC < 1.5   THEN 'Moderate (1.0-1.5)'
        WHEN payment_risk_score::NUMERIC < 2.5   THEN 'High (1.5-2.5)'
        ELSE                         'Very High (2.5+)'
    END                                 AS risk_band,
    COUNT(*)                            AS patients,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct
FROM tuva_cms_hcc.patient_risk_scores
GROUP BY 1
ORDER BY MIN(payment_risk_score::NUMERIC);

-- Top 10 HCC risk factors driving risk (disease factors)
SELECT
    risk_factor_description,
    COUNT(DISTINCT person_id)           AS patients_with_factor,
    ROUND(AVG(coefficient::NUMERIC), 3) AS avg_coefficient
FROM tuva_cms_hcc.patient_risk_factors
-- factor_type is 'Disease' or 'Demographic'; show whatever exists
GROUP BY risk_factor_description
ORDER BY patients_with_factor DESC
LIMIT 10;
