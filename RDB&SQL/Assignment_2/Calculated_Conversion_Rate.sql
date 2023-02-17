

SELECT Adv_Type, COUNT(Action) AS 'Number of Actions', 
SUM(CASE WHEN Action = 'Order' THEN 1 ELSE 0 END)  AS 'Orders',
CAST((SUM(CASE WHEN Action = 'Order' THEN 1 ELSE 0 END) * 1.0) / 
    COUNT(Action) AS NUMERIC(10, 2)) AS 'Conversion_Rate'
FROM Actions
GROUP BY Adv_Type

