select
    day_of_week,
    transaction_hour,
    count() as transaction_count,
    countIf(is_fraud = 1) as fraud_count,
    round(100.0 * fraud_count / nullIf(transaction_count, 0), 2) as fraud_rate,
    round(avg(amount), 2) as average_amount
from {{ ref('stg_transactions') }}
group by day_of_week, transaction_hour
