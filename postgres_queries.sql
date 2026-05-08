-- =====================================================
-- FILE: postgres_queries.sql
-- PURPOSE: PostgreSQL source database setup
-- =====================================================


-- =========================================
-- CREATE CUSTOMERS TABLE
-- =========================================

CREATE TABLE customers (
    customer_id INT,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(100)
);


-- =========================================
-- INSERT SAMPLE CUSTOMER DATA
-- =========================================

INSERT INTO customers VALUES
(1, 'Akash', 'akash@gmail.com', 'Bhopal'),
(2, 'Rahul', 'rahul@gmail.com', 'Delhi'),
(3, 'Aman', 'aman@gmail.com', 'Mumbai'),
(4, 'Priya', 'priya@gmail.com', 'Pune'),
(5, 'Rohit', 'rohit@gmail.com', 'Hyderabad'),
(6, 'Sneha', 'sneha@gmail.com', 'Indore'),
(7, 'Karan', 'karan@gmail.com', 'Jaipur'),
(8, 'Neha', 'neha@gmail.com', 'Lucknow'),
(9, 'Vikas', 'vikas@gmail.com', 'Chennai'),
(10, 'Anjali', 'anjali@gmail.com', 'Kolkata');


-- =========================================
-- VERIFY DATA
-- =========================================

SELECT * FROM customers;