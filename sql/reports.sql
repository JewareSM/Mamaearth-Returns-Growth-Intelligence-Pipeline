#1. Calculate total orders, total revenue, and average order value after applying discounts, treating NULL discounts as 0%.
SELECT
    COUNT(*) AS total_orders,
    ROUND(SUM(o.quantity * p.price * (1 - IFNULL(o.discount_pct, 0) / 100)), 2) AS total_revenue,
    ROUND(AVG(o.quantity * p.price * (1 - IFNULL(o.discount_pct, 0) / 100)), 2) AS avg_order_value
FROM orders AS o
JOIN products AS p
ON o.product_id = p.product_id;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

#2. Compare total orders with the number of rated orders to identify orders with missing ratings.
SELECT
    COUNT(*) AS count_star,
    COUNT(rating) AS count_rating,
    COUNT(*) - COUNT(rating) AS difference
FROM orders;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

#3. Identify customers who have not placed any orders (zero orders).

##3a. Find customers who have not placed any orders using LEFT JOIN.
SELECT c.customer_id, c.name
FROM customers AS c
LEFT JOIN orders AS o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) = 0;

##3b. Find customers who have not placed any orders using NOT IN.
SELECT customer_id, name
FROM customers
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id
    FROM orders
);
-------------------------------------------------------------------------------------------------------------------------------------------------------------------






