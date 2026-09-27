USE ECOMMERCE_ANALYTICS;
-- =========================================================
-- PROJECT: E-Commerce Sales & Customer Analytics
-- PHASE 1: Basic Data Analysis
-- =========================================================

-- Question 1:
-- How many customers are registered on the e-commerce platform?
SELECT COUNT(*) AS TOTAL_CUSTOMERS FROM CUSTOMERS;

-- Question 2:
-- How many orders have been placed on the e-commerce platform?
SELECT COUNT(*) AS TOTAL_ORDERS FROM ORDERS;

-- Question 3:
-- What is the total revenue generated from completed orders?
SELECT SUM(p.amount) AS total_revenue
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
WHERE o.order_status = 'Completed';

-- Question 4:
-- How many orders were successfully completed?
SELECT COUNT(*) AS SUCCESSFUL_ORDERS FROM ORDERS WHERE ORDER_STATUS='COMPLETED';

-- Question 5:
-- How many orders were cancelled?
SELECT COUNT(*) AS CANCELLED_ORDERS FROM ORDERS WHERE ORDER_STATUS='CANCELLED';

-- Question 6:
-- How many orders are currently pending?
SELECT COUNT(*) AS PENDING_ORDERS FROM ORDERS WHERE ORDER_STATUS='PENDING';

-- Question 7:
-- How many orders are there for each order status?
SELECT ORDER_STATUS ,COUNT(*) AS NO_OF_ORDERS FROM ORDERS GROUP BY ORDER_STATUS;

-- Question 8:
-- What is the average value of a completed order?
SELECT AVG(P.AMOUNT) AS AVERAGE_ORDER_VALUE
FROM ORDERS O
JOIN PAYMENTS P
    ON O.ORDER_ID = P.ORDER_ID
WHERE O.ORDER_STATUS = 'Completed';

