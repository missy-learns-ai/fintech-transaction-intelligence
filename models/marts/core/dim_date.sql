with transactions as (

    select distinct
        transaction_step,
        transaction_day,
        transaction_hour
    from {{ ref('stg_transactions') }}

),

final as (

    select
        transaction_step as date_key,
        transaction_step,
        transaction_day,
        transaction_hour,

        case
            when transaction_hour between 0 and 5 then 'overnight'
            when transaction_hour between 6 and 11 then 'morning'
            when transaction_hour between 12 and 17 then 'afternoon'
            else 'evening'
        end as time_of_day_bucket

    from transactions

)

select *
from final