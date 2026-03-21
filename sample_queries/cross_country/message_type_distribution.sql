-- HL7v2 Message Type Distribution: USA vs NHS
--
-- Run each section against its respective database and compare results.

-- === Run against dr_open_sim_demo_usa ===

-- USA: HL7v2 message type breakdown
SELECT
    'USA' AS country,
    message_type,
    COUNT(*) AS message_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM hl7v2.messages
GROUP BY message_type
ORDER BY message_count DESC;


-- === Run against dr_open_sim_demo_nhs ===

-- NHS: HL7v2 message type breakdown
SELECT
    'NHS' AS country,
    message_type,
    COUNT(*) AS message_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM hl7v2.messages
GROUP BY message_type
ORDER BY message_count DESC;
