-- =============================================================================
-- Demo Query 07: Per-Member-Per-Month (PMPM) Costs
-- Based on tuva_input.medical_claim + eligibility member months
-- Database: dr_open_sim_demo_usa
-- =============================================================================

-- Member months by payer (denominator for PMPM)
WITH member_months AS (
    SELECT
        payer,
        SUM(
            EXTRACT(YEAR FROM AGE(
                LEAST(enrollment_end_date, CURRENT_DATE),
                enrollment_start_date
            )) * 12
            + EXTRACT(MONTH FROM AGE(
                LEAST(enrollment_end_date, CURRENT_DATE),
                enrollment_start_date
            )) + 1
        ) AS total_member_months
    FROM tuva_input.eligibility
    GROUP BY payer
),

-- Allowed amount by payer
claim_costs AS (
    SELECT
        e.payer,
        SUM(mc.paid_amount)             AS total_paid,
        SUM(mc.allowed_amount)          AS total_allowed
    FROM tuva_input.medical_claim mc
    JOIN tuva_input.eligibility e ON e.person_id = mc.person_id
    GROUP BY e.payer
)

SELECT
    cc.payer,
    mm.total_member_months,
    ROUND(cc.total_paid, 2)             AS total_paid_amount,
    ROUND(cc.total_allowed, 2)          AS total_allowed_amount,
    ROUND(cc.total_paid / NULLIF(mm.total_member_months, 0), 2)
                                        AS pmpm_paid,
    ROUND(cc.total_allowed / NULLIF(mm.total_member_months, 0), 2)
                                        AS pmpm_allowed
FROM claim_costs cc
JOIN member_months mm ON mm.payer = cc.payer
ORDER BY pmpm_allowed DESC;

-- PMPM by claim type (inpatient vs outpatient vs professional)
SELECT
    claim_type,
    COUNT(DISTINCT person_id)           AS unique_patients,
    ROUND(SUM(paid_amount), 2)          AS total_paid,
    ROUND(AVG(paid_amount), 2)          AS avg_claim_amount
FROM tuva_input.medical_claim
WHERE claim_type IS NOT NULL
GROUP BY claim_type
ORDER BY total_paid DESC;
