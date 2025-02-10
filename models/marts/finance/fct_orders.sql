SELECT 
    o.order_id,
    o.customer_id,
    p.amount 
FROM {{ ref('stg_orders') }} AS o
LEFT JOIN {{ ref('stg_stripe__payments') }} AS p
ON o.order_id = p.order_id