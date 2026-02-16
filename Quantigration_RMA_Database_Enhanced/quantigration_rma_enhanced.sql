/*
CS 499 Milestone Four (Databases) - Enhanced Artifact
Author: Connor Martin

Enhancements:
- Enforced referential integrity with PK/FK constraints
- Added indexing for performance optimization
- Implemented safe division logic to prevent runtime errors
- Applied defensive schema constraints
- Designed analytical queries to support decision-making
*/

-- -------------------------------------------------------------------
-- 1) Database Setup
-- -------------------------------------------------------------------
DROP DATABASE IF EXISTS quantigration_rma;
CREATE DATABASE quantigration_rma;
USE quantigration_rma;

-- -------------------------------------------------------------------
-- 2) Schema Design with Integrity & Validation
-- -------------------------------------------------------------------
DROP TABLE IF EXISTS rma;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id  INT PRIMARY KEY,
    first_name   VARCHAR(50)  NOT NULL,
    last_name    VARCHAR(50)  NOT NULL,
    street       VARCHAR(100) NOT NULL,
    city         VARCHAR(50)  NOT NULL,
    state        CHAR(2)      NOT NULL,
    zip          VARCHAR(10)  NOT NULL,
    phone        VARCHAR(20)  NOT NULL,
    CHECK (zip <> ''),
    CHECK (phone <> '')
);

CREATE TABLE orders (
    order_id            INT PRIMARY KEY,
    customer_id         INT NOT NULL,
    sku                 VARCHAR(20) NOT NULL,
    product_description VARCHAR(255) NOT NULL,

    CONSTRAINT fk_orders_customers
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_sku ON orders(sku);

CREATE TABLE rma (
    rma_id      INT PRIMARY KEY,
    order_id    INT NOT NULL,
    rma_note    VARCHAR(255) NOT NULL,
    status      ENUM('Pending','Approved','Rejected','Complete') NOT NULL,
    disposition ENUM('Refund','Replacement','Repair','Rejected') NOT NULL,

    CONSTRAINT fk_rma_orders
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE INDEX idx_rma_order_id ON rma(order_id);
CREATE INDEX idx_rma_status_disposition ON rma(status, disposition);

-- -------------------------------------------------------------------
-- 3) Data Load
-- -------------------------------------------------------------------
TRUNCATE TABLE rma;
TRUNCATE TABLE orders;
TRUNCATE TABLE customers;

LOAD DATA LOCAL INFILE 'customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n'
(customer_id, first_name, last_name, street, city, state, zip, phone);

LOAD DATA LOCAL INFILE 'orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
(order_id, customer_id, sku, product_description);

LOAD DATA LOCAL INFILE 'rma.csv'
INTO TABLE rma
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
(rma_id, order_id, rma_note, status, disposition);

-- -------------------------------------------------------------------
-- 4) Data Integrity Validation
-- -------------------------------------------------------------------
SELECT COUNT(*) AS orphan_orders
FROM orders o
LEFT JOIN customers c ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL;

-- -------------------------------------------------------------------
-- 5) Decision-Oriented Analytics
-- -------------------------------------------------------------------

-- Customer concentration by state
SELECT state, COUNT(*) AS customer_count
FROM customers
GROUP BY state
ORDER BY customer_count DESC, state ASC;

-- SKU demand ranking
SELECT o.sku,
       MIN(o.product_description) AS product_description,
       COUNT(*) AS total_orders
FROM orders o
GROUP BY o.sku
ORDER BY total_orders DESC, o.sku ASC;

-- Return rate per SKU (safe division prevents runtime error)
SELECT
    o.sku,
    MIN(o.product_description) AS product_description,
    COUNT(DISTINCT o.order_id) AS order_count,
    COUNT(DISTINCT r.rma_id)   AS rma_count,
    ROUND(
        COUNT(DISTINCT r.rma_id) /
        NULLIF(COUNT(DISTINCT o.order_id), 0) * 100,
        2
    ) AS return_rate_percent
FROM orders o
LEFT JOIN rma r ON r.order_id = o.order_id
GROUP BY o.sku
ORDER BY return_rate_percent DESC;

-- Customers generating highest return volume
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.state,
    COUNT(r.rma_id) AS total_rmas
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN rma r    ON r.order_id = o.order_id
GROUP BY c.customer_id, customer_name, c.state
ORDER BY total_rmas DESC;

-- RMA operational workload summary
SELECT
    status,
    disposition,
    COUNT(*) AS rma_count
FROM rma
GROUP BY status, disposition
ORDER BY rma_count DESC;

-- Overall KPI: global return rate
SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT r.rma_id)   AS total_rmas,
    ROUND(
        COUNT(DISTINCT r.rma_id) /
        NULLIF(COUNT(DISTINCT o.order_id), 0) * 100,
        2
    ) AS overall_return_rate_percent
FROM orders o
LEFT JOIN rma r ON r.order_id = o.order_id;
