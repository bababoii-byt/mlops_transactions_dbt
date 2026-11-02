with source_data as (
    select *
    from {{ source('raw', 'transactions') }}
),

renamed as (
    select
        parseDateTimeBestEffortOrNull(transaction_time) as transaction_time,
        merch,
        cat_id,
        toFloat64OrNull(toString(amount)) as amount,
        name_1,
        name_2,
        gender,
        us_state,
        toFloat64OrNull(lat) as lat,
        toFloat64OrNull(lon) as lon,
        toFloat64OrNull(merchant_lat) as merchant_lat,
        toFloat64OrNull(merchant_lon) as merchant_lon,
        toUInt8OrNull(toString(target)) as is_fraud
    from source_data
)

select
    transaction_time,
    toDate(transaction_time) as transaction_date,
    toHour(transaction_time) as transaction_hour,
    toDayOfWeek(transaction_time) as day_of_week,
    merch,
    cat_id,
    amount,
    {{ amount_bucket('amount') }} as amount_bucket,
    name_1,
    name_2,
    concat(name_1, ' ', name_2) as customer_name,
    gender,
    us_state,
    lat,
    lon,
    merchant_lat,
    merchant_lon,
    is_fraud
from renamed
where transaction_time is not null
  and amount is not null
  and is_fraud in (0, 1)
