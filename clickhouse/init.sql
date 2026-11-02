CREATE DATABASE IF NOT EXISTS transactions_db;

-- Raw landing table. Columns are kept as strings where possible so that
-- source formatting can be normalized in dbt staging.
CREATE TABLE IF NOT EXISTS transactions_db.transactions
(
    transaction_time String,
    merch String,
    cat_id String,
    amount Float64,
    name_1 String,
    name_2 String,
    gender String,
    street String,
    one_city String,
    us_state String,
    post_code String,
    lat String,
    lon String,
    population_city String,
    jobs String,
    merchant_lat String,
    merchant_lon String,
    target UInt8
)
ENGINE = MergeTree
ORDER BY tuple();
