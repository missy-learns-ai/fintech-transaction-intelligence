select
    transaction_day as grain_key,
    fraud_rate,
    'mart_daily_transaction_metrics' as model_name
from {{ ref('mart_daily_transaction_metrics') }}
where fraud_rate < 0 or fraud_rate > 1

union all

select
    transaction_type as grain_key,
    fraud_rate,
    'mart_transaction_type_performance' as model_name
from {{ ref('mart_transaction_type_performance') }}
where fraud_rate < 0 or fraud_rate > 1