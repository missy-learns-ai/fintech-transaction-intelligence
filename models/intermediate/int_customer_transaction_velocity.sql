{{ config(materialized='table') }}

with transactions as (

    select *
    from {{ ref('int_transaction_enriched') }}

),

windowed as (

    select
        *,
        -- Previous 24 hours transaction count
        count(*) over (
            partition by sender_customer_id
            order by transaction_step
            range between 24 preceding and 1 preceding
        ) as transactions_previous_24_hours,

         -- Previous 7 days transaction count
        count(*) over (
            partition by sender_customer_id
            order by transaction_step
            range between 168 preceding and 1 preceding
        ) as transactions_previous_7_days,

        -- Previous 24 hours transaction amount
        sum(transaction_amount) over (
            partition by sender_customer_id
            order by transaction_step
            range between 24 preceding and 1 preceding
        ) as transaction_amount_previous_24_hours,

        -- Previous 7 days transaction amount
        sum(transaction_amount) over (
            partition by sender_customer_id
            order by transaction_step
            range between 168 preceding and 1 preceding
        ) as transaction_amount_previous_7_days,

        -- Historical average transaction amount
        avg(transaction_amount) over (
            partition by sender_customer_id
            order by transaction_step
            rows between unbounded preceding and 1 preceding
        ) as historical_average_transaction_amount,

        -- Historical maximum transaction amount
        max(transaction_amount) over (
            partition by sender_customer_id
            order by transaction_step
            rows between unbounded preceding and 1 preceding
        ) as historical_maximum_transaction_amount,

        -- Fraudulent transaction count
        sum(is_fraud) over (
            partition by sender_customer_id
            order by transaction_step
            rows between unbounded preceding and 1 preceding
        ) as previous_fraudulent_transaction_count

    from transactions

),

recipient_counts as (
    -- Unique recipient
    select
        current_tx.transaction_id,
        count(distinct previous_tx.recipient_id) as unique_recipients_previous_7_days

    from transactions as current_tx
    left join transactions as previous_tx
        on current_tx.sender_customer_id = previous_tx.sender_customer_id
        and previous_tx.transaction_step between current_tx.transaction_step - 168
            and current_tx.transaction_step - 1

    group by 1

),

final as (

    select
        windowed.transaction_id,
        windowed.sender_customer_id,
        windowed.transaction_step,
        windowed.transaction_day,
        windowed.transaction_hour,

        coalesce(windowed.transactions_previous_24_hours, 0) as transactions_previous_24_hours,
        coalesce(windowed.transactions_previous_7_days, 0) as transactions_previous_7_days,
        coalesce(windowed.transaction_amount_previous_24_hours, 0) as transaction_amount_previous_24_hours,
        coalesce(windowed.transaction_amount_previous_7_days, 0) as transaction_amount_previous_7_days,

        coalesce(recipient_counts.unique_recipients_previous_7_days, 0) as unique_recipients_previous_7_days,

        windowed.historical_average_transaction_amount,
        windowed.historical_maximum_transaction_amount,
        coalesce(windowed.previous_fraudulent_transaction_count, 0) as previous_fraudulent_transaction_count

    from windowed
    left join recipient_counts
        on windowed.transaction_id = recipient_counts.transaction_id

)

select *
from final