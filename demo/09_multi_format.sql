-- =============================================================================
-- Demo Query 09: Multi-Format Coverage
-- Same patients exist across every major healthcare data standard.
-- No other open dataset does this.
-- Database: dr_open_sim_demo_usa
-- =============================================================================

-- Record counts across all formats
SELECT 'Tuva Input — Medical Claims'   AS format, COUNT(*) AS records FROM tuva_input.medical_claim
UNION ALL
SELECT 'Tuva Input — Lab Results',                COUNT(*)            FROM tuva_input.lab_result
UNION ALL
SELECT 'Tuva Input — Pharmacy Claims',            COUNT(*)            FROM tuva_input.pharmacy_claim
UNION ALL
SELECT 'Tuva Input — Observations',               COUNT(*)            FROM tuva_input.observation
UNION ALL
SELECT 'HL7v2 Messages',                          COUNT(*)            FROM hl7v2.messages
UNION ALL
SELECT 'FHIR R4 Resources',                       COUNT(*)            FROM fhir_r4.resources
ORDER BY records DESC;

-- Confirm the same patients appear in all three formats
-- (any person_id present in claims should also be in FHIR and HL7)
WITH tuva_patients AS (
    SELECT DISTINCT person_id FROM tuva_input.eligibility
),
fhir_patients AS (
    SELECT DISTINCT resource->>'id' AS patient_id
    FROM fhir_r4.resources
    WHERE resource_type = 'Patient'
)
SELECT
    COUNT(DISTINCT tp.person_id)        AS patients_in_tuva,
    COUNT(DISTINCT fp.patient_id)       AS patients_in_fhir,
    COUNT(DISTINCT tp.person_id) - COUNT(DISTINCT fp.patient_id)
                                        AS coverage_gap
FROM tuva_patients tp
FULL OUTER JOIN fhir_patients fp ON fp.patient_id = tp.person_id;

-- FHIR resource type breakdown
SELECT
    resource_type,
    COUNT(*)                            AS resources
FROM fhir_r4.resources
GROUP BY resource_type
ORDER BY resources DESC;

-- HL7v2 message type breakdown
SELECT
    message_type,
    COUNT(*)                            AS messages
FROM hl7v2.messages
GROUP BY message_type
ORDER BY messages DESC;
