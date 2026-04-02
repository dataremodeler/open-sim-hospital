-- =============================================================================
-- Demo Query 03: Diagnosis Distribution
-- Top 20 ICD-10-CM codes — show clinical variety and realism
-- Database: dr_open_sim_demo_usa
-- =============================================================================

-- Top 20 primary diagnoses across all claims
SELECT
    mc.diagnosis_code_1                 AS icd10_code,
    COUNT(*)                            AS claim_count,
    COUNT(DISTINCT mc.person_id)        AS unique_patients
FROM tuva_input.medical_claim mc
WHERE mc.diagnosis_code_1 IS NOT NULL
GROUP BY mc.diagnosis_code_1
ORDER BY claim_count DESC
LIMIT 20;

-- Chronic condition breadth: how many distinct ICD-10 blocks are represented?
SELECT
    SUBSTRING(diagnosis_code_1, 1, 1)  AS icd10_chapter,
    COUNT(DISTINCT diagnosis_code_1)    AS unique_codes,
    COUNT(*)                            AS total_claims
FROM tuva_input.medical_claim
WHERE diagnosis_code_1 IS NOT NULL
GROUP BY 1
ORDER BY total_claims DESC;

-- Claims per patient distribution (shows encounter depth)
SELECT
    claim_band,
    COUNT(*) AS patients
FROM (
    SELECT
        person_id,
        CASE
            WHEN COUNT(*) = 1       THEN '1 claim'
            WHEN COUNT(*) <= 5      THEN '2-5 claims'
            WHEN COUNT(*) <= 10     THEN '6-10 claims'
            WHEN COUNT(*) <= 25     THEN '11-25 claims'
            ELSE                         '25+ claims'
        END AS claim_band
    FROM tuva_input.medical_claim
    GROUP BY person_id
) sub
GROUP BY claim_band
ORDER BY MIN(
    CASE claim_band
        WHEN '1 claim'      THEN 1
        WHEN '2-5 claims'   THEN 2
        WHEN '6-10 claims'  THEN 3
        WHEN '11-25 claims' THEN 4
        ELSE                     5
    END
);
