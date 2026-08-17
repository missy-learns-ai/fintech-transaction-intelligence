# Data Dictionary

## Source: `paysim.transactions`

Grain: one row per PaySim transaction.

| Column | Meaning |
| --- | --- |
| `step` | Simulated hour from the start of the dataset |
| `type` | Transaction type |
| `amount` | Transaction amount |
| `nameOrig` | Sender account/customer identifier |
| `oldbalanceOrg` | Sender balance before transaction |
| `newbalanceOrig` | Sender balance after transaction |
| `nameDest` | Recipient account/customer identifier |
| `oldbalanceDest` | Recipient balance before transaction |
| `newbalanceDest` | Recipient balance after transaction |
| `isFraud` | Actual fraud indicator |
| `isFlaggedFraud` | Original rule-based fraud flag |

## Core Models

| Model | Grain | Purpose |
| --- | --- | --- |
| `fct_transactions` | One row per transaction | Canonical transaction fact table |
| `dim_customers` | One row per sender customer | Customer lifetime activity and fraud profile |
| `dim_recipients` | One row per recipient | Recipient activity and fraud exposure |
| `dim_date` | One row per simulated transaction step | Simulated time dimension |

## Analytical Marts

| Model | Grain | Purpose |
| --- | --- | --- |
| `mart_customer_360` | One row per customer | Customer segmentation and lifecycle analytics |
| `mart_daily_transaction_metrics` | One row per simulated day | Executive daily transaction KPIs |
| `mart_fraud_risk_summary` | One row per risk segment | Fraud signal and risk segment summary |
| `mart_transaction_type_performance` | One row per transaction type | Transaction type performance and fraud metrics |