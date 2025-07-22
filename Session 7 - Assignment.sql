USE storedb;

--#1 Create a non-clustered index on the email column in the sales.customers table to improve search performance when looking up customers by email.
CREATE NONCLUSTERED INDEX ix_customers_email
ON sales.customers (email);

--#2 Create a composite index on the production.products table that includes category_id and brand_id columns to optimize searches that filter by both category and brand.
CREATE NONCLUSTERED INDEX ix_products_category_brand
ON production.products (category_id, brand_id);

--#3 Create an index on sales.orders table for the order_date column and include customer_id, store_id, and order_status as included columns to improve reporting queries.
CREATE NONCLUSTERED INDEX ix_orders_order_date_includes
ON sales.orders (order_date)
INCLUDE (customer_id, store_id, order_status);

--#4 Create a trigger that automatically inserts a welcome record into a customer_log table whenever a new customer is added to sales.customers. (First create the log table, then the trigger)
CREATE TRIGGER tr_customer_welcome
ON sales.customers
AFTER INSERT
AS
BEGIN
    INSERT INTO sales.customer_log (customer_id, action)
    SELECT I.customer_id, 'New Customer'
    FROM inserted I;
END;

--#5 Create a trigger on production.products that logs any changes to the list_price column into a price_history table, storing the old price, new price, and change date.
CREATE TRIGGER tr_product_price_change
ON production.products
AFTER UPDATE
AS
BEGIN
    IF UPDATE(list_price)
    BEGIN
        INSERT INTO production.price_history (product_id, old_price, new_price)
        SELECT I.product_id, D.list_price, I.list_price
        FROM inserted I, deleted D
        WHERE I.product_id = D.product_id
        AND I.list_price <> D.list_price;
    END
END;

--#6 Create an INSTEAD OF DELETE trigger on production.categories that prevents deletion of categories that have associated products. Display an appropriate error message.
CREATE TRIGGER tr_prevent_category_delete
ON production.categories
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM deleted D, production.products P
        WHERE D.category_id = P.category_id
    )
    BEGIN
        RAISERROR('Cannot delete category with associated products', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        DELETE FROM production.categories
        WHERE category_id IN (SELECT category_id FROM deleted);
    END
END;

--#7 Create a trigger on sales.order_items that automatically reduces the quantity in production.stocks when a new order item is inserted.
CREATE TRIGGER tr_update_inventory
ON sales.order_items
AFTER INSERT
AS
BEGIN
    UPDATE S
    SET S.quantity = S.quantity - I.quantity
    FROM production.stocks S, inserted I, sales.orders O
    WHERE I.product_id = S.product_id
    AND I.order_id = O.order_id
    AND S.store_id = O.store_id;
END;

--#8 Create a trigger that logs all new orders into an order_audit table, capturing order details and the date/time when the record was created.
CREATE TRIGGER tr_order_audit
ON sales.orders
AFTER INSERT
AS
BEGIN
    INSERT INTO sales.order_audit (order_id, customer_id, store_id, staff_id, order_date)
    SELECT I.order_id, I.customer_id, I.store_id, I.staff_id, I.order_date
    FROM inserted I;
END;
