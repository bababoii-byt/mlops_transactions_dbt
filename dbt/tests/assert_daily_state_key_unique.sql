select
    transaction_date,
    us_state,
    count() as row_count
from {{ ref('mart_daily_state_metrics') }}
group by transaction_date, us_state
having row_count > 1
