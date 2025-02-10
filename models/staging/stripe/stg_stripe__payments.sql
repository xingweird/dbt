select
    id as payment_id,
    orderid AS order_id,
    paymentmethod AS payment_method,
    status,
    amount/100 AS amount,
    created AS date
from {{ source('stripe', 'payment') }}