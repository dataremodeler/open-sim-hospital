-- Browse HL7v2 Messages (NHS)
-- Explore the HL7v2 message feed in dr_open_sim_demo_nhs

-- Count messages by type
SELECT
    message_type,
    COUNT(*) AS message_count
FROM hl7v2.messages
GROUP BY message_type
ORDER BY message_count DESC;

-- View a sample ADT^A01 (patient admission) message
SELECT
    message_id,
    message_type,
    patient_id,
    created_at,
    LEFT(content, 500) AS content_preview
FROM hl7v2.messages
WHERE message_type = 'ADT^A01'
ORDER BY created_at DESC
LIMIT 5;

-- View the full content of a single message
SELECT
    message_id,
    message_type,
    patient_id,
    content,
    created_at
FROM hl7v2.messages
WHERE message_type = 'ADT^A01'
LIMIT 1;

-- Messages per day over time
SELECT
    DATE(created_at) AS message_date,
    message_type,
    COUNT(*) AS daily_count
FROM hl7v2.messages
GROUP BY DATE(created_at), message_type
ORDER BY message_date DESC, daily_count DESC
LIMIT 50;
