select
    customer_name,
    count() as transaction_count,
    countIf(is_fraud = 1) as fraud_count,
    round(100.0 * fraud_count / nullIf(transaction_count, 0), 2) as fraud_rate,
    round(avg(amount), 2) as average_amount,
    round(sum(amount), 2) as total_amount,
    multiIf(fraud_rate >= 5, 'HIGH', fraud_rate >= 1, 'MEDIUM', 'LOW') as risk_segment
from {{ ref('stg_transactions') }}
group by customer_name
