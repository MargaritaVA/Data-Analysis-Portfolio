
/* The following code can be used for preparing weekly reports for analyzing online sales to find:

- Revenue by day and rolling total 
- Peak sales hours by day
- Top 10 selling products
- AVG and MAX invoice amounts
- Sales and revenue by country 

The used dataset has the following columns: Invoice, StockCode, Description, Quantity, Price, Customer ID, Country, InvoiceDate. */


-- Data Cleaning

/* Creating a staging db (copy) to to keep raw data separate. */

  CREATE TABLE retail_staging LIKE online_retail_ii;

  INSERT retail_staging
  SELECT * 
  FROM online_retail_ii;

/* Converting InvoiceDate data type from String to DATETIME for use in time-based analysis. */

  ALTER TABLE retail_staging
  ADD COLUMN InvoiceDateTime DATETIME;

  UPDATE retail_staging 
  SET 
    InvoiceDateTime = CAST(InvoiceDate AS DATETIME);

  ALTER TABLE retail_staging
  DROP COLUMN InvoiceDate;

/* Removing data outside of the required data range (2009-12-01 to 2009-12-07) */

  DELETE FROM retail_staging 
  WHERE
    InvoiceDateTime NOT BETWEEN '2009-12-01' AND '2009-12-07';

/* Removing non-products using regular expression on the stock code. 

  Product codes contain 5 numbers or 5 numbers and 1 symbol. */
  DELETE FROM retail_staging 
  WHERE
    StockCode NOT REGEXP '^[0-9]{5}([a-zA-Z])?$';

/* Standarlized the description column by removing white spaces. */

  UPDATE retail_staging 
  SET 
    Description = TRIM(Description);

/* Renamed Customer ID column for consistancy */

  ALTER TABLE retail_staging
  CHANGE `Customer ID` CustomerID INT NOT NULL;

/* Replaced '&' to avoid export issues. */

  UPDATE retail_staging 
  SET 
    Description = REPLACE(Description, '&', 'AND');


-- Data Analysis 

/* Revenue by day and rolling total */

  WITH rolling_total AS (
  SELECT DATE(InvoiceDateTime) as `date`, SUM(Price * Quantity) AS revenue
  FROM retail_staging
  GROUP BY DATE(InvoiceDateTime)
  ORDER BY 1
  )
  SELECT `date`, ROUND(revenue) AS daily_revenue, ROUND(SUM(revenue) OVER (ORDER BY `date`)) AS total_revenue
  FROM rolling_total;

/* Peak sales hours by day */

  SELECT 
    t.sale_date, t.sale_hour, ROUND(t.revenue_by_hour) as max_revenue, t.items_sold
  FROM
    (SELECT 
        DATE(InvoiceDateTime) AS sale_date,
            HOUR(InvoiceDateTime) AS sale_hour,
            SUM(Price * Quantity) AS revenue_by_hour,
            SUM(Quantity) AS items_sold
    FROM
        retail_staging
    GROUP BY sale_date , sale_hour) t
        JOIN
    (SELECT 
        sale_date, MAX(revenue_by_hour) AS max_sales
    FROM
        (SELECT 
        DATE(InvoiceDateTime) AS sale_date,
            HOUR(InvoiceDateTime) AS sale_hour,
            SUM(Price * Quantity) AS revenue_by_hour
    FROM
        retail_staging
    GROUP BY sale_date , sale_hour) sub
    GROUP BY sale_date) m ON t.sale_date = m.sale_date
        AND t.revenue_by_hour = m.max_sales
  ORDER BY t.sale_date;

/* Top 10 selling products */

  SELECT 
    StockCode,
    Description,
    SUM(Quantity) AS Total_Quantity_Sold,
    ROUND(SUM(Price * Quantity)) AS Total_Product_Revenue
  FROM
    retail_staging
  GROUP BY StockCode , Description
  ORDER BY Total_Quantity_Sold DESC, Total_Product_Revenue DESC
  LIMIT 10;

/* AVG and MAX invoice amounts */

  SELECT 
    ROUND(AVG(invoice_total)) AS avg_invoice_amount,
    ROUND(MAX(invoice_total)) AS max_invoice_amount
  FROM
    (SELECT 
        Invoice, SUM(Price * Quantity) AS invoice_total
    FROM
        retail_staging
    GROUP BY Invoice) AS invoice_total;

/* Sales and revenue by country */

  SELECT 
    Country,
    COUNT(DISTINCT Invoice) AS total_sales,
    ROUND(SUM(Price * Quantity)) AS total_invoice_amount
  FROM
    retail_staging
  GROUP BY Country
  ORDER BY total_invoice_amount DESC , total_sales DESC;




