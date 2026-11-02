select
    cat_id,
    count() as transaction_count,
    countIf(is_fraud = 1) as fraud_count,
    round(100.0 * fraud_count / nullIf(transaction_count, 0), 2) as fraud_rate,
    round(sum(amount), 2) as total_amount,
    round(sumIf(amount, is_fraud = 1), 2) as fraud_amount,
    round(avg(amount), 2) as average_amount
from {{ ref('stg_transactions') }}
group by cat_id
