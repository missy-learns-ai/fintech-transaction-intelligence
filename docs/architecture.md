# Architecture

## Objective

Build an analytics engineering platform for fintech transaction intelligence using Snowflake and dbt.

## Data Flow

PaySim CSV dataset
→ Snowflake raw schema
→ dbt source layer
→ staging models
→ intermediate transformation models
→ core fact and dimension models
→ analytical marts
→ BI dashboards

## Snowflake Layers

- `FINTECH.RAW`: raw PaySim transaction table
- dbt development schema: developer-owned dbt objects
- future production analytics schema: curated production models

## dbt Layers

- `models/staging`: cleaned and standardized source data
- `models/intermediate`: reusable business logic
- `models/marts/core`: canonical facts and dimensions
- `models/marts/customer`: customer-facing analytical marts
- `models/marts/finance`: executive and financial metrics
- `models/marts/risk`: fraud and risk analytics

## Materialization Strategy

- Staging models: views
- Lightweight intermediate models: views
- Heavy intermediate models: tables
- Core facts and dimensions: tables
- Analytical marts: tables