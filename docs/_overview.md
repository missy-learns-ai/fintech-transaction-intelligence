{% docs __overview__ %}

# Fintech Transaction Intelligence Platform

This dbt project models synthetic PaySim transaction data into analytics-ready datasets for executive reporting, operations monitoring, customer analysis, and fraud/risk investigation.

## Architecture

Raw PaySim data is loaded into Snowflake and transformed through the following layers:

1. Source layer: declares the raw Snowflake table.
2. Staging layer: standardizes names, types, and core transaction fields.
3. Intermediate layer: adds reusable business logic such as balance validation, customer activity, velocity features, and fraud signals.
4. Core marts: creates canonical fact and dimension models.
5. Analytical marts: creates BI-ready datasets for dashboards and investigation.

## Important Data Caveat

PaySim is a synthetic dataset. Balance fields are useful for analytical validation and anomaly detection, but they should not be treated as perfect real-world banking ledger behavior.

{% enddocs %}