-- =============================================================================
-- Demo Query 01: Data Overview
-- What's in the database — open with this to set the scene
-- Database: dr_open_sim_demo_usa
-- =============================================================================

-- Row counts across all five Tuva input tables
SELECT 'medical_claim'    AS table_name, COUNT(*) AS rows FROM tuva_input.medical_claim
UNION ALL
SELECT 'eligibility',                    COUNT(*)         FROM tuva_input.eligibility
UNION ALL
SELECT 'pharmacy_claim',                 COUNT(*)         FROM tuva_input.pharmacy_claim
UNION ALL
SELECT 'lab_result',                     COUNT(*)         FROM tuva_input.lab_result
UNION ALL
SELECT 'observation',                    COUNT(*)         FROM tuva_input.observation
ORDER BY rows DESC;

-- Unique patient count
SELECT COUNT(DISTINCT person_id) AS unique_patients
FROM tuva_input.eligibility;

-- Date range covered
SELECT
    MIN(enrollment_start_date) AS data_from,
    MAX(enrollment_end_date)   AS data_to
FROM tuva_input.eligibility;
