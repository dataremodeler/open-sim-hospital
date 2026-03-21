-- SUS Admitted Patient Care Analysis (NHS)
-- Parse and analyse APC submissions in dr_open_sim_demo_nhs

-- Total APC submissions and unique patients
SELECT
    COUNT(*) AS total_apc_submissions,
    COUNT(DISTINCT patient_id) AS unique_patients
FROM sus.submissions
WHERE dataset_type = 'APC';

-- APC submissions over time
SELECT
    DATE(created_at) AS admission_date,
    COUNT(*) AS apc_count,
    COUNT(DISTINCT patient_id) AS unique_patients
FROM sus.submissions
WHERE dataset_type = 'APC'
GROUP BY DATE(created_at)
ORDER BY admission_date DESC
LIMIT 30;

-- Patients with the most APC submissions (frequent admissions)
SELECT
    patient_id,
    COUNT(*) AS admission_count,
    MIN(created_at) AS first_admission,
    MAX(created_at) AS last_admission
FROM sus.submissions
WHERE dataset_type = 'APC'
GROUP BY patient_id
ORDER BY admission_count DESC
LIMIT 20;

-- Compare APC vs ECDS volumes per day
-- Useful for understanding the balance of planned vs emergency care
SELECT
    DATE(s.created_at) AS care_date,
    COUNT(CASE WHEN s.dataset_type = 'APC' THEN 1 END) AS apc_count,
    (SELECT COUNT(*)
     FROM ecds.attendances a
     WHERE DATE(a.created_at) = DATE(s.created_at)) AS ecds_count
FROM sus.submissions s
WHERE s.dataset_type = 'APC'
GROUP BY DATE(s.created_at)
ORDER BY care_date DESC
LIMIT 30;
