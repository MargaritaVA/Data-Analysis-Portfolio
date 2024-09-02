-- Data Cleaning

-- Created a copy of the table with duplicates 
CREATE TABLE breach_staging
LIKE breaches;

INSERT breach_staging
SELECT * 
FROM breaches;

-- year and data standartisation, combining into one column, row have different format (some days are in the format of Aug-22 and some in Aug 2022
-- sector refining (taking only primary sector)
-- removing unnecessary columns (alternative name, story, displayed records -not enogh data, source_name)

SELECT date
FROM breach_staging
WHERE date REGEXP '^[A-Za-z]{3}-[0-9]{2}$'; -- days in the format of Aug-22

SELECT date
FROM breach_staging
WHERE date NOT REGEXP '^[A-Za-z]{3}-[0-9]{2}$'; -- days in the format of Aug 2022

UPDATE breach_staging
SET date = CONCAT(SUBSTRING(date, 1, 3), ' 20', SUBSTRING(date, 5, 2))
WHERE date REGEXP '^[A-Za-z]{3}-[0-9]{2}$'; -- standardizing format - 45 rows updated to Aug 2022

ALTER TABLE breach_staging
ADD COLUMN month_year DATE;

UPDATE breach_staging
SET month_year = STR_TO_DATE(CONCAT('01 ', date), '%d %b %Y'); -- insering the values into the new column in the right format

SELECT date, month_year
FROM breach_staging;

ALTER TABLE breach_staging
DROP COLUMN date;

ALTER TABLE breach_staging
RENAME COLUMN month_year TO date;

-- refining the 'sector' column, some rows have 2 values divided by comma

select distinct sector
from breach_staging;

UPDATE breach_staging
SET sector = SUBSTRING_INDEX(sector, ',', 1); -- from 27 to 16 rows

-- changing records_lost from varchar to bigint
ALTER TABLE breach_staging
ADD COLUMN records_lost_clean BIGINT;

UPDATE breach_staging
SET records_lost_clean = CAST(REPLACE(records_lost, ',', '') AS UNSIGNED);

ALTER TABLE breach_staging
DROP COLUMN records_lost;

ALTER TABLE breach_staging
CHANGE COLUMN records_lost_clean records_lost BIGINT;

-- updated the displayed_records column

SELECT * FROM breach_staging
WHERE displayed_records NOT REGEXP '[0-9]';

UPDATE breach_staging
SET displayed_records = CASE
    WHEN displayed_records = '"one billion"' THEN '1000000000'
    WHEN displayed_records = 'unknown' THEN NULL
    ELSE displayed_records
END;

-- removing commas to change datatype from varchar to bigint
ALTER TABLE breach_staging
ADD COLUMN displayed_records_clean BIGINT;

UPDATE breach_staging
SET displayed_records_clean = CAST(REPLACE(displayed_records, ',', '') AS UNSIGNED);

ALTER TABLE breach_staging
DROP COLUMN displayed_records;

ALTER TABLE breach_staging
CHANGE COLUMN displayed_records_clean displayed_records BIGINT;

-- removing unnecessary columns

ALTER TABLE breach_staging
DROP COLUMN year;

ALTER TABLE breach_staging
DROP COLUMN story;

ALTER TABLE breach_staging
DROP COLUMN source_name;

ALTER TABLE breach_staging
DROP COLUMN alternative_name;





-- Data Analysis
-- sector by breaches, by records lost 

-- 1. Main query to calculate total breaches, total records lost, and their percentages
SELECT
    sector,
    total_breaches,
    ROUND((total_breaches * 100.0 / totals.total_breaches_all),2) AS `%_breaches`,
    total_records_lost,
    ROUND((total_records_lost * 100.0 / totals.total_records_lost_all),2) AS `%_records_lost`
FROM (
    -- Subquery to calculate total breaches and records lost per sector
    SELECT
        sector,
        COUNT(id) AS total_breaches,
        SUM(records_lost) AS total_records_lost
    FROM breach_staging
    GROUP BY sector
) AS subquery 
JOIN (
    -- Subquery to calculate the overall totals across all sectors and methods
    SELECT
        COUNT(id) AS total_breaches_all,
        SUM(records_lost) AS total_records_lost_all
    FROM breach_staging
) AS totals
ORDER BY total_breaches DESC;
/*the most records 7059235665 were lost in the web sector 114 breaches
tech 1593738818 in 28 breached
finance 1162050100 in 39 breaches*/



-- 2. trends over time
-- data from 01/06/2004 to 01/08/2022
SELECT 
	date, 
	COUNT(id) AS total_breaches, 
    SUM(records_lost) AS total_records_lost,
    MAX(records_lost) AS max_per_company,
    ROUND(AVG(records_lost)) AS avrage_records_lost
FROM breach_staging
GROUP BY 1
ORDER BY 1;

-- 3. top 10 
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


-- 4. methods of breach 
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
-- top value is hached lost the most records 9273769852 and most breached 274

-- 5. impact of data sensitivity
SELECT 
    data_sensitivity,
    COUNT(id) AS total_breaches,
    SUM(records_lost) AS total_records_lost
FROM
    breach_staging
GROUP BY data_sensitivity
ORDER BY total_breaches DESC;
-- most records lost in the 1 and 2 degree of sensitivity. the higher the sensitivity, less records lost

-- 6. correlation between data sensitivity and method 
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
-- 1st degree: hacking, poor security, hum er
-- 2nd degree: hacking, poor security, lost device
-- 3rd degree: hacking, lost device, poor security
-- 4th degree: hacking, lost device, poor security
-- 5th degree: hacking, inside job, poor security

-- 7. displayed vs actual records
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

-- outliers in terms of records lost compared to others in the same sector or year.
-- 8. top 3 organisations per sector

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
