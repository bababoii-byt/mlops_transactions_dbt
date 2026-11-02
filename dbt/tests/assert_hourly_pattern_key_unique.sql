select
    day_of_week,
    transaction_hour,
    count() as row_count
from {{ ref('mart_hourly_fraud_pattern') }}
group by day_of_week, transaction_hour
having row_count > 1
