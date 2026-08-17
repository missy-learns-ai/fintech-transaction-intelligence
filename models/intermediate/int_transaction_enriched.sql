with transactions as (
    select * from {{ ref('stg_transactions') }}
),

enriched as (
    select *,
        -- Transaction Amount Bucket
        case
            when transaction_amount < 100 then 'low'
            when transaction_amount < 1000 then 'medium'
            when transaction_amount < 10000 then 'high'
            else 'very_high'
        end as transaction_amount_bucket,

        -- Sender Balance Change
        sender_balance_after - sender_balance_before as sender_balance_change,

         -- Recipient Balance Change
        recipient_balance_after - recipient_balance_before as recipient_balance_change,

        -- Sender Balance Depletion Percentage
        case
            when sender_balance_before > 0 then transaction_amount / sender_balance_before
            else null
        end as sender_balance_depletion_pct,

        -- Emptied Sender Account Flag
        case
            when sender_balance_before > 0 and transaction_amount >= sender_balance_before then 1
            else 0
        end as emptied_sender_balance_flag,

        -- High Risk Transaction Type Flag
        case
            when transaction_type in ('TRANSFER','CASH_OUT') then 1
            else 0
        end as high_risk_transaction_type_flag,

        -- High Value Transaction Flag
        case
            when transaction_amount >= 10000 then 1
            else 0
        end as high_value_transaction_flag

    from transactions
)

select * from enriched