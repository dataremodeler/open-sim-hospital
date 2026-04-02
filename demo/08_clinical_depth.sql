-- =============================================================================
-- Demo Query 08: Clinical Depth — THE DIFFERENTIATOR
-- This is what Tuva's open demo dataset can't show you.
-- Their data has claims. Ours has the labs, vitals, and medications behind them.
-- Database: dr_open_sim_demo_usa
-- =============================================================================

-- Step 1: Find diabetic patients who also have lab results
-- (Type 2 diabetes = E11.x ICD-10 block)
WITH diabetic_patients AS (
    SELECT DISTINCT mc.person_id
    FROM tuva_input.medical_claim mc
    WHERE mc.diagnosis_code_1 LIKE 'E11%'
       OR mc.diagnosis_code_2 LIKE 'E11%'
),

-- Step 2: Pick patients who have HbA1c, glucose, or creatinine results
patients_with_labs AS (
    SELECT DISTINCT lr.person_id
    FROM tuva_input.lab_result lr
    JOIN diabetic_patients dp ON dp.person_id = lr.person_id
    WHERE lr.source_code IN (
        '4548-4',   -- HbA1c (%)
        '17856-6',  -- HbA1c by HPLC
        '2345-7',   -- Glucose [Mass/volume] in Serum or Plasma
        '2160-0',   -- Creatinine [Mass/volume] in Serum or Plasma
        '59261-8'   -- HbA1c (IFCC)
    )
    LIMIT 5
)

-- Step 3: Show the clinical story — claims + labs side by side
SELECT
    mc.person_id,
    mc.claim_start_date,
    mc.claim_type,
    mc.diagnosis_code_1                 AS claim_diagnosis,
    lr.source_description               AS lab_test,
    lr.source_code                      AS loinc_code,
    lr.result                           AS lab_value,
    lr.source_units                     AS units,
    lr.result_date,
    -- Flag if result is outside reference range
    CASE
        WHEN lr.source_code = '4548-4' AND lr.result::NUMERIC > 6.5
            THEN 'ABNORMAL (diabetic threshold)'
        WHEN lr.source_code = '2345-7' AND lr.result::NUMERIC > 100
            THEN 'ELEVATED'
        ELSE 'Normal range'
    END                                 AS interpretation
FROM patients_with_labs pwl
JOIN tuva_input.medical_claim mc ON mc.person_id = pwl.person_id
LEFT JOIN tuva_input.lab_result lr ON lr.person_id = pwl.person_id
    AND lr.result_date BETWEEN mc.claim_start_date - INTERVAL '7 days'
                           AND COALESCE(mc.claim_end_date, mc.claim_start_date) + INTERVAL '7 days'
WHERE lr.source_code IN ('4548-4', '17856-6', '2345-7', '2160-0', '59261-8')
  AND lr.result IS NOT NULL
ORDER BY mc.person_id, mc.claim_start_date, lr.result_date
LIMIT 50;

-- =============================================================================
-- Quick summary: How many diabetic patients have lab coverage?
-- =============================================================================
SELECT
    COUNT(DISTINCT mc.person_id)                               AS total_diabetic_patients,
    COUNT(DISTINCT lr.person_id)                               AS diabetic_patients_with_labs,
    ROUND(100.0 * COUNT(DISTINCT lr.person_id)
               / NULLIF(COUNT(DISTINCT mc.person_id), 0), 1)  AS lab_coverage_pct
FROM tuva_input.medical_claim mc
LEFT JOIN tuva_input.lab_result lr
  ON lr.person_id = mc.person_id
 AND lr.source_code IN ('4548-4', '17856-6', '2345-7', '2160-0', '59261-8')
WHERE mc.diagnosis_code_1 LIKE 'E11%'
   OR mc.diagnosis_code_2 LIKE 'E11%';
