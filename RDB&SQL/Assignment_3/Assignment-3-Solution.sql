/*
Discount Effects
Generate a report including product IDs and discount effects on 
whether the increase in the discount rate positively impacts the number of orders for the products.
In this assignment, you are expected to generate a solution using SQL with a logical approach. 
POSITIVE, NEGATIVE, NEUTRAL
*/

-- First look at the data

SELECT *
FROM sale.order_item

SELECT *
FROM 
    sale.order_item OI
ORDER BY product_id, discount

SELECT 
    OI.product_id, SUM(OI.quantity) total_quantity, OI.discount
FROM 
    sale.order_item OI
GROUP BY product_id, list_price, discount
ORDER BY product_id, discount

-- First solution

;WITH sales_data AS (
    SELECT 
        OI.product_id, SUM(OI.quantity) total_sale, OI.discount
    FROM 
        sale.order_item OI
    GROUP BY product_id, discount
),
summary AS (
  SELECT 
    product_id,
    discount as x,
    total_sale as y,
    discount * total_sale as xy,
    discount * discount as x_squared
  FROM sales_data
),
summary_regression AS (
  SELECT 
    product_id,
    SUM(y) as sum_y, 
    SUM(x) as sum_x, 
    SUM(xy) sum_xy, 
    SUM(x_squared) as sum_x_squared, 
    COUNT(x) as n
  FROM summary
  GROUP BY product_id
)
,regression AS (
  SELECT 
    product_id,
    CASE
        WHEN (n*sum_x_squared - sum_x * sum_x) <> 0 THEN (n*sum_xy - sum_x * sum_y) / (n*sum_x_squared - sum_x * sum_x)
        ELSE NULL
    END as slope
  FROM summary_regression
)
--SELECT * FROM regression ORDER BY product_id
SELECT 
  product_id,
  CASE 
    WHEN slope > 0 THEN 'Positive'
    WHEN slope < 0 THEN 'Negative'
    ELSE 'Neutral'
  END as effect
FROM regression
ORDER BY product_id

-- Second Solution with average, if discount rate affect the quantity in an order

;WITH sales_data AS (
    SELECT 
        P.product_id, AVG(quantity * 1.0) total_sale, discount
    FROM 
        product.product P
        JOIN
        sale.order_item OI ON P.product_id = OI.product_id
    GROUP BY P.product_id, discount
    --ORDER BY product_id
),
summary AS (
  SELECT 
    product_id,
    discount as x,
    total_sale as y,
    discount * total_sale as xy,
    discount * discount as x_squared
  FROM sales_data
),
summary_regression AS (
  SELECT 
    product_id,
    SUM(y) as sum_y, 
    SUM(x) as sum_x, 
    SUM(xy) sum_xy, 
    SUM(x_squared) as sum_x_squared, 
    COUNT(x) as n
  FROM summary
  GROUP BY product_id
)
,regression AS (
  SELECT 
    product_id,
    CASE
        WHEN (n*sum_x_squared - sum_x * sum_x) <> 0 THEN (n*sum_xy - sum_x * sum_y) / (n*sum_x_squared - sum_x * sum_x)
        ELSE NULL
    END as slope
  FROM summary_regression
)
SELECT 
  product_id,
  CASE 
    WHEN slope > 0 THEN 'Positive'
    WHEN slope < 0 THEN 'Negative'
    ELSE 'Neutral'
  END as effect
FROM regression
ORDER BY product_id
