#1. Calculate total orders, total revenue, and average order value after applying discounts, treating NULL discounts as 0%.
SELECT
    COUNT(*) AS total_orders,
    ROUND(SUM(o.quantity * p.price * (1 - IFNULL(o.discount_pct, 0) / 100)), 2) AS total_revenue,
    ROUND(AVG(o.quantity * p.price * (1 - IFNULL(o.discount_pct, 0) / 100)), 2) AS avg_order_value
FROM orders AS o
JOIN products AS p
ON o.product_id = p.product_id;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

#2. Compare total orders with the number of rated orders to identify orders with missing ratings.
SELECT
    COUNT(*) AS count_star,
    COUNT(rating) AS count_rating,
    COUNT(*) - COUNT(rating) AS difference
FROM orders;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

#4. Calculate city-wise order counts and return rates, filtering cities with return rates above 20%.
SELECT
    c.city,
    COUNT(*) AS total_orders,
    SUM(o.returned) AS returned_orders,
    ROUND(100.0 * SUM(o.returned) / COUNT(*), 1) AS return_rate_pct
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
GROUP BY c.city
HAVING return_rate_pct > 20
ORDER BY return_rate_pct DESC;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

#5. Rank customers by total spending and retrieve the top 5, then use LIMIT and OFFSET to fetch ranks 3–5 while ensuring consistent ordering for tied spending amounts.

##5a. Top 5 customers by total spend.(Rank the top 5 customers by total spending, using customer_id ASC to ensure consistent ordering when spending amounts are tied.)
SELECT
    c.customer_id,
    c.name,
    ROUND(SUM(o.quantity * p.price * (1 - IFNULL(o.discount_pct, 0) / 100)), 2) AS total_spend
FROM orders AS  o
JOIN products AS p
    ON o.product_id = p.product_id
JOIN customers AS c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spend DESC, c.customer_id ASC
LIMIT 5;

##5b. Get ranks 3–5 using LIMIT and OFFSET.(Retrieve ranks 3 to 5 from the customer spending ranking by skipping the first 2 records and returning the next 3.)
SELECT
    c.customer_id,
    c.name,
    ROUND(SUM(o.quantity * p.price * (1 - IFNULL(o.discount_pct, 0) / 100)), 2) AS total_spend
FROM orders AS o
JOIN products AS p
    ON o.product_id = p.product_id
JOIN customers AS c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spend DESC, c.customer_id ASC
LIMIT 3 OFFSET 2;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

#6. Calculate category-wise order count and revenue using three-table JOIN, and sort categories by revenue in descending order.
SELECT
    p.category,
    COUNT(*) AS order_count,
    ROUND(SUM(o.quantity * p.price * (1 - IFNULL(o.discount_pct, 0) / 100)), 2) AS category_revenue
FROM orders AS o
JOIN products AS p
    ON o.product_id = p.product_id
JOIN customers AS c
    ON o.customer_id = c.customer_id
GROUP BY p.category
ORDER BY category_revenue DESC;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

#7. Retrieve customers whose names start with the letter 'A' using the LIKE pattern matching operator.
SELECT customer_id, name
FROM customers
WHERE name LIKE 'A%';
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

#8. Retrieve all unique acquisition sources used by customers, excluding duplicate values.
SELECT DISTINCT acquisition_source
FROM customers;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

#9. Add a loyalty tier column, assign Gold or Silver based on city tier, verify customer counts by loyalty tier, and display all customer records to confirm the changes.

##9a. Add a new loyalty_tier column to the customers table.
ALTER TABLE customers
ADD COLUMN loyalty_tier VARCHAR(10);

##9b. Assign Gold to Tier 1 cities and Silver to all other city tiers for every customer.
UPDATE customers
SET loyalty_tier = CASE
    WHEN city_tier = 1 THEN 'Gold'
    ELSE 'Silver'
END;

##9c. Verify the number of customers in each loyalty tier.
SELECT
    loyalty_tier,
    COUNT(*) AS customer_count
FROM customers
GROUP BY loyalty_tier;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------




