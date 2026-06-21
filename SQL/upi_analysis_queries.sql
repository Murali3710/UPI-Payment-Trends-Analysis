-- 6.1 Creating UPI Analysis Database
CREATE DATABASE upi_analysis;

-- Using this Data base
USE upi_analysis;

-- 6.2 Creating UPI Analysis Table
CREATE TABLE upi_data(
id INT AUTO_INCREMENT PRIMARY KEY,
Month DATE,
Financial_Year VARCHAR(10),
Bank_Count INT,
Transaction_Volume_Mn FLOAT,
Transaction_Value_Cr  FLOAT,
Year INT,
Month_Name VARCHAR(20 ),
Month_Number INT
);
-- 6.3 — Import CSV Data 

-- 6.4 View All Data
SELECT * FROM upi_data;

-- 6.5 Total rows count
SELECT COUNT(*) AS Total_Records FROM upi_data;

-- 6.6 Year wise Growth
-- Question: Show total Transaction Volume and Transaction Value
--           for each Year ordered from oldest to newest?
SELECT
     Year,
     ROUND(SUM(Transaction_Volume_Mn)/1000,2) as Volume_Billions,
     ROUND(SUM(Transaction_Value_Cr)/100000,2) as Value_Lakhs_Cr
FROM upi_data
GROUP BY Year
ORDER BY Year; 

-- 6.7 Month wise Trends
-- Question: Show total Transaction Volume and Transaction Value
--           for each Month ordered by Month Number?
SELECT
    Month_Number,
    Month_Name,
   ROUND(SUM(Transaction_Volume_Mn)/1000,2) as Volume_Billions,
   ROUND(SUM(Transaction_Value_Cr)/100000,2)as Value_Lakhs_Cr
FROM upi_data
GROUP BY
    Month_Number,
    Month_Name
ORDER BY
	Month_Number;

-- 6.8 Bank Adoption Analysis
-- Question: Show maximum number of banks on UPI
--           for each Year ordered from oldest to newest?

SELECT 
      Year,
      MAX(Bank_Count) as Total_Banks
FROM upi_data
GROUP BY Year
ORDER BY Year;

-- 6.9 Post COVID Analysis
-- Question: Show total Transaction Volume in Billions and
--           Transaction Value in Lakh Crores for
--           Pre COVID (before 2020), During COVID (2020)
--           and Post COVID (after 2020)?
SELECT
      CASE
          WHEN Year < 2020 THEN 'Pre COVID (2016-2019)'
          WHEN Year = 2020 THEN 'During COVID (2020)'
		  ELSE 'Post COVID(2021-2024)'
  END AS COVID_Period,
  CASE
      WHEN Year < 2020 THEN '2016-2019'
      WHEN Year = 2020 THEN '2020'
      ELSE '2021-2025'
      END AS Period_Year,
ROUND(SUM(Transaction_Volume_Mn)/1000,2) as Volume_Billions,
ROUND(SUM(Transaction_Value_Cr)/100000,2) as Value_Lakh_Cr
FROM upi_data
GROUP BY COVID_Period,Period_Year
ORDER BY MIN(Year);

-- 6.10 Top Performing Years
-- Question: Show top 5 years with highest Transaction Volume
--           in Billions and Transaction Value in Lakh Crores?

SELECT 
      Year,
ROUND(SUM(Transaction_Volume_Mn)/1000,2) AS Volume_Billions,
ROUND(SUM(Transaction_Value_Cr)/100000,2) AS Value_Lakh_Cr
FROM upi_data
GROUP BY Year
ORDER BY  
         Volume_Billions DESC,
		 Value_Lakh_Cr DESC
LIMIT 5;

-- 6.11 Year on Year Growth Rate %
-- Question: Show Transaction Volume growth rate %
--           compared to previous year?

WITH yearly AS (
     SELECT
          Year,
          ROUND(SUM(Transaction_Volume_Mn) / 1000, 2) AS Volume_Billions
     FROM upi_data
     GROUP BY Year
)
SELECT
     Year,
     Volume_Billions,
     CONCAT(
          ROUND(
               (Volume_Billions - LAG(Volume_Billions) OVER (ORDER BY Year))
               /
               LAG(Volume_Billions) OVER (ORDER BY Year)
               * 100
          , 2), '%'
     ) AS Growth_Rate_Percentage
FROM yearly
ORDER BY Year;

-- 6.12 Running Total Analysis
-- Question: Show cumulative total of Transaction Volume
--           in Billions from 2016 to 2025?

SELECT
      Year,
      ROUND(SUM(Transaction_Volume_Mn)/1000,2) as Volume_Billions,
      LAG(ROUND(SUM(Transaction_Volume_Mn)/1000,2)) OVER(ORDER BY Year) As Running_Total_Billions
FROM upi_data
GROUP BY Year
ORDER BY Year;
      
-- 6.13 Rank Years by Performance
-- Question: Rank all years based on highest 
--           Transaction Volume in Billions?

SELECT 
      Year,
      ROUND(SUM(Transaction_Volume_Mn)/1000,2) AS Volume_Billions,
      ROUND(SUM(Transaction_Value_Cr)/1000,2) AS Value_Lakhs_Cr,
      RANK() OVER(ORDER BY SUM(Transaction_Volume_Mn) DESC) as Year_Rank
FROM upi_data
GROUP BY Year
ORDER BY Year_Rank;

-- 6.14 Best & Worst Months
-- Question: Show which month has highest and 
--           lowest Transaction Volume overall?
SELECT
      Month_Name,
      Month_Number,
      ROUND(SUM(Transaction_Volume_Mn)/1000,2) AS Volume_Billions,
      ROUND(SUM(Transaction_Value_Cr)/1000,2) AS Value_Lakhs_Cr,
      RANK() OVER(ORDER BY SUM(Transaction_Volume_Mn) DESC) AS Best_Ranked_Month
FROM upi_data
GROUP BY 
   Month_Name,
   Month_Number
ORDER BY Best_Ranked_Month;

-- 6.15 COVID Impact in %
-- Question: Show how much Transaction Volume grew
--           from Pre COVID to Post COVID in %?
SELECT
      CASE 
		  WHEN Year < 2020 THEN 'pre COVID'
          WHEN Year = 2020 THEN 'During COVID'
          ELSE 'Post COVID'
          END AS COVID_Period,
	ROUND(SUM(Transaction_Volume_Mn)/1000,2) AS Volume_Billions,
    ROUND(SUM(Transaction_Value_Cr)/100000,2) AS Value_Lakhs_cr,
	CONCAT(
           ROUND(
                  SUM(Transaction_Volume_Mn)/
                  (SELECT SUM(Transaction_Volume_Mn) FROM upi_data)
                  * 100,
				2),
				  '%'
		    )  AS Contribution_Percentage
FROM upi_data
GROUP BY 
        COVID_Period
ORDER BY MIN(Year);
	
	
    
    
    










