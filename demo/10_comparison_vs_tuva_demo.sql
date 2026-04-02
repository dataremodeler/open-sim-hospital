-- =============================================================================
-- Demo Query 10: Our Dataset vs Tuva's Open Demo — Side by Side
-- Tuva's synthea-based demo: ~1,000 patients, claims only.
-- Ours: 10,000+ patients, claims + labs + pharmacy + observations + FHIR + HL7v2.
-- Database: dr_open_sim_demo_usa
-- =============================================================================

-- Headline comparison
SELECT
    'Tuva Open Demo (Synthea)'          AS dataset,
    1000                                AS approx_patients,
    'Claims only'                       AS data_layers,
    'No'                                AS lab_results,
    'No'                                AS pharmacy_data,
    'No'                                AS fhir_r4,
    'No'                                AS hl7v2,
    'Static'                            AS refresh_model

UNION ALL

SELECT
    'DataRemodeler (this database)'     AS dataset,
    (SELECT COUNT(DISTINCT person_id) FROM tuva_input.eligibility)::INT
                                        AS approx_patients,
    'Claims + Labs + Pharmacy + Obs'    AS data_layers,
    'Yes'                               AS lab_results,
    'Yes'                               AS pharmacy_data,
    'Yes'                               AS fhir_r4,
    'Yes'                               AS hl7v2,
    'Nightly refresh available'         AS refresh_model;

-- Encounter depth: average claims + labs per patient
SELECT
    ROUND(AVG(claim_count), 1)          AS avg_claims_per_patient,
    ROUND(AVG(lab_count), 1)            AS avg_labs_per_patient,
    ROUND(AVG(rx_count), 1)             AS avg_rx_per_patient,
    ROUND(AVG(obs_count), 1)            AS avg_obs_per_patient
FROM (
    SELECT
        e.person_id,
        COUNT(DISTINCT mc.claim_id)     AS claim_count,
        COUNT(DISTINCT lr.lab_result_id) AS lab_count,
        COUNT(DISTINCT pc.claim_id)     AS rx_count,
        COUNT(DISTINCT o.observation_id) AS obs_count
    FROM tuva_input.eligibility e
    LEFT JOIN tuva_input.medical_claim mc  ON mc.person_id = e.person_id
    LEFT JOIN tuva_input.lab_result lr     ON lr.person_id = e.person_id
    LEFT JOIN tuva_input.pharmacy_claim pc ON pc.person_id = e.person_id
    LEFT JOIN tuva_input.observation o     ON o.person_id = e.person_id
    GROUP BY e.person_id
) per_patient;

-- Condition breadth: unique ICD-10-CM codes (proxy for clinical realism)
SELECT COUNT(DISTINCT diagnosis_code_1) AS unique_icd10_codes
FROM tuva_input.medical_claim
WHERE diagnosis_code_1 IS NOT NULL;

-- Lab LOINC coverage: unique lab tests represented
SELECT COUNT(DISTINCT source_code) AS unique_loinc_codes
FROM tuva_input.lab_result
WHERE source_code IS NOT NULL;
