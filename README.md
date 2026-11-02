# Аналитика транзакций: ClickHouse + dbt

Учебный проект по построению аналитического хранилища и исследованию транзакций с признаками мошенничества.

В проекте используется **ClickHouse** для хранения данных и **dbt** для их преобразования, построения аналитических витрин, тестирования и документирования.

## Структура проекта

- `clickhouse/` — инициализация базы данных и исходной таблицы.
- `data/` — исходные CSV-файлы (не добавляются в Git).
- `dbt/models/staging/` — очистка и подготовка исходных данных.
- `dbt/models/marts/` — аналитические витрины.
- `dbt/macros/` — пользовательские SQL-макросы.
- `dbt/tests/` — дополнительные SQL-тесты.
- `dbt/packages.yml` — зависимости dbt.
- `docker-compose.yml` — запуск ClickHouse.
- `profiles.example.yml` — пример конфигурации подключения к ClickHouse.

## Архитектура

Данные проходят через два основных слоя:

1. **Raw** — исходные транзакции загружаются в таблицу `transactions_db.transactions` в ClickHouse.
2. **Staging** — модель `stg_transactions` очищает и преобразует исходные данные.
3. **Marts** — аналитические модели формируют витрины для исследования мошенничества и поведения клиентов.

## Аналитические витрины

| Модель | Назначение |
|---|---|
| `mart_daily_state_metrics` | Дневная статистика транзакций по штатам |
| `mart_fraud_by_category` | Метрики мошенничества по категориям |
| `mart_fraud_by_state` | Метрики мошенничества по штатам |
| `mart_customer_risk_profile` | Профиль активности и риска клиентов |
| `mart_hourly_fraud_pattern` | Распределение мошеннических транзакций по дням недели и часам |
| `mart_merchant_analytics` | Аналитика транзакций по продавцам |

## Используемые технологии

- Python
- ClickHouse
- dbt Core
- dbt-clickhouse
- dbt_utils
- dbt_date
- dbt_expectations
- SQLFluff
- pre-commit
- Docker Compose

В проекте также реализован собственный макрос `amount_bucket`, который распределяет суммы транзакций по категориям.

## Запуск проекта

### 1. Подготовка данных

Поместите исходный CSV-файл в `data/train.csv`.

Перед загрузкой проверьте соответствие заголовка CSV колонкам исходной таблицы, определённой в `clickhouse/init.sql`.

Исходный датасет не хранится в Git из-за размера.

### 2. Запуск ClickHouse

Из корневой папки проекта выполните:

```powershell
docker compose up -d
```

Проверка доступности сервера:

```powershell
curl.exe http://localhost:8123/ping
```

### 3. Загрузка данных

После проверки структуры CSV загрузите данные в исходную таблицу:

```powershell
cmd /c 'docker compose exec -T clickhouse clickhouse-client --query="INSERT INTO transactions_db.transactions FORMAT CSVWithNames" < data\train.csv'
```

Для больших файлов способ передачи CSV через stdin может зависеть от используемой оболочки. При необходимости используйте Git Bash, WSL или отдельный скрипт загрузки.

### 4. Установка dbt

Создайте виртуальное окружение и установите зависимости:

```powershell
py -m venv .venv
.\.venv\Scripts\Activate.ps1
py -m pip install -r requirements.txt
```

Создайте файл `%USERPROFILE%\.dbt\profiles.yml`, используя `profiles.example.yml` как образец.

Локальные настройки подключения не следует добавлять в Git.

### 5. Запуск dbt

Перейдите в папку `dbt`:

```powershell
cd dbt
```

Проверьте подключение и установите пакеты:

```powershell
dbt debug
dbt deps
```

Постройте модели и выполните тесты:

```powershell
dbt build
```

Либо отдельно:

```powershell
dbt run
dbt test
```

### 6. Документация

Сгенерируйте документацию и граф зависимостей моделей:

```powershell
dbt docs generate
dbt docs serve
```

После запуска документация будет доступна в браузере по адресу, указанному dbt.

## Проверки качества

Для проверки SQL-кода используется SQLFluff:

```powershell
sqlfluff lint models tests --ignore parsing
```

Имеется конфигурация pre-commit для автоматической проверки файлов:

```powershell
pre-commit run --all-files
```

В проекте реализованы schema-тесты, singular tests и unit test для staging-модели.

## Результаты

На текущем этапе реализованы шесть аналитических витрин, staging-модель, пользовательский макрос и набор проверок качества данных.

Последний успешный запуск `dbt test`:

- 26 data tests;
- 1 unit test;
- 27 успешных проверок;
- 0 ошибок.
