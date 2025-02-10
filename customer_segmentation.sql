WITH purchases AS (
    SELECT 
        customer_id,
        COUNT(order_id) AS frequency,  -- Количество заказов (частота)
        MAX(order_date) AS last_order_date, -- Дата последнего заказа
        SUM(total_amount) AS monetary_value -- Общая сумма покупок
    FROM orders
    WHERE order_date >= CURRENT_DATE - INTERVAL '1 year' -- Анализируем за последний год
    GROUP BY customer_id
),

rfm_scores AS (
    SELECT 
        customer_id,
        frequency,
        monetary_value,
        RANK() OVER (ORDER BY MAX(last_order_date) DESC) AS recency_rank, -- Чем выше ранг, тем "свежее" клиент
        NTILE(5) OVER (ORDER BY frequency DESC) AS frequency_rank, -- Делим клиентов на 5 групп по частоте покупок
        NTILE(5) OVER (ORDER BY monetary_value DESC) AS monetary_rank -- Делим клиентов на 5 групп по сумме покупок
    FROM purchases
)

SELECT 
    customer_id,
    frequency,
    monetary_value,
    CASE 
        WHEN recency_rank <= 2 AND frequency_rank >= 4 AND monetary_rank >= 4 THEN 'VIP'
        WHEN recency_rank <= 3 AND frequency_rank >= 3 THEN 'Лояльные'
        WHEN recency_rank > 3 AND frequency_rank <= 2 THEN 'Редкие покупатели'
        ELSE 'Потенциальные'
    END AS customer_segment
FROM rfm_scores
ORDER BY customer_segment DESC;
