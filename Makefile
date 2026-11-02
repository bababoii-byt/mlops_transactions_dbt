DBT = dbt

.PHONY: deps seed run test docs build clean

deps:
	cd dbt && $(DBT) deps

seed:
	cd dbt && $(DBT) seed

run:
	cd dbt && $(DBT) run

test:
	cd dbt && $(DBT) test

docs:
	cd dbt && $(DBT) docs generate

build: deps seed run test

clean:
	cd dbt && $(DBT) clean
