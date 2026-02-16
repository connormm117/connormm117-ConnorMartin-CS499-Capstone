# Quantigration RMA Database Enhancement

## Overview

This project implements a relational database schema for managing Customers, Orders, and Return Merchandise Authorizations (RMA). The system was enhanced as part of a Computer Science capstone to demonstrate database design principles, performance optimization, data integrity enforcement, and security-aware development practices.

The schema supports structured data loading from CSV files and provides analytical SQL queries designed to support operational decision-making.

---

## Database Architecture

The database consists of three core relational tables:

### Customers
Stores customer demographic and contact information.

### Orders
Stores product purchase records linked to customers.

### RMA (Return Merchandise Authorization)
Stores product return information linked to orders.

The schema enforces referential integrity using primary and foreign key constraints, ensuring consistent and reliable relational structure.

---

## Schema Enhancements

The enhanced version includes:

- Primary key constraints on all tables
- Foreign key constraints with `ON UPDATE CASCADE` and `ON DELETE RESTRICT`
- Strategic indexing to improve join and aggregation performance
- Enumerated constraints on RMA status and disposition fields
- Defensive schema validation using `CHECK` constraints
- Composite indexing for common filtering operations

These enhancements improve performance, prevent invalid data entry, and strengthen data integrity.

---

## Data Integrity & Security Considerations

Security and reliability were prioritized through:

- Referential integrity enforcement to prevent orphan records
- Enumerated values to restrict invalid status entries
- Safe arithmetic using `NULLIF` to prevent division-by-zero errors
- Explicit indexing to reduce query execution time
- Defensive constraints to prevent incomplete data storage

These improvements reflect a security-aware database design mindset focused on protecting data consistency and preventing logical vulnerabilities.

---

## Analytical Queries

The database includes decision-support queries designed to provide operational insight:

- Identification of orphan orders (data integrity auditing)
- Customer concentration by state
- SKU demand ranking
- Return rate by SKU (quality monitoring)
- Customers generating the highest return volume
- RMA workload distribution by status and disposition
- Overall return rate KPI

Each query is structured for readability, deterministic output, and performance efficiency.

---

## Performance Considerations

- Indexes added to high-frequency join columns (`customer_id`, `order_id`, `sku`)
- Composite index on RMA status and disposition for summary reporting
- Aggregation queries structured to minimize unnecessary scans
- Controlled use of `LEFT JOIN` vs `JOIN` based on reporting needs

These decisions reflect deliberate trade-offs between performance, readability, and maintainability.

---

## How to Execute

From MySQL CLI or Codio:

