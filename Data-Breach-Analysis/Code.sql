-- The dataset consists of 12 columns: organisation, alternative_name, records_lost, year, date, story, sector, method, data_sensitivity, displayed_records, source_name, and ID.


-- Data Cleaning

-- Created a copy of the table with duplicates.
CREATE TABLE breach_staging
LIKE breaches;

INSERT breach_staging
SELECT * 
FROM breaches;

-- Observation: The days in the `date` column have different formats.
-- Checked and standardised the formats, and created a new column.

SELECT date
FROM breach_staging
WHERE date REGEXP '^[A-Za-z]{3}-[0-9]{2}$'; -- days in the format of `Aug-22`

SELECT date
FROM breach_staging
WHERE date NOT REGEXP '^[A-Za-z]{3}-[0-9]{2}$'; -- days in the format of `Aug 2022`

UPDATE breach_staging
SET date = CONCAT(SUBSTRING(date, 1, 3), ' 20', SUBSTRING(date, 5, 2))
WHERE date REGEXP '^[A-Za-z]{3}-[0-9]{2}$'; -- standardised format - 45 rows updated to `Aug 2022`

ALTER TABLE breach_staging
ADD COLUMN month_year DATE;

UPDATE breach_staging
SET month_year = STR_TO_DATE(CONCAT('01 ', date), '%d %b %Y'); -- inserted values into the new column in the right format

SELECT date, month_year
FROM breach_staging;

ALTER TABLE breach_staging
DROP COLUMN date;

ALTER TABLE breach_staging
RENAME COLUMN month_year TO date;

-- Observation: The `sector` column contains multiple values in some rows.

SELECT DISTINCT sector
FROM breach_staging;

-- Updated the column to show only the primary sector.

UPDATE breach_staging
SET sector = SUBSTRING_INDEX(sector, ',', 1); -- from 27 to 16 rows

-- Changed `records_lost` from varchar to bigint to enable calculations.
ALTER TABLE breach_staging
ADD COLUMN records_lost_clean BIGINT;

UPDATE breach_staging
SET records_lost_clean = CAST(REPLACE(records_lost, ',', '') AS UNSIGNED);

ALTER TABLE breach_staging
DROP COLUMN records_lost;

ALTER TABLE breach_staging
CHANGE COLUMN records_lost_clean records_lost BIGINT;

-- Updated some values in the `displayed_records` column from text to numbers.

SELECT * FROM breach_staging
WHERE displayed_records NOT REGEXP '[0-9]';

UPDATE breach_staging
SET displayed_records = CASE
    WHEN displayed_records = '"one billion"' THEN '1000000000'
    WHEN displayed_records = 'unknown' THEN NULL
    ELSE displayed_records
END;

-- Created a new column with the correct data type (bigint).

ALTER TABLE breach_staging
ADD COLUMN displayed_records_clean BIGINT;

-- Copied the records from the original `displayed_records` column.

UPDATE breach_staging
SET displayed_records_clean = CAST(REPLACE(displayed_records, ',', '') AS UNSIGNED);

ALTER TABLE breach_staging
DROP COLUMN displayed_records;

ALTER TABLE breach_staging
CHANGE COLUMN displayed_records_clean displayed_records BIGINT;

-- Removed unnecessary columns.

ALTER TABLE breach_staging
DROP COLUMN year;

ALTER TABLE breach_staging
DROP COLUMN story;

ALTER TABLE breach_staging
DROP COLUMN source_name;

ALTER TABLE breach_staging
DROP COLUMN alternative_name;



-- Data Analysis

-- 1. Calculated the total number of breaches, total records lost, and their percentages.
SELECT
    sector,
    total_breaches,
    ROUND((total_breaches * 100.0 / totals.total_breaches_all),2) AS `%_breaches`,
    total_records_lost,
    ROUND((total_records_lost * 100.0 / totals.total_records_lost_all),2) AS `%_records_lost`
FROM (
    SELECT
        sector,
        COUNT(id) AS total_breaches,
        SUM(records_lost) AS total_records_lost
    FROM breach_staging
    GROUP BY sector
) AS subquery 
JOIN (
    SELECT
        COUNT(id) AS total_breaches_all,
        SUM(records_lost) AS total_records_lost_all
    FROM breach_staging
) AS totals
ORDER BY total_breaches DESC;

-- 2. Analysed trends over time.

SELECT 
	date, 
	COUNT(id) AS total_breaches, 
    SUM(records_lost) AS total_records_lost,
    MAX(records_lost) AS max_per_company,
    ROUND(AVG(records_lost)) AS avrage_records_lost
FROM breach_staging
GROUP BY 1
ORDER BY 1;

-- 3. Identified the top 10 companies with the most records lost.

SELECT 
    organisation,
    date,
    records_lost,
    method,
    sector,
    data_sensitivity
FROM
    breach_staging
ORDER BY records_lost DESC
LIMIT 10;

-- 4. Determined the percentage of total breaches by method. 

WITH total_breaches AS (
    SELECT 
        COUNT(id) AS total_breaches_all
    FROM 
        breach_staging
)
SELECT 
    method,
    COUNT(id) AS total_breaches,
    ROUND((COUNT(id) * 100.0 / tb.total_breaches_all),2) AS `%_of_total_breaches`,
    SUM(records_lost) AS total_records_lost
FROM 
    breach_staging,
    total_breaches tb
GROUP BY 
    method, tb.total_breaches_all
ORDER BY 
    total_breaches DESC;

-- 5. Assessed the impact of data sensitivity on the number of records lost.

SELECT 
    data_sensitivity,
    COUNT(id) AS total_breaches,
    SUM(records_lost) AS total_records_lost
FROM
    breach_staging
GROUP BY data_sensitivity
ORDER BY total_breaches DESC;

-- 6. Examined the correlation between data sensitivity and breach method.

SELECT 
    data_sensitivity,
    method,
    COUNT(id) AS total_breaches,
    SUM(records_lost) AS total_records_lost
FROM
    breach_staging
WHERE data_sensitivity is not null
GROUP BY data_sensitivity , method
ORDER BY data_sensitivity, total_breaches DESC;

-- 7. Analysed the count of displayed versus actual records lost.

SELECT 
    organisation,
    date,
    records_lost,
    displayed_records,
    (records_lost - displayed_records) AS discrepancy
FROM
    breach_staging
WHERE
    displayed_records IS NOT NULL
ORDER BY discrepancy DESC;

-- 8. Identified outliers in terms of records lost compared to others in the same sector or year (top 3 organisations per sector).

WITH ranked_organisations AS (
    SELECT 
        organisation,
        sector,
        date,
        records_lost,
        ROW_NUMBER() OVER (PARTITION BY sector ORDER BY SUM(records_lost) DESC) AS `rank`
    FROM 
        breach_staging
    GROUP BY 
        organisation, sector, date, records_lost
    HAVING 
        SUM(records_lost) > (
            SELECT AVG(records_lost) * 2 
            FROM breach_staging 
            WHERE sector = breach_staging.sector
        )
)
SELECT 
    organisation, 
    sector, 
    date, 
    records_lost
FROM 
    ranked_organisations
WHERE 
    `rank` <= 3
ORDER BY 
    sector, `rank`;
