select
    merch,
    count() as transaction_count,
    countIf(is_fraud = 1) as fraud_count,
    round(100.0 * fraud_count / nullIf(transaction_count, 0), 2) as fraud_rate,
    round(sum(amount), 2) as turnover,
    round(sumIf(amount, is_fraud = 1), 2) as fraud_amount,
    multiIf(fraud_rate >= 5, 'HIGH', fraud_rate >= 1, 'MEDIUM', 'LOW') as suspicion_level
from {{ ref('stg_transactions') }}
group by merch
