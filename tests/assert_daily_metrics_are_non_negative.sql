select *
from {{ ref('mart_daily_transaction_metrics') }}
where transaction_count < 0
   or total_transaction_amount < 0
   or fraudulent_transaction_count < 0
   or fraudulent_transaction_amount < 0
   or flagged_transaction_count < 0
   or flagged_transaction_amount < 0