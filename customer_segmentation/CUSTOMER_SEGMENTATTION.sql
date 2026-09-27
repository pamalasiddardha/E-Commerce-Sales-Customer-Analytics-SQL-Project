-- QUESTION 36:
-- SEGMENT CUSTOMERS INTO HIGH, MEDIUM, AND LOW VALUE
-- BASED ON THEIR TOTAL SPENDING FROM COMPLETED ORDERS.
-- TOTAL SPENDING >= 50,000  → HIGH VALUE
-- TOTAL SPENDING >= 20,000  → MEDIUM VALUE
-- TOTAL SPENDING < 20,000   → LOW VALUE

select c.customer_id,c.customer_name,sum(p.amount) as total_spending,
case
when sum(p.amount)>=50000 then "High Value"
when sum(p.amount)>=20000 then "Medium Value"
else "Low Value"
end as segment
from customers c join orders o
on c.customer_id=o.customer_id
join payments p
on o.order_id=p.order_id
where o.order_status='Completed'
group by c.customer_id,c.customer_name
order by customer_id;


-- QUESTION 37:
-- SEGMENT CUSTOMERS BASED ON THE NUMBER OF COMPLETED ORDERS.
-- 5 or more completed orders  → HIGH ACTIVITY
-- 3–4 completed orders        → MEDIUM ACTIVITY
-- 1–2 completed orders        → LOW ACTIVITY
select c.customer_id,c.customer_name,count(*)  as completed_orders,
case
when count(*)>=5 then "High Activity"
when count(*) in (3,4) then "Medium Activity"
else "Low Activity"
end as activity_segment
from customers c join orders o
on c.customer_id=o.customer_id
where o.order_status='Completed'
group by c.customer_id,c.customer_name
order by customer_id;

-- QUESTION 38:
-- SEGMENT CUSTOMERS BASED ON BOTH THEIR TOTAL SPENDING
-- AND NUMBER OF COMPLETED ORDERS.
-- HIGH VALUE + HIGH ACTIVITY
-- → VIP CUSTOMER

-- HIGH VALUE + NOT HIGH ACTIVITY
-- → HIGH VALUE CUSTOMER

-- NOT HIGH VALUE + HIGH ACTIVITY
-- → FREQUENT CUSTOMER

-- OTHERWISE
-- → REGULAR CUSTOMER

-- QUESTION 38:
-- SEGMENT CUSTOMERS BASED ON BOTH THEIR TOTAL SPENDING
-- AND NUMBER OF COMPLETED ORDERS.
SELECT 
    CUSTOMER_ID,
    CUSTOMER_NAME,
    TOTAL_SPENDING,
    COMPLETED_ORDERS,
    VALUE_SEGMENT,
    ACTIVITY_SEGMENT,
    CASE
        WHEN VALUE_SEGMENT = 'HIGH VALUE'
             AND ACTIVITY_SEGMENT = 'HIGH ACTIVITY'
            THEN 'VIP CUSTOMER'

        WHEN VALUE_SEGMENT = 'HIGH VALUE'
             AND ACTIVITY_SEGMENT = 'NOT HIGH ACTIVITY'
            THEN 'HIGH VALUE CUSTOMER'

        WHEN VALUE_SEGMENT = 'NOT HIGH VALUE'
             AND ACTIVITY_SEGMENT = 'HIGH ACTIVITY'
            THEN 'FREQUENT CUSTOMER'

        ELSE 'REGULAR CUSTOMER'
    END AS CUSTOMER_SEGMENT

FROM
(
    SELECT 
        C.CUSTOMER_ID,
        C.CUSTOMER_NAME,
        SUM(P.AMOUNT) AS TOTAL_SPENDING,
        COUNT(O.ORDER_ID) AS COMPLETED_ORDERS,

        CASE
            WHEN SUM(P.AMOUNT) >= 50000
                THEN 'HIGH VALUE'
            ELSE 'NOT HIGH VALUE'
        END AS VALUE_SEGMENT,

        CASE
            WHEN COUNT(O.ORDER_ID) >= 5
                THEN 'HIGH ACTIVITY'
            ELSE 'NOT HIGH ACTIVITY'
        END AS ACTIVITY_SEGMENT

    FROM CUSTOMERS C

    JOIN ORDERS O
        ON C.CUSTOMER_ID = O.CUSTOMER_ID

    JOIN PAYMENTS P
        ON O.ORDER_ID = P.ORDER_ID

    WHERE O.ORDER_STATUS = 'COMPLETED'

    GROUP BY 
        C.CUSTOMER_ID,
        C.CUSTOMER_NAME
) AS CUSTOMER_ANALYSIS;




-- QUESTION 39:
-- FIND THE PERCENTAGE OF CUSTOMERS WHO ARE VIP CUSTOMERS.

-- QUESTION 39:
-- FIND THE PERCENTAGE OF CUSTOMERS WHO ARE VIP CUSTOMERS.

SELECT 
    VIP_COUNT,
    TOTAL_COUNT,
    ROUND((VIP_COUNT * 100.0 / TOTAL_COUNT), 2) AS VIP_PERCENTAGE
FROM
(
    SELECT 
        COUNT(
            CASE 
                WHEN CUSTOMER_SEGMENT = 'VIP CUSTOMER' 
                THEN 1 
            END
        ) AS VIP_COUNT,
        COUNT(*) AS TOTAL_COUNT
    FROM
    (
        SELECT 
            CUSTOMER_ID,
            CUSTOMER_NAME,
            TOTAL_SPENDING,
            COMPLETED_ORDERS,
            VALUE_SEGMENT,
            ACTIVITY_SEGMENT,
            CASE
                WHEN VALUE_SEGMENT = 'HIGH VALUE'
                     AND ACTIVITY_SEGMENT = 'HIGH ACTIVITY'
                    THEN 'VIP CUSTOMER'

                WHEN VALUE_SEGMENT = 'HIGH VALUE'
                     AND ACTIVITY_SEGMENT = 'NOT HIGH ACTIVITY'
                    THEN 'HIGH VALUE CUSTOMER'

                WHEN VALUE_SEGMENT = 'NOT HIGH VALUE'
                     AND ACTIVITY_SEGMENT = 'HIGH ACTIVITY'
                    THEN 'FREQUENT CUSTOMER'

                ELSE 'REGULAR CUSTOMER'
            END AS CUSTOMER_SEGMENT

        FROM
        (
            SELECT 
                C.CUSTOMER_ID,
                C.CUSTOMER_NAME,
                SUM(P.AMOUNT) AS TOTAL_SPENDING,
                COUNT(O.ORDER_ID) AS COMPLETED_ORDERS,

                CASE
                    WHEN SUM(P.AMOUNT) >= 50000
                        THEN 'HIGH VALUE'
                    ELSE 'NOT HIGH VALUE'
                END AS VALUE_SEGMENT,

                CASE
                    WHEN COUNT(O.ORDER_ID) >= 5
                        THEN 'HIGH ACTIVITY'
                    ELSE 'NOT HIGH ACTIVITY'
                END AS ACTIVITY_SEGMENT

            FROM CUSTOMERS C

            JOIN ORDERS O
                ON C.CUSTOMER_ID = O.CUSTOMER_ID

            JOIN PAYMENTS P
                ON O.ORDER_ID = P.ORDER_ID

            WHERE O.ORDER_STATUS = 'COMPLETED'

            GROUP BY 
                C.CUSTOMER_ID,
                C.CUSTOMER_NAME
        ) AS CUSTOMER_ANALYSIS
    ) AS CUSTOMER_SEGMENTS
) AS VIP_ANALYSIS;


-- QUESTION 40:
-- FIND THE PERCENTAGE OF REVENUE GENERATED BY VIP CUSTOMERS
-- FROM THE TOTAL REVENUE OF COMPLETED ORDERS.

SELECT 
    VIP_REVENUE,
    TOTAL_REVENUE,
    ROUND((VIP_REVENUE * 100.0 / TOTAL_REVENUE), 2) 
        AS VIP_REVENUE_PERCENTAGE
FROM
(
    SELECT 
        SUM(
            CASE 
                WHEN CUSTOMER_SEGMENT = 'VIP CUSTOMER'
                THEN TOTAL_SPENDING
                ELSE 0
            END
        ) AS VIP_REVENUE,

        SUM(TOTAL_SPENDING) AS TOTAL_REVENUE

    FROM
    (
        SELECT 
            CUSTOMER_ID,
            CUSTOMER_NAME,
            TOTAL_SPENDING,
            COMPLETED_ORDERS,
            VALUE_SEGMENT,
            ACTIVITY_SEGMENT,

            CASE
                WHEN VALUE_SEGMENT = 'HIGH VALUE'
                     AND ACTIVITY_SEGMENT = 'HIGH ACTIVITY'
                    THEN 'VIP CUSTOMER'

                WHEN VALUE_SEGMENT = 'HIGH VALUE'
                     AND ACTIVITY_SEGMENT = 'NOT HIGH ACTIVITY'
                    THEN 'HIGH VALUE CUSTOMER'

                WHEN VALUE_SEGMENT = 'NOT HIGH VALUE'
                     AND ACTIVITY_SEGMENT = 'HIGH ACTIVITY'
                    THEN 'FREQUENT CUSTOMER'

                ELSE 'REGULAR CUSTOMER'
            END AS CUSTOMER_SEGMENT

        FROM
        (
            SELECT 
                C.CUSTOMER_ID,
                C.CUSTOMER_NAME,
                SUM(P.AMOUNT) AS TOTAL_SPENDING,
                COUNT(O.ORDER_ID) AS COMPLETED_ORDERS,

                CASE
                    WHEN SUM(P.AMOUNT) >= 50000
                        THEN 'HIGH VALUE'
                    ELSE 'NOT HIGH VALUE'
                END AS VALUE_SEGMENT,

                CASE
                    WHEN COUNT(O.ORDER_ID) >= 5
                        THEN 'HIGH ACTIVITY'
                    ELSE 'NOT HIGH ACTIVITY'
                END AS ACTIVITY_SEGMENT

            FROM CUSTOMERS C

            JOIN ORDERS O
                ON C.CUSTOMER_ID = O.CUSTOMER_ID

            JOIN PAYMENTS P
                ON O.ORDER_ID = P.ORDER_ID

            WHERE O.ORDER_STATUS = 'COMPLETED'

            GROUP BY 
                C.CUSTOMER_ID,
                C.CUSTOMER_NAME
        ) AS CUSTOMER_ANALYSIS
    ) AS CUSTOMER_SEGMENTS
) AS VIP_ANALYSIS;