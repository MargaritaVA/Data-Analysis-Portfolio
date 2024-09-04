## 🌍 World's Biggest Data Breaches 

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

      The most records were stolen from social media accounts, email providers, and government institutions.
   4. Hacking was identified as the most common method of data theft.

      | Method       | Total Breaches| % of TB | Records Lost |
      | -------------| ------------- | --------| ------------ |
      | hacked       | 274           | 65.71   | 9.2 billion  |
      | poor security| 53            | 12.71   | 4 billion    |
      | lost device  | 48            | 11.51   | 215 million  |
      | human error  | 22            | 5.28    | 436 million  |
      | inside job   | 20            | 4.80    | 360 million  |
   5. An analysis of the impact of data sensitivity revealed that most successful breaches involved stolen passwords, email addresses, and personal details. This indicates that mostly data at the 1st and 2nd levels of sensitivity was compromised, with the 5th level being the highest in sensitivity.
   6. The correlation between data sensitivity and breach methods revealed that hacking was the most common method across all levels of data sensitivity. However, the subsequent methods varied depending on the sensitivity scale. Data at the 1st and 2nd levels of sensitivity, including emails, online information, and passwords, was often compromised due to poor security and human error. Data at the 3rd and 4th levels, such as credit card information, health records, and personal data, was frequently breached due to lost devices and inadequate security measures. For highly sensitive data at the 5th level, "inside jobs" emerged as the second most common method of breach after hacking.
   7. Out of 70 organisations that reported the number of breached records, 7 reported a lower number than the actual figure, 7 reported a higher number, and 56 disclosed the accurate number to the public.
   8. 
      



