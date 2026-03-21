-- Query FHIR R4 Resources (USA)
-- Explore FHIR resources stored as JSONB in dr_open_sim_demo_usa

-- Count resources by type
SELECT
    resource_type,
    COUNT(*) AS resource_count
FROM fhir_r4.resources
GROUP BY resource_type
ORDER BY resource_count DESC;

-- Find Patient resources by birth date range
SELECT
    resource_id,
    fhir_id,
    patient_id,
    content->>'birthDate' AS birth_date,
    content->'name'->0->>'family' AS family_name,
    content->'name'->0->'given'->>0 AS given_name
FROM fhir_r4.resources
WHERE resource_type = 'Patient'
    AND (content->>'birthDate')::date BETWEEN '1980-01-01' AND '1990-12-31'
ORDER BY content->>'birthDate'
LIMIT 20;

-- Extract Condition codes (ICD-10 / SNOMED) from JSONB
SELECT
    r.patient_id,
    r.fhir_id,
    coding->>'system' AS code_system,
    coding->>'code' AS condition_code,
    coding->>'display' AS condition_display,
    r.created_at
FROM fhir_r4.resources r,
    LATERAL jsonb_array_elements(r.content->'code'->'coding') AS coding
WHERE r.resource_type = 'Condition'
ORDER BY r.created_at DESC
LIMIT 30;

-- Top 20 most common conditions by code
SELECT
    coding->>'code' AS condition_code,
    coding->>'display' AS condition_display,
    coding->>'system' AS code_system,
    COUNT(*) AS occurrence_count
FROM fhir_r4.resources r,
    LATERAL jsonb_array_elements(r.content->'code'->'coding') AS coding
WHERE r.resource_type = 'Condition'
GROUP BY coding->>'code', coding->>'display', coding->>'system'
ORDER BY occurrence_count DESC
LIMIT 20;

-- View the full FHIR JSON of a single Patient resource
SELECT
    resource_id,
    fhir_id,
    jsonb_pretty(content) AS fhir_json
FROM fhir_r4.resources
WHERE resource_type = 'Patient'
LIMIT 1;
