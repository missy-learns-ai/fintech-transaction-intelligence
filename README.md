# Fintech Transaction Intelligence Platform

## Project Overview

This project is an analytics engineering project built around financial transaction data from the PaySim dataset. The goal is to transform raw transaction data into clean, tested, documented, and analysis-ready data models using Snowflake and dbt.

The project simulates how a fintech company could analyze customer transactions, transaction behavior, fraud patterns, and business performance.

## Tech Stack

- Snowflake: cloud data warehouse
- dbt: data transformation, testing, and documentation
- GitHub: version control and project workflow
- Power BI / Tableau: future dashboarding and visualization
- PaySim: synthetic financial transaction dataset

## Dataset

The project uses the PaySim synthetic mobile money transaction dataset.

Dataset link: https://www.kaggle.com/datasets/ealaxi/paysim1/data

The raw dataset includes transaction details such as:

- transaction step
- transaction type
- transaction amount
- sender account
- recipient account
- sender and recipient balances
- fraud indicator
- flagged fraud indicator

## Project Goals

The main goals of this project are to:

- Load raw PaySim transaction data into Snowflake
- Build a structured dbt project
- Create staging, intermediate, and mart models
- Apply data quality tests
- Document models and business definitions
- Analyze transaction behavior and fraud patterns
- Prepare datasets for BI dashboards

## Planned dbt Layers

Raw Data  
↓  
Staging Models  
↓  
Intermediate Models  
↓  
Core Fact and Dimension Models  
↓  
Analytical Marts  
↓  
BI Dashboards  

## Key Business Questions

This project will help answer questions such as:

- What is the total transaction volume and value?
- Which transaction types are most common?
- Which transaction types have the highest fraud rate?
- What customer behaviors are associated with fraud?
- Are there unusual balance or transaction patterns?
- Which customers or recipients show suspicious activity?

## Current Status

Project setup is in progress.

Initial steps:

- PaySim data loaded into Snowflake
- GitHub repository setup
- dbt project setup planned next

## Future Work

Planned next steps include:

- Configure dbt with Snowflake
- Define dbt sources
- Build staging models
- Build intermediate transformation models
- Build marts for customer, finance, and fraud analytics
- Add dbt tests and documentation
- Create BI dashboards
- Write an analytical investigation
