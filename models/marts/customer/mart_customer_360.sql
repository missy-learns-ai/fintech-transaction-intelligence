with customers as (

    select * from {{ ref('dim_customers') }}

),

daily_activity as (

    select * from {{ ref('int_customer_daily_activity') }}

),

customer_daily_rollup as (
    -- Daily Transaction Roll up
    select
        customer_id,

        count(*) as active_days,
        avg(transaction_count) as avg_daily_transaction_count,
        max(transaction_count) as max_daily_transaction_count,

        avg(total_amount_sent) as avg_daily_amount_sent,
        max(total_amount_sent) as max_daily_amount_sent,

        avg(number_of_recipients) as avg_daily_recipients,
        max(number_of_recipients) as max_daily_recipients,

        sum(fraudulent_transaction_count) as total_fraudulent_transactions

    from daily_activity
    group by 1

),

final as (

    select
        customers.customer_id,
        -- Customer Age and Transaction Recency
        customers.first_transaction_day,
        customers.most_recent_transaction_day,
        customer_daily_rollup.active_days,
        -- Customers Lifetime Value Analysis
        customers.lifetime_transaction_count,
        customers.lifetime_amount_sent,
        customers.lifetime_amount_received,
        customers.average_transaction_amount,
        customers.maximum_transaction_amount,
        customers.lifetime_unique_recipients,
        customers.lifetime_transaction_types,
        -- Customers Daily Transaction Rollup
        customer_daily_rollup.avg_daily_transaction_count,
        customer_daily_rollup.max_daily_transaction_count,
        customer_daily_rollup.avg_daily_amount_sent,
        customer_daily_rollup.max_daily_amount_sent,
        customer_daily_rollup.avg_daily_recipients,
        customer_daily_rollup.max_daily_recipients,
        -- Customers Fradulent Transaction Analytics
        customers.lifetime_fraudulent_transaction_count,
        customers.has_fraudulent_transaction_flag,

        -- Customer Segmentation
        case
            when customers.has_fraudulent_transaction_flag = 1 then 'known_fraud'
            when customer_daily_rollup.max_daily_transaction_count >= 10 then 'high_velocity'
            when customer_daily_rollup.max_daily_amount_sent >= 100000 then 'high_value'
            else 'standard'
        end as customer_segment

    from customers
    left join customer_daily_rollup
        on customers.customer_id = customer_daily_rollup.customer_id

)

select *
from final