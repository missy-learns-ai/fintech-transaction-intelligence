with transactions as (

    select *
    from {{ ref('int_transaction_enriched') }}

),

balance_validation as (

    select *
    from {{ ref('int_balance_validation') }}

),

velocity as (

    select *
    from {{ ref('int_customer_transaction_velocity') }}

),

fraud_signals as (

    select *
    from {{ ref('int_fraud_signals') }}

),

final as (

    select
        transactions.transaction_id,
        transactions.transaction_step as date_key,

        transactions.sender_customer_id as customer_id,
        transactions.recipient_id,

        transactions.transaction_step,
        transactions.transaction_day,
        transactions.transaction_hour,
        transactions.transaction_type,
        transactions.transaction_amount,
        transactions.transaction_amount_bucket,

        transactions.sender_balance_before,
        transactions.sender_balance_after,
        transactions.recipient_balance_before,
        transactions.recipient_balance_after,

        transactions.sender_balance_change,
        transactions.recipient_balance_change,
        transactions.sender_balance_depletion_pct,

        transactions.sender_account_type,
        transactions.recipient_account_type,

        transactions.is_fraud,
        transactions.is_flagged_fraud,

        balance_validation.sender_balance_reconciled_flag,
        balance_validation.recipient_balance_reconciled_flag,

        velocity.transactions_previous_24_hours,
        velocity.transactions_previous_7_days,
        velocity.transaction_amount_previous_24_hours,
        velocity.transaction_amount_previous_7_days,
        velocity.unique_recipients_previous_7_days,
        velocity.historical_average_transaction_amount,
        velocity.historical_maximum_transaction_amount,
        velocity.previous_fraudulent_transaction_count,

        fraud_signals.unusually_large_transaction_flag,
        fraud_signals.above_historical_average_flag,
        fraud_signals.high_transaction_velocity_flag,
        fraud_signals.large_balance_depletion_flag,
        fraud_signals.unusually_high_recipient_count_flag,
        fraud_signals.prior_fraudulent_activity_flag,
        fraud_signals.balance_inconsistency_flag,
        fraud_signals.fraud_signal_score

    from transactions
    left join balance_validation
        on transactions.transaction_id = balance_validation.transaction_id
    left join velocity
        on transactions.transaction_id = velocity.transaction_id
    left join fraud_signals
        on transactions.transaction_id = fraud_signals.transaction_id

)

select *
from final