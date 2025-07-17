USE [StoreDB];
-- 1.Write a query that classifies all products into price categories:----------------

SELECT product_name, list_price, 
    CASE
        WHEN list_price < 300 THEN 'Economy'
        WHEN list_price BETWEEN 300 AND 999 THEN 'Standard'
        WHEN list_price BETWEEN 1000 AND 2499 THEN 'Premium'
        ELSE 'Luxury'
    END AS price_category
FROM production.products;

--2.Create a query that shows order processing information with user-friendly status descriptions and add a priority level based on order age.

SELECT o.order_id, o.order_date,
    CASE 
        WHEN o.order_status = 1 THEN 'Order Received'
        WHEN o.order_status = 2 THEN 'In Preparation'
        WHEN o.order_status = 3 THEN 'Order Cancelled'
        WHEN o.order_status = 4 THEN 'Order Delivered'
    END AS status_description,
    CASE
        WHEN o.order_status = 1 AND DATEDIFF(DAY, o.order_date, GETDATE()) > 5 THEN 'URGENT'
        WHEN o.order_status = 2 AND DATEDIFF(DAY, o.order_date, GETDATE()) > 3 THEN 'HIGH'
        ELSE 'NORMAL'
    END AS priority_level
FROM sales.orders o;

--3.Categorize staff based on the number of orders they have handled: 0 orders = New Staff, 1-10 = Junior Staff, 11-25 = Senior Staff, 26+ = Expert Staff

SELECT s.first_name, s.last_name, COUNT(o.order_id) AS number_of_orders,
    CASE 
        WHEN COUNT(o.order_id) = 0 THEN 'New Staff'
        WHEN COUNT(o.order_id) BETWEEN 1 AND 10 THEN 'Junior Staff'
        WHEN COUNT(o.order_id) BETWEEN 11 AND 25 THEN 'Senior Staff'
        ELSE 'Expert Staff'
    END AS staff_level
FROM sales.staffs s, sales.orders o
WHERE s.staff_id = o.staff_id
GROUP BY s.first_name, s.last_name;

------------------------------------------------------------
--4.Handle missing customer contact information Use ISNULL for phone and COALESCE for preferred contact method.

SELECT customer_id, first_name, last_name, email,
    ISNULL(phone, 'Phone Not Available') AS contact_phone,
    COALESCE(phone, email, 'No Contact Method') AS preferred_contact,
    street, city, state, zip_code
FROM sales.customers;

--5.Calculate price per unit safely and include stock status. Only show products from store_id = 1.

SELECT p.product_name, p.list_price,
    ISNULL(s.quantity, 0) AS stock_quantity,
    CASE 
        WHEN ISNULL(s.quantity, 0) = 0 THEN 'Out of Stock'
        WHEN ISNULL(s.quantity, 0) BETWEEN 1 AND 10 THEN 'Low Stock'
        WHEN ISNULL(s.quantity, 0) BETWEEN 11 AND 50 THEN 'In Stock'
        ELSE 'High Stock'
    END AS stock_status,
    CASE 
        WHEN ISNULL(s.quantity, 0) = 0 THEN 0
        ELSE p.list_price / NULLIF(s.quantity, 0)
    END AS price_per_unit
FROM production.products p, production.stocks s
WHERE p.product_id = s.product_id
AND s.store_id = 1;
--6.Create a query that formats complete addresses safely Use COALESCE for each address component and create formatted_address.

SELECT first_name, last_name,
    COALESCE(street, '') AS street,
    COALESCE(city, '') AS city,
    COALESCE(state, '') AS state,
    COALESCE(zip_code, '') AS zip_code,
    CASE 
        WHEN street IS NULL AND city IS NULL AND state IS NULL AND zip_code IS NULL THEN 'Address Not Available'
        ELSE
            CASE WHEN street IS NOT NULL THEN street + ', ' ELSE '' END +
            CASE WHEN city IS NOT NULL THEN city + ', ' ELSE '' END +
            CASE WHEN state IS NOT NULL THEN state + ' ' ELSE '' END +
            CASE WHEN zip_code IS NOT NULL THEN zip_code ELSE '' END
    END AS formatted_address
FROM sales.customers;

------------------------------------------------------------
--7.Use a CTE to find customers who have spent more than $1500 total Show customer details and spending, order by total_spent DESC.

WITH customer_total AS (
    SELECT c.customer_id, c.first_name + ' ' + c.last_name AS customer_name,
           SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spent
    FROM sales.customers c, sales.orders o, sales.order_items oi
    WHERE c.customer_id = o.customer_id
    AND o.order_id = oi.order_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT customer_id, customer_name, total_spent
FROM customer_total
WHERE total_spent > 1500
ORDER BY total_spent DESC;

--8.Create a multi-CTE query for category analysis

WITH category_revenue AS (
    SELECT c.category_id, c.category_name,
           SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
    FROM production.categories c, production.products p, sales.order_items oi
    WHERE c.category_id = p.category_id
    AND p.product_id = oi.product_id
    GROUP BY c.category_id, c.category_name
),
category_avg_order AS (
    SELECT c.category_id,
           AVG(oi.quantity * oi.list_price * (1 - oi.discount)) AS avg_order_value
    FROM production.categories c, production.products p, sales.order_items oi
    WHERE c.category_id = p.category_id
    AND p.product_id = oi.product_id
    GROUP BY c.category_id
)
SELECT cr.category_id, cr.category_name, cr.total_revenue, ca.avg_order_value,
    CASE 
        WHEN cr.total_revenue > 50000 THEN 'Excellent'
        WHEN cr.total_revenue > 20000 THEN 'Good'
        ELSE 'Needs Improvement'
    END AS performance
FROM category_revenue cr, category_avg_order ca
WHERE cr.category_id = ca.category_id
ORDER BY cr.total_revenue DESC;

--9.Use CTEs to analyze monthly sales trends Calculate monthly totals and add previous month comparison with growth %.

WITH monthly_sales AS (
    SELECT YEAR(order_date) AS year, MONTH(order_date) AS month,
           SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS monthly_total
    FROM sales.orders o, sales.order_items oi
    WHERE o.order_id = oi.order_id
    GROUP BY YEAR(order_date), MONTH(order_date)
),
sales_comparison AS (
    SELECT year, month, monthly_total,
           LAG(monthly_total, 1) OVER (ORDER BY year, month) AS prev_month_total
    FROM monthly_sales
)
SELECT year, month, monthly_total, prev_month_total,
    CASE 
        WHEN prev_month_total IS NULL THEN NULL
        ELSE ROUND(((monthly_total - prev_month_total) / prev_month_total * 100), 2)
    END AS growth_percent
FROM sales_comparison
ORDER BY year, month;

--10.Create a query that ranks products within each category Use ROW_NUMBER(), RANK(), and DENSE_RANK() and show top 3 per category.

WITH ranked_products AS (
    SELECT p.product_id, p.product_name, c.category_name, p.list_price,
           ROW_NUMBER() OVER (PARTITION BY p.category_id ORDER BY p.list_price DESC) AS row_num,
           RANK() OVER (PARTITION BY p.category_id ORDER BY p.list_price DESC) AS price_rank,
           DENSE_RANK() OVER (PARTITION BY p.category_id ORDER BY p.list_price DESC) AS dense_price_rank
    FROM production.products p, production.categories c
    WHERE p.category_id = c.category_id
)
SELECT product_id, product_name, category_name, list_price, price_rank, dense_price_rank
FROM ranked_products
WHERE row_num <= 3
ORDER BY category_name, price_rank;
--11.Rank customers by their total spending Calculate total spending, use RANK() and NTILE(5) for spending groups and tiers.

WITH customer_spending AS (
    SELECT c.customer_id, c.first_name + ' ' + c.last_name AS customer_name,
           SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spent,
           RANK() OVER (ORDER BY SUM(oi.quantity * oi.list_price * (1 - oi.discount)) DESC) AS spending_rank,
           NTILE(5) OVER (ORDER BY SUM(oi.quantity * oi.list_price * (1 - oi.discount)) DESC) AS spending_group
    FROM sales.customers c, sales.orders o, sales.order_items oi
    WHERE c.customer_id = o.customer_id
    AND o.order_id = oi.order_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT customer_id, customer_name, total_spent, spending_rank,
    CASE 
        WHEN spending_group = 1 THEN 'VIP'
        WHEN spending_group = 2 THEN 'Gold'
        WHEN spending_group = 3 THEN 'Silver'
        WHEN spending_group = 4 THEN 'Bronze'
        ELSE 'Standard'
    END AS customer_tier
FROM customer_spending
ORDER BY spending_rank;

------------------------------------------------------------
--12.Create a comprehensive store performance ranking Rank by revenue and orders, use PERCENT_RANK() and performance levels.

WITH store_performance AS (
    SELECT s.store_id, s.store_name,
           SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue,
           COUNT(DISTINCT o.order_id) AS order_count,
           RANK() OVER (ORDER BY SUM(oi.quantity * oi.list_price * (1 - oi.discount)) DESC) AS revenue_rank,
           RANK() OVER (ORDER BY COUNT(DISTINCT o.order_id) DESC) AS order_rank,
           PERCENT_RANK() OVER (ORDER BY SUM(oi.quantity * oi.list_price * (1 - oi.discount))) AS revenue_percentile
    FROM sales.stores s, sales.orders o, sales.order_items oi
    WHERE s.store_id = o.store_id
    AND o.order_id = oi.order_id
    GROUP BY s.store_id, s.store_name
)
SELECT store_id, store_name, total_revenue, order_count, revenue_rank, order_rank,
       ROUND(revenue_percentile * 100, 2) AS revenue_percentile,
       CASE 
           WHEN revenue_percentile >= 0.8 THEN 'Top Performance'
           WHEN revenue_percentile >= 0.6 THEN 'Above Average'
           WHEN revenue_percentile >= 0.4 THEN 'Average'
           WHEN revenue_percentile >= 0.2 THEN 'Below Average'
           ELSE 'Needs Improvement'
       END AS performance_level
FROM store_performance
ORDER BY revenue_rank;

------------------------------------------------------------
--13.Create a PIVOT table showing product counts by category and brand Rows: Categories | Columns: Top 4 brands | Values: Count of products.

SELECT *
FROM (
    SELECT c.category_name, b.brand_name, p.product_id
    FROM production.products p, production.categories c, production.brands b
    WHERE p.category_id = c.category_id
    AND p.brand_id = b.brand_id
) AS source_table
PIVOT (
    COUNT(product_id)
    FOR brand_name IN ([Electra], [Haro], [Trek], [Surly])
) AS pivot_table
ORDER BY category_name;

------------------------------------------------------------
--14.Create a PIVOT showing monthly sales revenue by store Rows: Store names | Columns: Months | Values: Total revenue.

SELECT *
FROM (
    SELECT s.store_name, FORMAT(o.order_date, 'MMM') AS month,
           oi.quantity * oi.list_price * (1 - oi.discount) AS revenue
    FROM sales.orders o, sales.order_items oi, sales.stores s
    WHERE o.order_id = oi.order_id
    AND o.store_id = s.store_id
) AS source_table
PIVOT (
    SUM(revenue)
    FOR month IN ([Jan], [Feb], [Mar], [Apr], [May], [Jun], 
                  [Jul], [Aug], [Sep], [Oct], [Nov], [Dec])
) AS pivot_table
ORDER BY store_name;

------------------------------------------------------------
--15.PIVOT order statuses across stores Rows: Store names | Columns: Order statuses | Values: Count of orders.

SELECT *
FROM (
    SELECT s.store_name,
           CASE o.order_status
               WHEN 1 THEN 'Pending'
               WHEN 2 THEN 'Processing'
               WHEN 3 THEN 'Completed'
               WHEN 4 THEN 'Rejected'
           END AS status,
           o.order_id
    FROM sales.orders o, sales.stores s
    WHERE o.store_id = s.store_id
) AS source_table
PIVOT (
    COUNT(order_id)
    FOR status IN ([Pending], [Processing], [Completed], [Rejected])
) AS pivot_table;

--16.Create a PIVOT comparing sales across years----------------------

SELECT brand_name,
       [2016], [2017], [2018],
       ROUND(([2017] - [2016]) / NULLIF([2016], 0) * 100, 2) AS growth_2016_2017,
       ROUND(([2018] - [2017]) / NULLIF([2017], 0) * 100, 2) AS growth_2017_2018
FROM (
    SELECT b.brand_name, YEAR(o.order_date) AS year,
           oi.quantity * oi.list_price * (1 - oi.discount) AS revenue
    FROM sales.order_items oi, sales.orders o, production.products p, production.brands b
    WHERE oi.order_id = o.order_id
    AND oi.product_id = p.product_id
    AND p.brand_id = b.brand_id
    AND YEAR(o.order_date) BETWEEN 2016 AND 2018
) AS source_table
PIVOT (
    SUM(revenue)
    FOR year IN ([2016], [2017], [2018])
) AS pivot_table;

--17.Use UNION to combine different product availability statuse In-stock, Out-of-stock, Discontinued.

SELECT p.product_id, p.product_name, 'In Stock' AS status
FROM production.products p, production.stocks s
WHERE p.product_id = s.product_id
AND s.quantity > 0

UNION

SELECT p.product_id, p.product_name, 'Out of Stock' AS status
FROM production.products p, production.stocks s
WHERE p.product_id = s.product_id
AND (s.quantity = 0 OR s.quantity IS NULL)

UNION

SELECT p.product_id, p.product_name, 'Discontinued' AS status
FROM production.products p
WHERE NOT EXISTS (
    SELECT 1 FROM production.stocks s WHERE s.product_id = p.product_id
);

--18.Use INTERSECT to find loyal customers Customers who bought in both 2017 AND 2018.

SELECT c.customer_id, c.first_name, c.last_name
FROM sales.customers c
WHERE EXISTS (
    SELECT 1 FROM sales.orders o
    WHERE o.customer_id = c.customer_id
    AND YEAR(o.order_date) = 2017
)
INTERSECT
SELECT c.customer_id, c.first_name, c.last_name
FROM sales.customers c
WHERE EXISTS (
    SELECT 1 FROM sales.orders o
    WHERE o.customer_id = c.customer_id
    AND YEAR(o.order_date) = 2018
);

--19.Use multiple set operators to analyze product distribution----------------------

SELECT p.product_id, p.product_name, 'In All Stores' AS availability
FROM production.products p
WHERE EXISTS (SELECT 1 FROM production.stocks WHERE product_id = p.product_id AND store_id = 1)
AND EXISTS (SELECT 1 FROM production.stocks WHERE product_id = p.product_id AND store_id = 2)
AND EXISTS (SELECT 1 FROM production.stocks WHERE product_id = p.product_id AND store_id = 3)
UNION
SELECT p.product_id, p.product_name, 'Only in Store 1' AS availability
FROM production.products p
WHERE EXISTS (SELECT 1 FROM production.stocks WHERE product_id = p.product_id AND store_id = 1)
AND NOT EXISTS (SELECT 1 FROM production.stocks WHERE product_id = p.product_id AND store_id = 2);

------------------------------------------------------------
--20.Complex set operations for customer retention Find Lost, New, and Retained customers between 2016 and 2017.

SELECT c.customer_id, c.first_name, c.last_name, 'Lost' AS status
FROM sales.customers c
WHERE EXISTS (
    SELECT 1 FROM sales.orders o
    WHERE o.customer_id = c.customer_id AND YEAR(o.order_date) = 2016
)
AND NOT EXISTS (
    SELECT 1 FROM sales.orders o
    WHERE o.customer_id = c.customer_id AND YEAR(o.order_date) = 2017
)
UNION ALL
SELECT c.customer_id, c.first_name, c.last_name, 'New' AS status
FROM sales.customers c
WHERE EXISTS (
    SELECT 1 FROM sales.orders o
    WHERE o.customer_id = c.customer_id AND YEAR(o.order_date) = 2017
)
AND NOT EXISTS (
    SELECT 1 FROM sales.orders o
    WHERE o.customer_id = c.customer_id AND YEAR(o.order_date) = 2016
)

UNION ALL
SELECT c.customer_id, c.first_name, c.last_name, 'Retained' AS status
FROM sales.customers c
WHERE EXISTS (
    SELECT 1 FROM sales.orders o
    WHERE o.customer_id = c.customer_id AND YEAR(o.order_date) = 2016
)
AND EXISTS (
    SELECT 1 FROM sales.orders o
    WHERE o.customer_id = c.customer_id AND YEAR(o.order_date) = 2017
);
