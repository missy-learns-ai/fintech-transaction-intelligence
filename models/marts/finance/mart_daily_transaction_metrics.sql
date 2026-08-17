with transactions as (

    select *
    from {{ ref('fct_transactions') }}

),

daily_metrics as (
    -- Daily Transactional Metrics of Paysim: Transaction, Customers, Fradulent Transaction
    select
        transaction_day,

        count(*) as transaction_count,
        sum(transaction_amount) as total_transaction_amount,
        avg(transaction_amount) as average_transaction_amount,
        max(transaction_amount) as maximum_transaction_amount,
        
        count(distinct customer_id) as active_senders,
        count(distinct recipient_id) as active_recipients,

        sum(is_fraud) as fraudulent_transaction_count,
        sum(case when is_fraud = 1 then transaction_amount else 0 end) as fraudulent_transaction_amount,

        sum(is_flagged_fraud) as flagged_transaction_count,
        sum(case when is_flagged_fraud = 1 then transaction_amount else 0 end) as flagged_transaction_amount,

        avg(fraud_signal_score) as average_fraud_signal_score

    from transactions
    group by 1

),

final as (

    select
        *,
        -- Daily Transaction Fraud Summary
        fraudulent_transaction_count / nullif(transaction_count, 0) as fraud_rate,
        fraudulent_transaction_amount / nullif(total_transaction_amount, 0) as fraud_amount_rate,
        flagged_transaction_count / nullif(transaction_count, 0) as flagged_rate

    from daily_metrics

)

select *
from final