WITH customer_activity AS (
    SELECT
        customer_id,
        MAX(last_purchase_date) AS last_purchase, -- Последняя дата покупки
        COUNT(DISTINCT order_id) AS total_orders, -- Общее количество заказов
        SUM(order_amount) AS total_spent, -- Общая сумма потраченных средств
        DATEDIFF(day, MAX(last_purchase_date), CURRENT_DATE) AS days_since_last_purchase -- Дней с последней покупки
    FROM
        orders
    WHERE
        order_date >= DATEADD(month, -6, CURRENT_DATE) -- Данные за последние 6 месяцев
    GROUP BY
        customer_id
),
churn_status AS (
    SELECT
        customer_id,
        CASE
            WHEN days_since_last_purchase > 90 THEN 1 -- Если клиент не совершал покупок более 90 дней, считаем его оттёкшим
            ELSE 0
        END AS churn_flag -- Флаг оттока (1 - отток, 0 - активный клиент)
    FROM
        customer_activity
)
SELECT
    ca.customer_id,
    ca.last_purchase,
    ca.total_orders,
    ca.total_spent,
    ca.days_since_last_purchase,
    cs.churn_flag
FROM
    customer_activity ca
JOIN
    churn_status cs
ON
    ca.customer_id = cs.customer_id;
