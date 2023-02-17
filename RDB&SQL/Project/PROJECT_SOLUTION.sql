SELECT TOP (1000) [Ord_ID]
      ,[Cust_ID]
      ,[Prod_ID]
      ,[Ship_ID]
      ,[Order_Date]
      ,[Ship_Date]
      ,[Customer_Name]
      ,[Province]
      ,[Region]
      ,[Customer_Segment]
      ,[Sales]
      ,[Order_Quantity]
      ,[Order_Priority]
      ,[DaysTakenForShipping]
  FROM [ECOMMERCE].[dbo].[e_commerce_data]

-- Find the top 3 customers who have the maximum count of orders.

SELECT TOP 3 Cust_ID, COUNT(Ord_ID) AS OrderCount
FROM e_commerce_data
GROUP BY Cust_ID
ORDER BY OrderCount DESC

-- Find the customer whose order took the maximum time to get shipping.

SELECT TOP 1 Cust_ID, MAX(DaysTakenForShipping) AS MaxDays
FROM e_commerce_data
GROUP BY Cust_ID
ORDER BY MaxDays DESC

-- Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011.


SELECT Cust_ID AS TotalCustomers
FROM e_commerce_data
WHERE YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = 1 
INTERSECT 
SELECT Cust_ID AS TotalCustomers
FROM e_commerce_data
WHERE YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = 2
INTERSECT
SELECT Cust_ID AS TotalCustomers
FROM e_commerce_data
WHERE YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = 3
INTERSECT
SELECT Cust_ID AS TotalCustomers
FROM e_commerce_data
WHERE YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = 4
INTERSECT
SELECT Cust_ID AS TotalCustomers
FROM e_commerce_data
WHERE YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = 5
INTERSECT
SELECT Cust_ID AS TotalCustomers
FROM e_commerce_data
WHERE YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = 6
INTERSECT
SELECT Cust_ID AS TotalCustomers
FROM e_commerce_data
WHERE YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = 7
INTERSECT
SELECT Cust_ID AS TotalCustomers
FROM e_commerce_data
WHERE YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = 8
INTERSECT
SELECT Cust_ID AS TotalCustomers
FROM e_commerce_data
WHERE YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = 9
INTERSECT
SELECT Cust_ID AS TotalCustomers
FROM e_commerce_data
WHERE YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = 10
INTERSECT
SELECT Cust_ID AS TotalCustomers
FROM e_commerce_data
WHERE YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = 11
INTERSECT
SELECT Cust_ID AS TotalCustomers
FROM e_commerce_data
WHERE YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = 12

-- Write a query to return for each user the time elapsed between the first purchasing and the third purchasing, in ascending order by Customer ID.

SELECT Cust_ID, MIN(Order_Date) AS FirstPurchase, MAX(Order_Date) AS ThirdPurchase
FROM e_commerce_data
GROUP BY Cust_ID
HAVING COUNT(Ord_ID) >= 3
ORDER BY Cust_ID

-- Write a query that returns customers who purchased both product 11 and product 14, as well as the ratio of these products to the total number of products purchased by the customer.

SELECT Cust_ID, COUNT(DISTINCT Prod_ID) AS TotalProducts
FROM e_commerce_data
WHERE Prod_ID IN ('Prod_11', 'Prod_14')
GROUP BY Cust_ID
HAVING COUNT(DISTINCT Prod_ID) >= 2
ORDER BY Cust_ID




-- Customer Segments

-- Categorize customers based on their frequency of purchase. The categories are as follows:
-- 1. Create a “view” that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)

SELECT Cust_ID, YEAR(Order_Date) AS Year, MONTH(Order_Date) AS Month
FROM e_commerce_data
ORDER BY Cust_ID, Year, Month

-- 2. Create a “view” that keeps the number of monthly visits by users. (Show separately all months from the beginning business)

SELECT Cust_ID, YEAR(Order_Date) AS Year, MONTH(Order_Date) AS Month, COUNT(Ord_ID) AS VisitCount
FROM e_commerce_data
GROUP BY Cust_ID, YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Cust_ID, Year, Month

-- 3. For each visit of customers, create the next month of the visit as a separate column.


-- 4. Calculate the monthly time gap between two consecutive visits by each customer.

SELECT Cust_ID, YEAR(Order_Date) AS Year, MONTH(Order_Date) AS Month, COUNT(Ord_ID) AS VisitCount, 
       DATEDIFF(MONTH, LAG(Order_Date) OVER (PARTITION BY Cust_ID ORDER BY Order_Date), Order_Date) AS TimeGap
FROM e_commerce_data
GROUP BY Cust_ID, YEAR(Order_Date), MONTH(Order_Date), Order_Date
ORDER BY Cust_ID, Year, Month

-- 5. Categorise customers using average time gaps. Choose the most fitted labeling model for you. For example: Labeled as churn if the customer hasn't made another purchase in the months since they made their first purchase. Labeled as regular if the customer has made a purchase every month. Etc.

SELECT Cust_ID, YEAR(Order_Date) AS Year, MONTH(Order_Date) AS Month, COUNT(Ord_ID) AS VisitCount, 
       DATEDIFF(MONTH, LAG(Order_Date) OVER (PARTITION BY Cust_ID ORDER BY Order_Date), Order_Date) AS TimeGap,
       CASE
           WHEN DATEDIFF(MONTH, LAG(Order_Date) OVER (PARTITION BY Cust_ID ORDER BY Order_Date), Order_Date) <= 1 THEN 'Regular'
           WHEN DATEDIFF(MONTH, LAG(Order_Date) OVER (PARTITION BY Cust_ID ORDER BY Order_Date), Order_Date) > 1 THEN 'Irregular'
       END AS CustomerSegment
FROM e_commerce_data
GROUP BY Cust_ID, YEAR(Order_Date), MONTH(Order_Date), Order_Date
ORDER BY Cust_ID, Year, Month



-- Month-Wise Retention Rate

-- Find the month by month customer retention rate since the start of the business.
-- There are many different variations in the calculation of Retention Rate. But we will try to calculate the month-wise retention rate in this project.
-- So, we will be interested in how many of the customers in the previous month could be retained in the next month.
-- Proceed step by step by creating “views”. You can use the view you got at the end of the Customer Segmentation section as a source.
-- Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Current Month / Total Number of Customers in the Current Month

-- 1. Find the number of customers retained month-wise. (You can use time gaps)

SELECT Cust_ID, YEAR(Order_Date) AS Year, MONTH(Order_Date) AS Month, COUNT(Ord_ID) AS VisitCount, 
       DATEDIFF(MONTH, LAG(Order_Date) OVER (PARTITION BY Cust_ID ORDER BY Order_Date), Order_Date) AS TimeGap,
       CASE
           WHEN DATEDIFF(MONTH, LAG(Order_Date) OVER (PARTITION BY Cust_ID ORDER BY Order_Date), Order_Date) <= 1 THEN 'Regular'
           WHEN DATEDIFF(MONTH, LAG(Order_Date) OVER (PARTITION BY Cust_ID ORDER BY Order_Date), Order_Date) > 1 THEN 'Irregular'
       END AS CustomerSegment
FROM e_commerce_data
WHERE DATEDIFF(MONTH, LAG(Order_Date) OVER (PARTITION BY Cust_ID ORDER BY Order_Date), Order_Date) <= 10
GROUP BY Cust_ID, YEAR(Order_Date), MONTH(Order_Date), Order_Date
ORDER BY Cust_ID, Year, Month

SELECT Cust_ID, YEAR(Order_Date) AS OrderYear, Lead(Order_Date) OVER (PARTITION BY Cust_ID ORDER BY Order_Date) AS NextOrderDate, 
       DATEDIFF(MONTH, Order_Date, Lead(Order_Date) OVER (PARTITION BY Cust_ID ORDER BY Order_Date)) AS TimeGap,
       ROW_NUMBER() OVER (PARTITION BY Cust_ID ORDER BY Order_Date) AS RowNum
FROM e_commerce_data


-- 2. Calculate the month-wise retention rate.

SELECT Cust_ID, YEAR(Order_Date) AS Year, MONTH(Order_Date) AS Month, COUNT(Ord_ID) AS VisitCount, 
       DATEDIFF(MONTH, LAG(Order_Date) OVER (PARTITION BY Cust_ID ORDER BY Order_Date), Order_Date) AS TimeGap,
       CASE
           WHEN DATEDIFF(MONTH, LAG(Order_Date) OVER (PARTITION BY Cust_ID ORDER BY Order_Date), Order_Date) <= 1 THEN 'Regular'
           WHEN DATEDIFF(MONTH, LAG(Order_Date) OVER (PARTITION BY Cust_ID ORDER BY Order_Date), Order_Date) > 1 THEN 'Irregular'
       END AS CustomerSegment,
       1.0 * COUNT(Ord_ID) OVER (PARTITION BY YEAR(Order_Date), MONTH(Order_Date)) / COUNT(Ord_ID) OVER (PARTITION BY YEAR(Order_Date), MONTH(Order_Date) - 1) AS RetentionRate
FROM e_commerce_data
GROUP BY Cust_ID, YEAR(Order_Date), MONTH(Order_Date), Order_Date
HAVING DATEDIFF(MONTH, LAG(Order_Date) OVER (PARTITION BY Cust_ID ORDER BY Order_Date), Order_Date) <= 1
ORDER BY Cust_ID, Year, Month

