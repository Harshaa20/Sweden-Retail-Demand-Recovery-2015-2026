USE swedish_retail_demand;

USE swedish_retail_demand;

CREATE TABLE retail_demand (
    category VARCHAR(150) NOT NULL,
    observation_type VARCHAR(100) NOT NULL,
    month VARCHAR(7) NOT NULL,
    date DATE NOT NULL,
    value DECIMAL(10,2) NULL
);

USE swedish_retail_demand;

SELECT COUNT(*) AS total_rows
FROM retail_demand;

SELECT
    COUNT(DISTINCT category) AS categories,
    COUNT(DISTINCT observation_type) AS observation_types,
    COUNT(DISTINCT date) AS months
FROM retail_demand;

SELECT
    MIN(date) AS first_month,
    MAX(date) AS last_month,
    SUM(CASE WHEN value IS NULL THEN 1 ELSE 0 END) AS missing_values
FROM retail_demand;

SELECT
    current_data.category,
    current_data.date AS current_month,
    current_data.value AS current_value,
    previous_data.date AS previous_year_month,
    previous_data.value AS previous_year_value
FROM retail_demand AS current_data
LEFT JOIN retail_demand AS previous_data
    ON current_data.category = previous_data.category
    AND current_data.observation_type = previous_data.observation_type
    AND previous_data.date = DATE_SUB(current_data.date, INTERVAL 1 YEAR)
WHERE current_data.observation_type = 'Constant prices'
ORDER BY current_data.category, current_data.date
LIMIT 20;

SELECT
    current_data.category,
    current_data.date AS current_month,
    current_data.value AS current_value,
    previous_data.date AS previous_year_month,
    previous_data.value AS previous_year_value
FROM retail_demand AS current_data
LEFT JOIN retail_demand AS previous_data
    ON current_data.category = previous_data.category
    AND current_data.observation_type = previous_data.observation_type
    AND previous_data.date = DATE_SUB(current_data.date, INTERVAL 1 YEAR)
WHERE current_data.observation_type = 'Constant prices'
  AND current_data.category = '47.64 sports shops'
  AND current_data.date BETWEEN '2024-01-01' AND '2024-06-01'
ORDER BY current_data.date;

CREATE VIEW yoy_growth AS
SELECT
    current_data.category,
    current_data.date AS month,
    current_data.value AS current_index,
    previous_data.value AS previous_year_index,
    ROUND(
        ((current_data.value - previous_data.value)
        / previous_data.value) * 100,
        2
    ) AS yoy_growth_pct
FROM retail_demand AS current_data
LEFT JOIN retail_demand AS previous_data
    ON current_data.category = previous_data.category
    AND current_data.observation_type = previous_data.observation_type
    AND previous_data.date = DATE_SUB(current_data.date, INTERVAL 1 YEAR)
WHERE current_data.observation_type = 'Constant prices';

SELECT *
FROM yoy_growth
WHERE category = '47.64 sports shops'
  AND month BETWEEN '2024-01-01' AND '2024-06-01'
ORDER BY month;

--------------------------------------------------------------------------------------------------------------------------

-- This view compares each month's adjusted retail volume with that category's 2021 average.
CREATE VIEW recovery_index AS
SELECT
    current_data.category,
    current_data.date AS month,
    current_data.value AS adjusted_index,
    ROUND(
        (current_data.value / baseline.baseline_2021) * 100,
        2
    ) AS recovery_index_2021
FROM retail_demand AS current_data
JOIN (
    SELECT
        category,
        AVG(value) AS baseline_2021
    FROM retail_demand
    WHERE observation_type =
        'Seasonally adjusted, working day adjusted, constant prices'
        AND YEAR(date) = 2021
    GROUP BY category
) AS baseline
    ON current_data.category = baseline.category
WHERE current_data.observation_type =
    'Seasonally adjusted, working day adjusted, constant prices';


-- This checks the recovery index for the latest available month.
SELECT *
FROM recovery_index
WHERE month = '2026-07-01'
ORDER BY category;


-- This view calculates how many percentage points each category is above or below its 2021 baseline.
CREATE VIEW recovery_gap AS
SELECT
    category,
    month,
    adjusted_index,
    recovery_index_2021,
    ROUND(recovery_index_2021 - 100, 2) AS recovery_gap_pct
FROM recovery_index;


-- This checks the latest recovery position for every category.
SELECT *
FROM recovery_gap
WHERE month = '2026-07-01'
ORDER BY recovery_gap_pct;


-- This final check confirms that all three analytical views exist and contain data.
SELECT
    'yoy_growth' AS view_name,
    COUNT(*) AS row_count
FROM yoy_growth

UNION ALL

SELECT
    'recovery_index' AS view_name,
    COUNT(*) AS row_count
FROM recovery_index

UNION ALL

SELECT
    'recovery_gap' AS view_name,
    COUNT(*) AS row_count
FROM recovery_gap;

































