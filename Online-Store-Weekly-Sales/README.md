## 💷 Weekly Sales Performance Overview for Online Store 

* **Goal**: Develop reusable code to generate weekly performance reports on sales and revenue for an online store, enabling the identification of trends on a weekly, daily, and hourly basis.
* **Code**: [Sales_Week_12_09.sql](https://github.com/MargaritaVA/Data-Analysis/blob/main/Online-Store-Weekly-Sales/Sales-Report.sql)
* **Dataset**: The dataset, sourced from [Kaggle](https://www.kaggle.com/datasets/mashlyn/online-retail-ii-uci), consists of transactions for a UK-based online retailer.
* **Description**: The SQL code automates the process of extracting, cleaning, and analyzing data for the selected week. It pulls the relevant data, stores it in a separate file, and performs an analysis of key performance indicators (KPIs).
* **Skills**:
    * Cleaning: use of RegEx for filtering, CAST for data type conversion, and TRIM and REPLACE for standardization.
    * Analysis: Common Table Expressions (CTEs), window functions (OVER ()), self-joins, aggregate functions with GROUP BY, as well as using ROUND, SUM, AVG, and COUNT. 
* **Technology**: MySQL Workbench, SQL.
* **Results**: The code retrieves the following data for the requested week:
    - Daily revenue and rolling totals 
    - Peak sales hours by day
    - Top 10 best-selling products
    - Average and maximum invoice amounts
    - Sales and revenue breakdown by country 
