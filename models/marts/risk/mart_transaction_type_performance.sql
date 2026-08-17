with transactions as (

    select *
    from {{ ref('fct_transactions') }}

),

final as (

    select
        transaction_type,
        -- Transaction Summary
        count(*) as transaction_count,
        sum(transaction_amount) as total_transaction_amount,
        avg(transaction_amount) as average_transaction_amount,
        max(transaction_amount) as maximum_transaction_amount,
        --Customer Summary
        count(distinct customer_id) as unique_customers,
        count(distinct recipient_id) as unique_recipients,
        -- Fraud Summary
        sum(is_fraud) as fraudulent_transaction_count,
        sum(case when is_fraud = 1 then transaction_amount else 0 end) as fraudulent_transaction_amount,

        sum(is_flagged_fraud) as flagged_transaction_count,

        avg(fraud_signal_score) as average_fraud_signal_score,
        -- Balance Reconciliation Summary
        sum(sender_balance_reconciled_flag) as sender_balance_reconciled_count,
        sum(recipient_balance_reconciled_flag) as recipient_balance_reconciled_count,

        sum(sender_balance_reconciled_flag) / nullif(count(*), 0) as sender_balance_reconciliation_rate,
        sum(recipient_balance_reconciled_flag) / nullif(count(*), 0) as recipient_balance_reconciliation_rate,
        -- Fraud Rate
        sum(is_fraud) / nullif(count(*), 0) as fraud_rate

    from transactions
    group by 1

)

select *
from final