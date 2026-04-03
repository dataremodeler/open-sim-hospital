-- =============================================================================
-- Demo Query 06: Chronic Condition Flags
-- Requires: dbt build (chronic_conditions mart)
-- Schema prefix: adjust to match your dbt output schema
-- Database: dr_open_sim_demo_usa
-- =============================================================================

-- Prevalence of each chronic condition in the population
SELECT
    condition                           AS chronic_condition,
    COUNT(DISTINCT person_id)           AS patients,
    ROUND(100.0 * COUNT(DISTINCT person_id) / (SELECT COUNT(DISTINCT person_id) FROM tuva_input.eligibility), 1)
                                        AS prevalence_pct
FROM tuva_chronic_conditions.tuva_chronic_conditions_long
GROUP BY condition
ORDER BY patients DESC;

-- Patients with multiple chronic conditions (multi-morbidity)
SELECT
    condition_count,
    COUNT(*) AS patients,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct
FROM (
    SELECT person_id, COUNT(*) AS condition_count
    FROM tuva_chronic_conditions.tuva_chronic_conditions_long
    GROUP BY person_id
) sub
GROUP BY condition_count
ORDER BY condition_count;

-- Most common condition combinations (top 10 pairs)
SELECT
    a.condition AS condition_a,
    b.condition AS condition_b,
    COUNT(*)    AS patients_with_both
FROM tuva_chronic_conditions.tuva_chronic_conditions_long a
JOIN tuva_chronic_conditions.tuva_chronic_conditions_long b
  ON a.person_id = b.person_id
 AND a.condition < b.condition     -- avoid duplicates
GROUP BY a.condition, b.condition
ORDER BY patients_with_both DESC
LIMIT 10;
