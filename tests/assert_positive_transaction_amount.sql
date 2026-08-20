select
    transaction_id,
    transaction_amount
from {{ ref('fct_transactions') }}
where transaction_amount < 0