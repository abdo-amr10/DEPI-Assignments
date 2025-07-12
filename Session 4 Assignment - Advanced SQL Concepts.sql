USE StoreDB
-----------------1. Count the total number of products in the database.------------------
SELECT COUNT(P.product_id) AS 'total number of product'
FROM [production].[products] P
-----------------2. Find the average, minimum, and maximum price of all products.--------
SELECT AVG(P.list_price) AS 'AVG' , MIN(P.list_price) AS 'MIN'  , MAX(P.list_price) AS 'MAX'
FROM [production].[products] P
-----------------3. Count how many products are in each category.------------------------
SELECT P.product_name , C.category_name, COUNT(P.product_id) AS 'COUNT OF PRODUCTS'
FROM [production].[products] P , [production].[categories] C
WHERE P.category_id = C.category_id
GROUP BY C.category_name , P.product_name
-----------------4. Find the total number of orders for each store.----------------------
SELECT O.order_id , S.store_name , COUNT(O.order_id) AS'number of orders'
FROM [sales].[orders] O , [sales].[stores] S
WHERE O.store_id = S.store_id
GROUP BY O.order_id , S.store_name 
-----------------5. Show customer first names in UPPERCASE and last names in lowercase for the first 10 customers.--------
SELECT TOP 10 UPPER(C.first_name) AS 'FNAME' , LOWER(C.last_name) AS 'LNAME' 
FROM [sales].[customers] C 
ORDER BY C.customer_id ASC
-----------------6. Get the length of each product name. Show product name and its length for the first 10 products.------
SELECT TOP 10 LEN(P.product_name) AS 'LENGTH OF PNAME' , P.product_name 
FROM [production].[products] P 
ORDER BY P.product_id ASC
-----------------7. Format customer phone numbers to show only the area code (first 3 digits) for customers 1-15.---------
SELECT TOP 15 LEFT(C.phone , 3) AS 'customer phone numbers'
FROM [sales].[customers] C
ORDER BY C.customer_id
-----------------8. Show the current date and extract the year and month from order dates for orders 1-10.----------------
SELECT TOP 10 GETDATE() AS 'DATE NOW' , YEAR(O.order_date) AS 'YEAR' , MONTH(O.order_date) AS 'MONTH'
FROM [sales].[orders] O 
ORDER BY O.order_id
-----------------9. Join products with their categories. Show product name and category name for first 10 products.-------
SELECT TOP 10 P.product_name , C.category_name
FROM [production].[products] P , [production].[categories] C
WHERE P.category_id = C.category_id
ORDER BY P.product_id
-----------------10. Join customers with their orders. Show customer name and order date for first 10 orders.-------------
SELECT TOP 10 CONCAT_WS(' ' , C.first_name , C.last_name) AS 'FULL NAME' ,  O.order_date
FROM [sales].[customers] C , [sales].[orders] O
WHERE C.customer_id = O.customer_id
ORDER BY O.order_id
-----------------11. Show all products with their brand names, even if some products don't have brands. Include product name, brand name (show 'No Brand' if null).----
SELECT P.product_name , COALESCE(B.brand_name , 'No Brand' ) 
FROM [production].[products] P , [production].[brands] B 
WHERE P.brand_id  = B.brand_id
-----------------12. Find products that cost more than the average product price. Show product name and price.---------------------------------------------------------
SELECT  P.product_name , P.list_price 
FROM [production].[products] P
WHERE P.list_price > (SELECT AVG(PP.list_price) FROM [production].[products] PP)
-----------------13. Find customers who have placed at least one order. Use a subquery with IN. Show customer_id and customer_name.------------------------------------
SELECT CONCAT_WS(' ' , C.first_name , C.last_name) AS 'FULL NAME' , C.customer_id
FROM [sales].[customers] C
WHERE customer_id IN ( SELECT customer_id FROM sales.orders )
-----------------14. For each customer, show their name and total number of orders using a subquery in the SELECT clause.
SELECT CONCAT_WS(' ', C.first_name , C.last_name ) AS 'FULL NAME' , 
(SELECT COUNT(O.order_id) FROM [sales].[orders] O) AS 'COUNT OF ORDERS'
FROM [sales].[customers] C 
-----------------15. Create a simple view called easy_product_list that shows product name, category name, and price. Then write a query to select all products from this view where price > 100.
GO
CREATE VIEW easy_product_list AS
SELECT P.product_name , C.category_name , P.list_price
FROM [production].[products] P , [production].[categories] C
WHERE P.category_id = C.category_id
GO
SELECT * FROM easy_product_list WHERE list_price>100
-----------------16. Create a view called customer_info that shows customer ID, full name (first + last), email, and city and state combined. Then use this view to find all customers from California (CA).
GO
CREATE VIEW Customer_Information AS
SELECT C.customer_id ,  C.first_name +' '+ C.last_name , C.email , C.city , C.state
FROM [sales].[customers] C
go

SELECT *
FROM Customer_Information
WHERE state ='CA'
-----------------17. Find all products that cost between $50 and $200. Show product name and price, ordered by price from lowest to highest.
SELECT P.product_name , P.list_price
FROM [production].[products] P 
WHERE P.list_price BETWEEN 50 AND 200
ORDER BY P.list_price
-----------------18. Count how many customers live in each state. Show state and customer count, ordered by count from highest to lowest.
SELECT C.state , COUNT(C.customer_id) 'COUNT'
FROM [sales].[customers] C
GROUP BY C.state
ORDER BY COUNT(C.customer_id) DESC
-----------------19. Find the most expensive product in each category. Show category name, product name, and price.
SELECT  C.category_name , P.product_name , P.list_price
FROM [production].[products] P  , [production].[categories] C
WHERE P.category_id = C.category_id AND P.list_price = (SELECT MAX(PP.list_price) FROM production.products PP WHERE PP.category_id = P.category_id)
-----------------20. Show all stores and their cities, including the total number of orders from each store. Show store name, city, and order count.
SELECT S.store_name , S.city , COUNT(O.order_id)
FROM [sales].[stores] S , [sales].[orders] O
WHERE S.store_id = O.store_id
GROUP BY S.store_name , S.city 