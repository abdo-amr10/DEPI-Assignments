use StoreDB
go
-------------List all products with list price greater than 1000-------------
SELECT*
FROM [production].[products] P
WHERE P.list_price > 1000
-------------Get customers from "CA" or "NY" states--------------------------
SELECT*
FROM [sales].[customers] C
WHERE C.state = 'CA' or C.state = 'NY'
-------------Retrieve all orders placed in 2023------------------------------
SELECT *
FROM [sales].[orders] O
WHERE O.order_date >= '2023-01-01' AND O.order_date <= '2023-12-31'
-------------Show customers whose emails end with @gmail.com-----------------
SELECT*
FROM [sales].[customers] C
WHERE C.email LIKE '%@gmail.com'
-------------Show all inactive staff-----------------------------------------
SELECT *
FROM [sales].[staffs] S
WHERE S.active = 0
-------------List top 5 most expensive products------------------------------
SELECT TOP 5*
FROM [production].[products] P
ORDER BY P.list_price DESC
-------------Show latest 10 orders sorted by date----------------------------
SELECT TOP 10 *
FROM [sales].[orders] O
ORDER BY O.order_date DESC
-------------Retrieve the first 3 customers alphabetically by last name------
SELECT TOP 3 *
FROM [sales].[customers] C
ORDER BY C.last_name
-------------Find customers who did not provide a phone number---------------
SELECT *
FROM [sales].[customers] C
WHERE C.phone IS NULL
-------------Show all staff who have a manager assigned----------------------
SELECT*
FROM [sales].[staffs] S
WHERE S.manager_id IS NOT NULL
-------------Count number of products in each category-----------------------
SELECT C.category_name, COUNT(*) AS 'number of products in each category'
FROM [production].[products] P , [production].[categories] C
WHERE P.category_id = C.category_id
GROUP BY C.category_name
-------------Count number of customers in each state-------------------------
SELECT C.state, COUNT(C.customer_id)
FROM [sales].[customers] C
WHERE C.state IS NOT NULL
GROUP BY C.state
-------------Get average list price of products per brand--------------------
SELECT B.brand_name, AVG(P.list_price)
FROM [production].[products] P , [production].[brands] B
WHERE P.brand_id = B.brand_id
GROUP BY B.brand_name
-------------Show number of orders per staff---------------------------------
SELECT S.first_name, S.last_name , COUNT(*) AS Order_Count
FROM [sales].[staffs] S , [sales].[orders] O
WHERE S.staff_id = O.staff_id
GROUP BY S.first_name, S.last_name
-------------Find customers who made more than 2 orders----------------------
SELECT C.customer_id , C.first_name , C.last_name , COUNT(*) AS Orders_Num
FROM [sales].[customers] C , [sales].[orders] O
WHERE C.customer_id = O.customer_id 
GROUP BY C.customer_id , C.first_name , C.last_name
HAVING COUNT(*) > 2;
-------------Products priced between 500 and 1500----------------------------
SELECT P.product_id, P.product_name ,P.list_price
FROM [production].[products] P
WHERE P.list_price BETWEEN 500 AND 1500
-------------Customers in cities starting with "S"---------------------------
SELECT*
FROM [sales].[customers] C
WHERE C.city LIKE 'S%'
-------------Orders with order_status either 2 or 4--------------------------
SELECT *
FROM [sales].[orders] O
WHERE O.order_status = 2 OR O.order_status =4
-------------Products from category_id IN (1, 2, 3)--------------------------
SELECT P.category_id , P.product_id , P.product_name
FROM [production].[products] P 
WHERE P.category_id IN (1, 2, 3)
-------------Staff working in store_id = 1 OR without phone number-----------
SELECT S.first_name , S.last_name , S.staff_id , S.store_id , S.phone 
FROM [sales].[staffs] S 
WHERE S.store_id = 1 OR S.phone IS NULL