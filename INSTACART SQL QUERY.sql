-- ============================================================
-- INSTACART RETAIL SALES ANALYSIS
-- PostgreSQL / pgAdmin 4
-- ============================================================
-- Purpose:
-- Analyze Instacart retail sales performance using key KPIs
-- and answer business questions related to revenue, products,
-- profitability, and customer purchasing behavior.
-- ============================================================


-- ============================================================
-- KEY PERFORMANCE INDICATORS (KPIs)
-- ============================================================

-- KPI 1: Total Orders
SELECT
    COUNT(DISTINCT order_id) AS total_orders
FROM orders;


-- KPI 2: Total Customers
SELECT
    COUNT(DISTINCT user_id) AS total_customers
FROM orders;


-- KPI 3: Total Revenue
SELECT
    SUM(o.quantity * p.unit_price) AS total_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id;


-- KPI 4: Average Order Value
SELECT
    SUM(o.quantity * p.unit_price) /
    COUNT(DISTINCT o.order_id) AS average_order_value
FROM orders o
JOIN products p
    ON o.product_id = p.product_id;


-- ============================================================
-- BUSINESS QUESTIONS
-- ============================================================


-- Business Question 1:
-- What are the top 5 departments by revenue?

SELECT
    d.department AS department_name,
    SUM(o.quantity * p.unit_price) AS total_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
JOIN departments d
    ON p.department_id = d.department_id
GROUP BY d.department
ORDER BY total_revenue DESC
LIMIT 5;


-- Business Question 2:
-- What are the top 3 products sold most during weekends?

SELECT
    p.product_name,
    SUM(o.quantity) AS total_sold
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
WHERE o.order_dow IN (0, 6)
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 3;


-- Business Question 3:
-- Does Bakery generate more profit than Alcohol?

SELECT
    d.department,
    SUM((p.unit_price - p.unit_cost) * o.quantity) AS total_profit
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
JOIN departments d
    ON p.department_id = d.department_id
WHERE d.department IN ('bakery', 'alcohol')
GROUP BY d.department
ORDER BY total_profit DESC;


-- Optional YES/NO Answer:
-- Is Bakery more profitable than Alcohol?

SELECT
    CASE
        WHEN
            SUM(
                CASE
                    WHEN d.department = 'bakery'
                    THEN (p.unit_price - p.unit_cost) * o.quantity
                    ELSE 0
                END
            )
            >
            SUM(
                CASE
                    WHEN d.department = 'alcohol'
                    THEN (p.unit_price - p.unit_cost) * o.quantity
                    ELSE 0
                END
            )
        THEN 'Yes'
        ELSE 'No'
    END AS bakery_more_profitable
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
JOIN departments d
    ON p.department_id = d.department_id;


-- Business Question 4:
-- Which products have not been sold at all?

SELECT
    p.product_id,
    p.product_name
FROM products p
LEFT JOIN orders o
    ON p.product_id = o.product_id
WHERE o.product_id IS NULL;
