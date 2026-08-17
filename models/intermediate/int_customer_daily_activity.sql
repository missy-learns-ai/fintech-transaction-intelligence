{{ config(materialized='table') }}

with transactions as (

    select *
    from {{ ref('int_transaction_enriched') }}

),

sent_activity as (

    select
        sender_customer_id as customer_id,
        transaction_day,
        -- Customers transaction summary
        count(*) as transaction_count,
        sum(transaction_amount) as total_amount_sent,
        avg(transaction_amount) as average_transaction_amount,
        max(transaction_amount) as maximum_transaction_amount,
        -- Customers recipient summary
        count(distinct recipient_id) as number_of_recipients,
        count(distinct transaction_type) as number_of_transaction_types,
        -- Fraudulent transaction
        sum(is_fraud) as fraudulent_transaction_count,
        sum(case when is_flagged_fraud = 1 then 1 else 0 end) as flagged_transaction_count

    from transactions
    group by 1, 2

),

received_activity as (

    select
        recipient_id as customer_id,
        transaction_day,
        -- Tracking recieved amount stats
        sum(transaction_amount) as total_amount_received,
        count(*) as received_transaction_count

    from transactions
    where recipient_account_type = 'customer'
    group by 1, 2

),

final as (

    select
        sent_activity.customer_id,
        sent_activity.transaction_day,

        sent_activity.transaction_count,
        sent_activity.total_amount_sent,
        coalesce(received_activity.total_amount_received, 0) as total_amount_received,

        sent_activity.average_transaction_amount,
        sent_activity.maximum_transaction_amount,
        sent_activity.number_of_recipients,
        sent_activity.number_of_transaction_types,

        sent_activity.fraudulent_transaction_count,
        sent_activity.flagged_transaction_count,
        coalesce(received_activity.received_transaction_count, 0) as received_transaction_count

    from sent_activity
    left join received_activity
        on sent_activity.customer_id = received_activity.customer_id
        and sent_activity.transaction_day = received_activity.transaction_day

)

select *
from final
