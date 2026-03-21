-- FHIR Patient Summary (USA)
-- Join Patient + Encounter + Condition resources to build a patient-level summary

-- Patient demographics with encounter and condition counts
WITH patients AS (
    SELECT
        patient_id,
        fhir_id,
        content->'name'->0->>'family' AS family_name,
        content->'name'->0->'given'->>0 AS given_name,
        content->>'birthDate' AS birth_date,
        content->>'gender' AS gender
    FROM fhir_r4.resources
    WHERE resource_type = 'Patient'
),
encounter_counts AS (
    SELECT
        patient_id,
        COUNT(*) AS encounter_count
    FROM fhir_r4.resources
    WHERE resource_type = 'Encounter'
    GROUP BY patient_id
),
condition_counts AS (
    SELECT
        patient_id,
        COUNT(*) AS condition_count
    FROM fhir_r4.resources
    WHERE resource_type = 'Condition'
    GROUP BY patient_id
)
SELECT
    p.patient_id,
    p.given_name,
    p.family_name,
    p.birth_date,
    p.gender,
    COALESCE(e.encounter_count, 0) AS encounters,
    COALESCE(c.condition_count, 0) AS conditions
FROM patients p
LEFT JOIN encounter_counts e ON e.patient_id = p.patient_id
LEFT JOIN condition_counts c ON c.patient_id = p.patient_id
ORDER BY e.encounter_count DESC NULLS LAST
LIMIT 50;

-- Detailed timeline for a single patient
-- Replace the patient_id filter with an actual patient_id from the query above
WITH patient_resources AS (
    SELECT
        resource_type,
        fhir_id,
        content,
        created_at
    FROM fhir_r4.resources
    WHERE patient_id = (
        SELECT patient_id FROM fhir_r4.resources
        WHERE resource_type = 'Patient'
        LIMIT 1
    )
)
SELECT
    resource_type,
    fhir_id,
    CASE
        WHEN resource_type = 'Patient' THEN
            content->'name'->0->>'family' || ', ' || content->'name'->0->'given'->>0
        WHEN resource_type = 'Encounter' THEN
            content->>'status' || ' — ' || content->'class'->>'display'
        WHEN resource_type = 'Condition' THEN
            content->'code'->'coding'->0->>'display'
        ELSE
            resource_type
    END AS summary,
    created_at
FROM patient_resources
ORDER BY created_at;
