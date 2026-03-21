-- Compare Patient Volumes: USA vs NHS
--
-- NOTE: These queries use cross-database references via dblink or
-- foreign data wrappers. If your client does not support cross-database
-- queries, run each section against its respective database separately.
--
-- Alternatively, run these two queries independently and compare results.

-- === Run against dr_open_sim_demo_usa ===

-- USA: Unique patients across all data formats
SELECT
    'USA' AS country,
    'HL7v2' AS data_format,
    COUNT(DISTINCT patient_id) AS unique_patients
FROM hl7v2.messages

UNION ALL

SELECT
    'USA' AS country,
    'FHIR R4' AS data_format,
    COUNT(DISTINCT patient_id) AS unique_patients
FROM fhir_r4.resources
WHERE resource_type = 'Patient';


-- === Run against dr_open_sim_demo_nhs ===

-- NHS: Unique patients across all data formats
SELECT
    'NHS' AS country,
    'HL7v2' AS data_format,
    COUNT(DISTINCT patient_id) AS unique_patients
FROM hl7v2.messages

UNION ALL

SELECT
    'NHS' AS country,
    'SUS' AS data_format,
    COUNT(DISTINCT patient_id) AS unique_patients
FROM sus.submissions

UNION ALL

SELECT
    'NHS' AS country,
    'ECDS' AS data_format,
    COUNT(DISTINCT patient_id) AS unique_patients
FROM ecds.attendances;
