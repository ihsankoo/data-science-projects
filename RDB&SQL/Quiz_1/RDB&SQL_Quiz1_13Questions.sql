--- 1. List all the cities in the Texas and the numbers of customers in each city.

SELECT
    sale.customer.city,
    COUNT(*) AS customer_count
FROM
    sale.customer
WHERE
    state = 'TX'
GROUP BY sale.customer.city




---- 2. List all the cities in the California which has more than 5 customer, by showing the cities which have more customers first

SELECT
    sale.customer.city,
    COUNT(*) AS customer_count 
FROM
    sale.customer
WHERE
    state = 'CA'
GROUP BY sale.customer.city
HAVING COUNT(*) > 5
ORDER BY customer_count DESC




---- 3. List the top 10 most expensive products

SELECT
    TOP 10
    product.product.product_name,
    product.product.list_price
FROM
    product.product
ORDER BY
    product.product.list_price DESC






---- 4. List store_id, product name and list price and the quantity of the products which are located in the store id 2 and the quantity is greater than 25

SELECT
    product.stock.store_id,
    product.product.product_name,
    product.product.list_price,
    product.stock.quantity
FROM
    product.product
        INNER JOIN product.stock
            ON product.product.product_id = product.stock.product_id
WHERE
    product.stock.store_id = 2
        AND product.stock.quantity > 25






---- 5. Find the sales order of the customers who lives in Boulder order by order date

SELECT
    sale.orders.customer_id,
    sale.orders.order_date
FROM
    sale.orders
WHERE
    sale.orders.customer_id IN (SELECT 
            sale.customer.customer_id
        FROM
            sale.customer
        WHERE
            sale.customer.city = 'Boulder')
ORDER BY sale.orders.order_date DESC







---- 6. Get the sales by staffs and years using the AVG() aggregate function

SELECT
    sale.orders.staff_id,
    YEAR(sale.orders.order_date) AS year,
    AVG(sale.order_item.list_price * sale.order_item.quantity * (1 - sale.order_item.discount)) AS avg_sales
FROM
    sale.orders,
    sale.order_item
WHERE
    sale.orders.order_id = sale.order_item.order_id
GROUP BY sale.orders.staff_id , YEAR(sale.orders.order_date)
 







---- 7. What is the sales quantity of product according to the brands and sort them highest-lowest?

SELECT
    product.brand.brand_name,
    SUM(sale.order_item.quantity) AS total_quantity
FROM
    sale.order_item, product.brand, product.product
WHERE
    sale.order_item.product_id = product.product.product_id
        AND product.product.brand_id = product.brand.brand_id
GROUP BY product.brand.brand_name
ORDER BY total_quantity DESC




---- 8. What are the categories that each brand has?

SELECT
    product.brand.brand_name,
    product.category.category_name
FROM
    product.product, product.brand, product.category
WHERE
    product.product.brand_id = product.brand.brand_id
        AND product.product.category_id = product.category.category_id
GROUP BY product.brand.brand_name, product.category.category_name





---- 9. Select the avg prices according to brands and categories

SELECT
    product.brand.brand_name,
    product.category.category_name,
    AVG(product.product.list_price) AS avg_price
FROM
    product.product, product.brand, product.category
WHERE
    product.product.brand_id = product.brand.brand_id
        AND product.product.category_id = product.category.category_id
GROUP BY product.brand.brand_name, product.category.category_name




---- 10. Select the annual amount of product produced according to brands----

SELECT
    product.product.brand_id,
    product.product.model_year AS year,
    COUNT(product.product.product_id) AS total_amount
FROM
    product.product
GROUP BY product.product.brand_id , product.product.model_year







---- 11. Select the store which has the most sales quantity in 2018.----

SELECT
    TOP 1
    sale.orders.store_id,
    SUM(sale.order_item.quantity) AS total_quantity
FROM
    sale.orders
        INNER JOIN sale.order_item
            ON sale.orders.order_id = sale.order_item.order_id
WHERE
    YEAR(sale.orders.order_date) = 2018
GROUP BY sale.orders.store_id 
ORDER BY total_quantity DESC




---- 12 Select the store which has the most sales amount in 2018.

SELECT
    TOP 1
    sale.orders.store_id,
    SUM(sale.order_item.quantity * product.product.list_price) AS total_amount
FROM
    sale.orders
        INNER JOIN sale.order_item
            ON sale.orders.order_id = sale.order_item.order_id
        INNER JOIN product.product
            ON sale.order_item.product_id = product.product.product_id
WHERE
    YEAR(sale.orders.order_date) = 2018
GROUP BY sale.orders.store_id
ORDER BY total_amount DESC




---- 13. Select the personnel which has the most sales amount in 2019

SELECT
    TOP 1
    sale.orders.staff_id,
    SUM(sale.order_item.quantity * product.product.list_price) AS total_amount
FROM
    sale.orders
        INNER JOIN sale.order_item
            ON sale.orders.order_id = sale.order_item.order_id
        INNER JOIN product.product
            ON sale.order_item.product_id = product.product.product_id
WHERE
    YEAR(sale.orders.order_date) = 2019
GROUP BY sale.orders.staff_id
ORDER BY total_amount DESC
