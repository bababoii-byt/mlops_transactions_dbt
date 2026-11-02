select
    transaction_date,
    us_state,
    count() as transaction_count,
    round(sum(amount), 2) as total_amount,
    round(avg(amount), 2) as average_amount,
    quantile(0.95)(amount) as p95_amount,
    round(100.0 * countIf(amount >= 1000) / nullIf(count(), 0), 2) as large_transaction_share_pct
from {{ ref('stg_transactions') }}
group by transaction_date, us_state
