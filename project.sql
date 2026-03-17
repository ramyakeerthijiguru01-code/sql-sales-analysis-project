CREATE DATABASE SQLProject1;
USE SQLProject1;

-- Preview tables
SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM returns;

-- 1. Total sales summary
SELECT 
    COUNT(*) AS total_orders,
    SUM(amount) AS total_revenue,
    AVG(amount) AS avg_order_value,
    MIN(amount) AS min_order_value,
    MAX(amount) AS max_order_value
FROM orders;

-- 2. Monthly revenue
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(amount) AS monthly_revenue
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

-- 3. Revenue by country
SELECT 
    country,
    SUM(amount) AS total_revenue
FROM orders
GROUP BY country
ORDER BY total_revenue DESC;

-- 4. Top 5 customers by total spending
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(o.amount) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 5;

-- 5. Number of orders by each customer
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_orders DESC;

-- 6. Total returned orders
SELECT 
    COUNT(*) AS total_returned_orders
FROM returns;

-- 7. Returned order details
SELECT 
    o.order_id,
    o.customer_id,
    o.amount
FROM orders o
JOIN returns r
    ON o.order_id = r.order_id;

-- 8. Revenue lost due to returns
SELECT 
    SUM(o.amount) AS revenue_lost
FROM orders o
JOIN returns r
    ON o.order_id = r.order_id;

-- 9. Percentage of revenue lost due to returns
SELECT 
    (SUM(CASE 
            WHEN r.order_id IS NOT NULL THEN o.amount 
            ELSE 0 
         END) * 100.0 / SUM(o.amount)) AS loss_percentage
FROM orders o
LEFT JOIN returns r
    ON o.order_id = r.order_id;

-- 10. Return rate of orders
SELECT 
    COUNT(DISTINCT r.order_id) AS returned_orders,
    COUNT(DISTINCT o.order_id) AS total_orders,
    (COUNT(DISTINCT r.order_id) * 100.0 / COUNT(DISTINCT o.order_id)) AS return_rate
FROM orders o
LEFT JOIN returns r
    ON o.order_id = r.order_id;

-- 11. Net revenue after returns
SELECT 
    SUM(o.amount) AS gross_revenue,
    SUM(CASE 
            WHEN r.order_id IS NOT NULL THEN o.amount 
            ELSE 0 
        END) AS returned_revenue,
    SUM(CASE 
            WHEN r.order_id IS NULL THEN o.amount 
            ELSE 0 
        END) AS net_revenue
FROM orders o
LEFT JOIN returns r
    ON o.order_id = r.order_id;

-- 12. Monthly return trend
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    COUNT(r.order_id) AS total_returns
FROM orders o
JOIN returns r
    ON o.order_id = r.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;

-- 13. Monthly net revenue
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(o.amount) AS gross_revenue,
    SUM(CASE 
            WHEN r.order_id IS NOT NULL THEN o.amount 
            ELSE 0 
        END) AS returned_revenue,
    SUM(CASE 
            WHEN r.order_id IS NULL THEN o.amount 
            ELSE 0 
        END) AS net_revenue
FROM orders o
LEFT JOIN returns r
    ON o.order_id = r.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;

-- 14. Customers with highest number of returns
SELECT 
    o.customer_id,
    c.customer_name,
    COUNT(r.order_id) AS total_returns
FROM orders o
JOIN returns r
    ON o.order_id = r.order_id
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.customer_name
ORDER BY total_returns DESC;

-- 15. Country-wise returned revenue
SELECT 
    o.country,
    COUNT(r.order_id) AS total_returns,
    SUM(o.amount) AS returned_revenue
FROM orders o
JOIN returns r
    ON o.order_id = r.order_id
GROUP BY o.country
ORDER BY returned_revenue DESC;
