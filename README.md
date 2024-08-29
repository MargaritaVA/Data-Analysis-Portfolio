# Data Analysis Portfolio

*Welcome to my portfolio!*

I am passionate about continuous learning and enjoy leveraging data to uncover trends, streamline processes, and develop solutions that address complex business challenges. 
My journey in data analysis is driven by a strong foundation in customer relations and fintech insurance, where I've honed my skills and expanded my technical expertise.

This portfolio highlights a curated selection of projects that demonstrate my proficiency in **Advanced Excel**, **SQL**, and **Tableau**. 
Each project reflects my commitment to data-driven problem-solving and my ability to translate insights into actionable results.

***

## Projects

### Weekly Sales Performance Overview for Online Store

* **Code**: [Sales_Week_12_09.sql](https://github.com/MargaritaVA/Data-Analysis/blob/main/Online-Store-Weekly-Sales)
* **Goal**: Develop reusable code to generate weekly performance reports on sales and revenue for an online store, enabling the identification of trends on a weekly, daily, and hourly basis.
* **Dataset**: The dataset, sourced from [Kaggle](https://www.kaggle.com/datasets/mashlyn/online-retail-ii-uci), consists of transactions for a UK-based online retailer.
* **Description**: The SQL code developed for this project automates the process of extracting, cleaning, and analyzing data for the selected week. It efficiently pulls the relevant data, stores it in a separate file, and performs a comprehensive analysis of key performance indicators (KPIs).
* **Skills**:
    * Cleaning: use of RegEx for filtering, CAST for data type conversion, and TRIM and REPLACE for standardization.
    * Analysis: Common Table Expressions (CTEs), window functions (OVER ()), self-joins, aggregate functions with GROUP BY, as well as using ROUND, SUM, AVG, and COUNT. 
* **Technology**: MySQL Workbench, SQL.
* **Results**: The code retrieves the following data for the week of 2009-12-01 to 2009-12-07:
    - Daily revenue and rolling totals 
    - Peak sales hours by day
    - Top 10 best-selling products
    - Average and maximum invoice amounts
    - Sales and revenue breakdown by country 
