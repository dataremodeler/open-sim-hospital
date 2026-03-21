-- Browse SUS Submissions (NHS)
-- Explore Secondary Uses Service data in dr_open_sim_demo_nhs

-- Count submissions by dataset type
-- APC = Admitted Patient Care, OP = Outpatients,
-- AE = Accident & Emergency, ECDS = Emergency Care Data Set
SELECT
    dataset_type,
    COUNT(*) AS submission_count
FROM sus.submissions
GROUP BY dataset_type
ORDER BY submission_count DESC;

-- View sample APC (Admitted Patient Care) records
SELECT
    submission_id,
    dataset_type,
    patient_id,
    created_at,
    LEFT(content, 500) AS content_preview
FROM sus.submissions
WHERE dataset_type = 'APC'
ORDER BY created_at DESC
LIMIT 5;

-- View the full content of a single APC submission
SELECT
    submission_id,
    dataset_type,
    patient_id,
    content,
    created_at
FROM sus.submissions
WHERE dataset_type = 'APC'
LIMIT 1;

-- Submissions per day by dataset type
SELECT
    DATE(created_at) AS submission_date,
    dataset_type,
    COUNT(*) AS daily_count
FROM sus.submissions
GROUP BY DATE(created_at), dataset_type
ORDER BY submission_date DESC, daily_count DESC
LIMIT 50;

-- Browse ECDS attendances
SELECT
    attendance_id,
    patient_id,
    created_at,
    LEFT(content, 500) AS content_preview
FROM ecds.attendances
ORDER BY created_at DESC
LIMIT 10;
