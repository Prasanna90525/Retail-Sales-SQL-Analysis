# Retail Sales SQL Analysis

## About the Project

This is a SQL Server project based on a retail sales dataset.

I used SQL to explore the sales data and answer different business
questions related to customers, products, stores, sales, revenue,
profit and delivery time.

The main purpose of this project was to get practical experience in
writing SQL queries and solving business problems using data.

## Tools Used

- SQL Server
- SQL Server Management Studio (SSMS)
- GitHub

## Database Tables

The project contains the following tables:

- Sales
- Customers
- Products
- Stores
- Exchange_Rates
- Data_Dictionary

The `Sales` table is the main transaction table and is connected with
the customer, product, store and exchange rate tables.

## Table Relationships

```text
Sales
 |
 |-- CustomerKey ------ Customers
 |
 |-- ProductKey ------- Products
 |
 |-- StoreKey ---------- Stores
 |
 |-- Currency_Code ----- Exchange_Rates
 |
 |-- Order_Date -------- Exchange_Rates
