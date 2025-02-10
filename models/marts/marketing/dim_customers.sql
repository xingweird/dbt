

with customers as (

    select * from {{ ref('stg_customers') }}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders,
        SUM(amount) AS customer_ltv

    from orders
    left join {{ ref('stg_stripe__payments') }}
    USING(order_id)

    group by 1

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        COALESCE(customer_orders.customer_ltv, 0) AS customer_ltv
    from customers
    left join customer_orders using (customer_id)
)

select * from final

