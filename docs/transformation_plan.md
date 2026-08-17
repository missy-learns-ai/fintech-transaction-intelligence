# Transformation Plan

## Phase 1: Source Layer

Declare the raw Snowflake table as a dbt source.

Key work:
- Define source metadata
- Document raw columns
- Add source tests for required fields and accepted values

## Phase 2: Staging Layer

Create `stg_transactions`.

Key work:
- Rename raw columns into analytics-friendly names
- Cast data types
- Derive simulated day and hour
- Create deterministic transaction ID
- Standardize transaction type and fraud flags

## Phase 3: Intermediate Layer

Create reusable business logic models.

Models:
- `int_transaction_enriched`
- `int_balance_validation`
- `int_customer_daily_activity`
- `int_customer_transaction_velocity`
- `int_fraud_signals`

Key work:
- Add transaction amount buckets
- Calculate balance changes
- Validate expected balances
- Calculate customer daily activity
- Create velocity features
- Generate analytical fraud/risk signals

## Phase 4: Core Dimensional Layer

Create canonical BI-ready building blocks.

Models:
- `fct_transactions`
- `dim_customers`
- `dim_recipients`
- `dim_date`

## Phase 5: Analytical Marts

Create business-facing datasets.

Models:
- `mart_customer_360`
- `mart_daily_transaction_metrics`
- `mart_fraud_risk_summary`
- `mart_transaction_type_performance`

## Phase 6: Testing And Documentation

Testing strategy:
- Generic tests for uniqueness, null checks, accepted values, and relationships
- Singular tests for business rules and analytical sanity checks
- Exposures for planned dashboards
- Docs blocks for long-form transformation context