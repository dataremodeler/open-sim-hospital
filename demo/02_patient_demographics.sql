-- =============================================================================
-- Demo Query 02: Patient Demographics
-- Prove the data is realistic — payer mix, age, gender, race
-- Database: dr_open_sim_demo_usa
-- =============================================================================

-- Payer mix
SELECT
    payer                               AS payer,
    COUNT(DISTINCT person_id)           AS patients,
    ROUND(100.0 * COUNT(DISTINCT person_id) / SUM(COUNT(DISTINCT person_id)) OVER (), 1) AS pct
FROM tuva_input.eligibility
GROUP BY payer
ORDER BY patients DESC;

-- Age distribution at last enrollment
SELECT
    CASE
        WHEN age_at_enrollment_start BETWEEN 0  AND 17  THEN '0-17'
        WHEN age_at_enrollment_start BETWEEN 18 AND 34  THEN '18-34'
        WHEN age_at_enrollment_start BETWEEN 35 AND 49  THEN '35-49'
        WHEN age_at_enrollment_start BETWEEN 50 AND 64  THEN '50-64'
        WHEN age_at_enrollment_start BETWEEN 65 AND 74  THEN '65-74'
        WHEN age_at_enrollment_start >= 75              THEN '75+'
        ELSE 'Unknown'
    END                                 AS age_band,
    COUNT(DISTINCT person_id)           AS patients
FROM tuva_input.eligibility
GROUP BY 1
ORDER BY MIN(COALESCE(age_at_enrollment_start, 999));

-- Gender split
SELECT
    gender                              AS gender,
    COUNT(DISTINCT person_id)           AS patients,
    ROUND(100.0 * COUNT(DISTINCT person_id) / SUM(COUNT(DISTINCT person_id)) OVER (), 1) AS pct
FROM tuva_input.eligibility
GROUP BY gender
ORDER BY patients DESC;

-- Race distribution
SELECT
    race                                AS race,
    COUNT(DISTINCT person_id)           AS patients
FROM tuva_input.eligibility
GROUP BY race
ORDER BY patients DESC;
