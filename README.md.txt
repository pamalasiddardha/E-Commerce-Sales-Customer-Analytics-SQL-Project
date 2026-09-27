# 🛒 E-Commerce Sales & Customer Analytics — SQL Project

## 📌 Project Overview

This project is an end-to-end **SQL Data Analytics project** built using an e-commerce database.

The objective is to analyze **customers, orders, products, payments, revenue, and customer behavior** using SQL and convert raw transactional data into meaningful business insights.

The project contains **40 SQL business-analysis questions**, progressing from basic SQL concepts to advanced analytical techniques such as **window functions, ranking, running totals, month-over-month growth, and customer segmentation**.

---

## 🎯 Project Objectives

The main objectives of this project are to:

- Analyze overall e-commerce sales performance
- Understand customer purchasing behavior
- Identify top-performing products and categories
- Analyze revenue trends
- Analyze order and payment performance
- Identify high-value customers
- Analyze customer activity
- Segment customers based on their behavior
- Calculate advanced business metrics
- Practice SQL concepts used in real-world Data Analyst roles

---

# 🗂️ Database Structure

The project uses the following tables:

```text
CUSTOMERS
   │
   ├── CUSTOMER_ID
   ├── CUSTOMER_NAME
   ├── CITY
   └── STATE
        │
        ↓
ORDERS
   │
   ├── ORDER_ID
   ├── CUSTOMER_ID
   ├── ORDER_DATE
   └── ORDER_STATUS
        │
        ├───────────────┐
        ↓               ↓
ORDER_ITEMS         PAYMENTS
   │                   │
   ├── ORDER_ID        ├── ORDER_ID
   ├── PRODUCT_ID      ├── AMOUNT
   ├── QUANTITY        └── PAYMENT_METHOD
   └── UNIT_PRICE
        │
        ↓
PRODUCTS
   │
   ├── PRODUCT_ID
   ├── PRODUCT_NAME
   ├── CATEGORY_ID
   └── UNIT_PRICE
        │
        ↓
CATEGORIES
   │
   ├── CATEGORY_ID
   └── CATEGORY_NAME