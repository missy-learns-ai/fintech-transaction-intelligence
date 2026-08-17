with transactions as (

    select *
    from {{ ref('int_transaction_enriched') }}

),

final as (

    select
        recipient_id,
        recipient_account_type,

        min(transaction_day) as first_received_day,
        max(transaction_day) as most_recent_received_day,

        count(*) as received_transaction_count,
        sum(transaction_amount) as total_amount_received,
        avg(transaction_amount) as average_received_amount,
        max(transaction_amount) as maximum_received_amount,

        count(distinct sender_customer_id) as unique_senders,
        count(distinct transaction_type) as received_transaction_types,

        sum(is_fraud) as fraudulent_received_transaction_count,
        max(is_fraud) as has_fraudulent_received_transaction_flag

    from transactions
    group by 1, 2

)

select *
from final