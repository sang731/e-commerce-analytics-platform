#  Ecommerce Analytics Platform

This project is built using dbt and Snowflake for transforming and analyzing ecommerce data.

## Project Overview

The goal of this project is to create a simple analytics pipeline using layered models:

- Staging layer for cleaning raw data
- Silver layer for transformations
- Gold layer for final business-ready tables

## Tech Stack

- dbt
- Snowflake
- SQL
- VS Code

### Pipeline Flow

S3 → Snowpipe → Bronze → dbt Transformations → Silver → Gold → Streamlit Dashboard

## Project Structure

models/
├── bronze/
├── staging/
├── silver/
└── gold/

## Setup

1. Clone the repository
git clone <repo-url>

2. Install dependencies
dbt deps

3. Configure profiles.yml with Snowflake credentials

4. Test connection
dbt debug

5. Run models
dbt run

## Useful Commands

dbt run
dbt test
dbt compile
dbt clean
