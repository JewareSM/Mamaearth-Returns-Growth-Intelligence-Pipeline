##1 -- Calculate total orders, total revenue, and average order value after applying discounts, treating NULL discounts as 0%.
SELECT
    COUNT(*) AS total_orders,
    ROUND(SUM(o.quantity * p.price * (1 - IFNULL(o.discount_pct, 0) / 100)), 2) AS total_revenue,
    ROUND(AVG(o.quantity * p.price * (1 - IFNULL(o.discount_pct, 0) / 100)), 2) AS avg_order_value
FROM orders AS o
JOIN products AS p
ON o.product_id = p.product_id;


