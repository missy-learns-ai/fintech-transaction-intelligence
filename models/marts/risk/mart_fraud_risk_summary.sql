with transactions as (

    select *
    from {{ ref('fct_transactions') }}

),

risk_segmented as (

    select
        *,
        -- Risk Segmentation based on Fraud Signal Score
        case
            when fraud_signal_score >= 5 then 'critical'
            when fraud_signal_score >= 3 then 'high'
            when fraud_signal_score >= 1 then 'medium'
            else 'low'
        end as analytical_risk_segment

    from transactions

),

final as (

    select
        analytical_risk_segment,
        -- Transactional Summary
        count(*) as transaction_count,
        sum(transaction_amount) as total_transaction_amount,
        avg(transaction_amount) as average_transaction_amount,
        max(transaction_amount) as maximum_transaction_amount,
        -- Customer Summary
        count(distinct customer_id) as unique_customers,
        count(distinct recipient_id) as unique_recipients,
        -- Fraud Transaction Summary
        sum(is_fraud) as fraudulent_transaction_count,
        sum(case when is_fraud = 1 then transaction_amount else 0 end) as fraudulent_transaction_amount,

        avg(fraud_signal_score) as average_fraud_signal_score,
        -- Unsual Transactions Summary
        sum(unusually_large_transaction_flag) as unusually_large_transaction_count,
        sum(above_historical_average_flag) as above_historical_average_count,
        sum(high_transaction_velocity_flag) as high_transaction_velocity_count,
        sum(large_balance_depletion_flag) as large_balance_depletion_count,
        sum(unusually_high_recipient_count_flag) as unusually_high_recipient_count,
        sum(prior_fraudulent_activity_flag) as prior_fraudulent_activity_count,
        sum(balance_inconsistency_flag) as balance_inconsistency_count

    from risk_segmented
    group by 1

)

select *
from final