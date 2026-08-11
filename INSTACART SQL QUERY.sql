--INSTACART RETAIL DASHBOARD 
--KPIs:
--▪Total Orders
SELECT COUNT(DISTINCT order_id) AS total_order
FROM orders;


--▪Total Customers
SELECT COUNT(DISTINCT user_id) AS total_customers
FROM orders;

--▪Total Revenue
SELECT SUM(orders.quantity*products.unit_price) AS total_revenue
FROM orders
JOIN products
ON orders.product_id=products.product_id;


--▪Average Order Value
SELECT SUM(orders.quantity * products.unit_price),
COUNT (DISTINCT orders.order_id) AS average_order_value
FROM orders
JOIN products
ON orders.product_id=products.product_id;

--What are the top 5 departments by revenue.
SELECT departments.department AS department_name,
		SUM(orders.quantity * products.unit_price) AS total_revenue
FROM orders
JOIN products
	ON orders.product_id=products.product_id
JOIN departments
	ON products.department_id=departments.department_id
GROUP BY departments.department
ORDER BY total_revenue DESC
LIMIT 5;


--What are the top 3 products we sold most during the weekends?
SELECT products.product_name,
	SUM(orders.quantity)AS total_sold
FROM orders
JOIN products
	ON orders.product_id=products.product_id
WHERE orders.order_dow IN(0,6)
GROUP BY products.product_name
ORDER BY total_sold DESC
LIMIT 3;


--Does bread generate more profits than alcoholic produtcs?
SELECT
    departments.department,
    SUM((products.unit_price - products.unit_cost) * orders.quantity) AS total_profit
FROM orders 
JOIN products 
    ON orders.product_id = products.product_id
JOIN departments
    ON products.department_id = departments.department_id
WHERE departments.department IN ('bakery', 'alcohol')
GROUP BY departments.department
ORDER BY total_profit DESC;
--No bread in the data only bakery

--YES/NO ANSWER
SELECT
    CASE
        WHEN SUM(CASE WHEN departments.department = 'bakery'
             THEN (products.unit_price - products.unit_cost) * orders.quantity ELSE 0 END)
           >
             SUM(CASE WHEN departments.department = 'alcohol'
             THEN (products.unit_price - products.unit_cost) * orders.quantity ELSE 0 END)
        THEN 'Yes'
        ELSE 'No'
    END AS bakery_more_profitable
FROM orders 
JOIN products 
    ON orders.product_id = products.product_id
JOIN departments 
    ON products.department_id = departments.department_id;


--Which products have not been sold at all?
SELECT products.product_id,products.product_name
FROM products
LEFT JOIN orders
ON products.product_id=orders.product_id
WHERE orders.product_id IS NULL;


SELECT products.product_name,order_id
FROM products
LEFT JOIN orders
ON products.product_id=orders.product_id
WHERE orders.order_id IS NULL;























