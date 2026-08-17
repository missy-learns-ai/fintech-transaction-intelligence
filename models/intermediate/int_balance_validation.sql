with transactions as (

    select * from {{ ref('int_transaction_enriched') }}

),

validated as (

    select
        transaction_id,
        sender_balance_before,
        sender_balance_after,
        recipient_balance_before,
        recipient_balance_after,
        transaction_amount,
        transaction_type,
        sender_balance_change,
        recipient_balance_change,

        -- Expected Sender Balance after a Transaction
        case
            when transaction_type in ('TRANSFER', 'CASH_OUT', 'PAYMENT', 'DEBIT')
                then sender_balance_before - transaction_amount
            when transaction_type = 'CASH_IN'
                then sender_balance_before + transaction_amount
            else null
        end as expected_sender_balance_after,

        -- Expected Recipient Balance after a Transaction
        case
            when transaction_type in ('TRANSFER', 'CASH_IN')
                then recipient_balance_before + transaction_amount
            when transaction_type in ('CASH_OUT', 'PAYMENT', 'DEBIT')
                then recipient_balance_before
            else null
        end as expected_recipient_balance_after,

        -- Sender Balance Reconciliation Flag
        case
            when expected_sender_balance_after is not null
                 and abs(sender_balance_after - expected_sender_balance_after) <= 0.01
                then 1
            else 0
        end as sender_balance_reconciled_flag,

        -- Recievers Balance Reconciliation Flag
        case
            when expected_recipient_balance_after is not null
                 and abs(recipient_balance_after - expected_recipient_balance_after) <= 0.01
                then 1
            else 0
        end as recipient_balance_reconciled_flag

    from transactions

)

select * from validated