select
    transaction_id,
    fraud_signal_score
from {{ ref('fct_transactions') }}
where fraud_signal_score < 0
   or fraud_signal_score > 7
   or fraud_signal_score != (
        unusually_large_transaction_flag
        + above_historical_average_flag
        + high_transaction_velocity_flag
        + large_balance_depletion_flag
        + unusually_high_recipient_count_flag
        + prior_fraudulent_activity_flag
        + balance_inconsistency_flag
   )