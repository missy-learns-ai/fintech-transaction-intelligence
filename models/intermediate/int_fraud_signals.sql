{{ config(materialized='table') }}

with transactions as (

    select *
    from {{ ref('int_transaction_enriched') }}

),

velocity as (

    select *
    from {{ ref('int_customer_transaction_velocity') }}

),

balance_validation as (

    select *
    from {{ ref('int_balance_validation') }}

),

final as (

    select
        transactions.transaction_id,
        -- Flagging large (above 100000) transactions 
        case
            when transactions.transaction_amount >= 100000 then 1
            else 0
        end as unusually_large_transaction_flag,

        -- Flagging if transaction is above historical average
        case
            when velocity.historical_average_transaction_amount is not null
                and transactions.transaction_amount >= velocity.historical_average_transaction_amount * 3
                then 1
            else 0
        end as above_historical_average_flag,

        -- Flagging high transaction velocity: >=5 in last 24 hours or >=20 in last 7 days
        case
            when velocity.transactions_previous_24_hours >= 5
                or velocity.transactions_previous_7_days >= 20
                then 1
            else 0
        end as high_transaction_velocity_flag,

        -- Flagging large balance depletion
        case
            when transactions.sender_balance_depletion_pct >= 0.9 then 1
            else 0
        end as large_balance_depletion_flag,

        -- Flagging unusually high recipient count
        case
            when velocity.unique_recipients_previous_7_days >= 5 then 1
            else 0
        end as unusually_high_recipient_count_flag,

        -- Flagging prior fraudulent activity
        case
            when velocity.previous_fraudulent_transaction_count > 0 then 1
            else 0
        end as prior_fraudulent_activity_flag,

        -- Flagging balance inconsistency
        case
            when balance_validation.sender_balance_reconciled_flag = 0
                or balance_validation.recipient_balance_reconciled_flag = 0
                then 1
            else 0
        end as balance_inconsistency_flag,

        -- Calculating fraud signal score
        (
            unusually_large_transaction_flag
            + above_historical_average_flag
            + high_transaction_velocity_flag
            + large_balance_depletion_flag
            + unusually_high_recipient_count_flag
            + prior_fraudulent_activity_flag
            + balance_inconsistency_flag
        ) as fraud_signal_score

    from transactions
    left join velocity
        on transactions.transaction_id = velocity.transaction_id
    left join balance_validation
        on transactions.transaction_id = balance_validation.transaction_id

)

select *
from final