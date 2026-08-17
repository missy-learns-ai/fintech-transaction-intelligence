with transactions as (

    select *
    from {{ ref('int_transaction_enriched') }}

),

daily_activity as (

    select *
    from {{ ref('int_customer_daily_activity') }}

),

customer_summary as (

    select
        sender_customer_id as customer_id,

        min(transaction_day) as first_transaction_day,
        max(transaction_day) as most_recent_transaction_day,

        count(*) as lifetime_transaction_count,
        sum(transaction_amount) as lifetime_amount_sent,
        avg(transaction_amount) as average_transaction_amount,
        max(transaction_amount) as maximum_transaction_amount,

        count(distinct recipient_id) as lifetime_unique_recipients,
        count(distinct transaction_type) as lifetime_transaction_types,

        sum(is_fraud) as lifetime_fraudulent_transaction_count,
        max(is_fraud) as has_fraudulent_transaction_flag

    from transactions
    group by 1

),

received_summary as (

    select
        customer_id,
        sum(total_amount_received) as lifetime_amount_received,
        sum(received_transaction_count) as lifetime_received_transaction_count
    from daily_activity
    group by 1

),

final as (

    select
        customer_summary.customer_id,
        customer_summary.first_transaction_day,
        customer_summary.most_recent_transaction_day,

        customer_summary.lifetime_transaction_count,
        customer_summary.lifetime_amount_sent,
        coalesce(received_summary.lifetime_amount_received, 0) as lifetime_amount_received,

        customer_summary.average_transaction_amount,
        customer_summary.maximum_transaction_amount,
        customer_summary.lifetime_unique_recipients,
        customer_summary.lifetime_transaction_types,

        customer_summary.lifetime_fraudulent_transaction_count,
        customer_summary.has_fraudulent_transaction_flag,
        coalesce(received_summary.lifetime_received_transaction_count, 0) as lifetime_received_transaction_count

    from customer_summary
    left join received_summary
        on customer_summary.customer_id = received_summary.customer_id

)

select *
from final