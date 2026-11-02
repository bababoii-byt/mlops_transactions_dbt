select
    us_state,
    count() as transaction_count,
    countIf(is_fraud = 1) as fraud_count,
    round(100.0 * fraud_count / nullIf(transaction_count, 0), 2) as fraud_rate,
    uniqExact(concat(name_1, ' ', name_2)) as unique_customers,
    uniqExact(merch) as unique_merchants,
    round(sum(amount), 2) as total_amount,
    round(sumIf(amount, is_fraud = 1), 2) as fraud_amount
from {{ ref('stg_transactions') }}
group by us_state
