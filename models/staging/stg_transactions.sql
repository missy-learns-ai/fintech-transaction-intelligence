with source as (

    select * from {{ source('paysim','transactions')}}

),

standardized as(

    select
        md5(
            concat_ws(
                '|',
                step,
                type,
                amount,
                nameOrig,
                nameDest,
                oldbalanceOrg,
                newbalanceOrig,
                oldbalanceDest,
                newbalanceDest
            )
        ) as transaction_id,

        cast(step as integer) as transaction_step,
        ceil(cast(step as integer) / 24.0) as transaction_day,
        mod(cast(step as integer) - 1, 24) as transaction_hour,

        upper(type) as transaction_type,
        cast(amount as numeric(18, 2)) as transaction_amount,

        nameOrig as sender_customer_id,
        cast(oldbalanceOrg as numeric(18, 2)) as sender_balance_before,
        cast(newbalanceOrig as numeric(18, 2)) as sender_balance_after,

        nameDest as recipient_id,
        cast(oldbalanceDest as numeric(18, 2)) as recipient_balance_before,
        cast(newbalanceDest as numeric(18, 2)) as recipient_balance_after,

        cast(isFraud as integer) as is_fraud,
        cast(isFlaggedFraud as integer) as is_flagged_fraud,

        case
            when left(nameOrig, 1) = 'C' then 'customer'
            when left(nameOrig, 1) = 'M' then 'merchant'
            else 'unknown'
        end as sender_account_type,

        case
            when left(nameDest, 1) = 'C' then 'customer'
            when left(nameDest, 1) = 'M' then 'merchant'
            else 'unknown'
        end as recipient_account_type

    from source

)

select * from standardized