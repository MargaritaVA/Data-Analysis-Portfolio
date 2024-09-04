## 🌍 World's Biggest Data Breaches Analysis 

* **Goal**: To analyze breaches reported from 2008 to 2022 to identify trends and patterns, providing insights into the evolving landscape of data security and breach incidents globally.
* **Code**: [Breach_Analysis.sql](https://github.com/MargaritaVA/Data-Analysis/blob/main/Data-Breach-Analysis/Code.sql)
* **Dataset**: [World's Biggest Data Breaches & Hacks](https://www.kaggle.com/datasets/joebeachcapital/worlds-biggest-data-breaches-and-hacks/data)
* **Description**: This project involved cleaning and analyzing raw data to uncover key insights related to data breaches. The analysis aimed to determine the total number of breaches, the total and percentage of records lost, identify trends over time, and pinpoint the most common breach methods. Additionally, it explored the industries most affected, identified companies with the highest record losses, assessed the impact of data sensitivity, examined the correlation between data sensitivity and breach methods, and analyzed discrepancies between actual and reported records.  
* **Skills**:
    * Data Cleaning: Utilize `RegEx` for filtering and `SUBSTRING_INDEX` for formatting data. Convert data types from `varchar` to `date` and `bigint` as needed. Apply `CASE` statements to standardise and update values, and remove unnecessary columns to optimize the dataset for analysis. 
    * Analysis: Employ subqueries, joins, aggregate functions, and window functions to perform comprehensive data analysis.
* **Technology**: MySQL Workbench, SQL.
* **Results**:
   1. The majority of breaches, 114 (27.34%), and the largest number of records lost, 7,059,235,665 (49.23%), occurred in the web sector. This was followed by the government sector with 46 breaches (11.03%) and 923,579,573 records lost (6.44%), and the health sector with 43 breaches (10.31%) and 174,669,929 records lost. This indicates that the web sector is the most vulnerable to breaches and hacks.
   2. From June 2004 to August 2022, the total number of breaches has increased significantly. Until 2006, no more than five major breaches were recorded per year. However, after 2006, the number of breaches began to rise sharply, reaching 10-19 breaches per year. In 2011, there were 37 breaches reported. The number of breaches per year has remained consistently high, with the most significant spike occurring in 2019, when 45 breaches were recorded. This trend highlights the substantial and growing risk that data breaches pose to companies and businesses.
   3. Top 10 breached with the most records lost:

      | Organisation  | Month & Year  | Records Lost  | Method        |
      | ------------- | ------------- | ------------- | ------------- |
      | LinkedIn      | Jul 2021      | 700 million   | hacked        |
      | Aadhaar       | May 2018      | 550 million   | poor security |
      | Yahoo         | Dec 2016      | 550 million   | hacked        |
      | Facebook      | Mar 2021      | 533 million   | hacked        |
      | Spambot       | Aug 2017      | 520 million   | poor security |
      | Shanghai Police| Jul 2022     | 500 million   | hacked        |
      | Yahoo         | Sept 2016     | 500 million   | hacked        |
      | Syniverse     | Sept 2021     | 500 million   | hacked        |
      | Facebook      | Sept 2019     | 419 million   | poor security |
      | Friend Finder Network|Nov 2016| 419 million   | hacked        |





