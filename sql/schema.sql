Create the database if it does not already exist.
CREATE DATABASE IF NOT EXISTS mamaearth;

Select the mamaearth database for subsequent operations.
USE mamaearth;

Drop the orders table if it already exists.
DROP TABLE IF EXISTS orders;

Drop the products table if it already exists.
DROP TABLE IF EXISTS products;

Drop the customers table if it already exists.
DROP TABLE IF EXISTS customers;

-- Create the customers table to store customer-related information.
CREATE TABLE customers (
  customer_id VARCHAR(10) PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  city VARCHAR(50) NOT NULL,
  city_tier INT NOT NULL,
  signup_date DATE NOT NULL,
  acquisition_source VARCHAR(20) NOT NULL
);

-- Create the products table to store product-related information.
CREATE TABLE products (
  product_id VARCHAR(10) PRIMARY KEY,
  product_name VARCHAR(100) NOT NULL,
  category VARCHAR(30) NOT NULL,
  price DECIMAL(10,2) NOT NULL
);

-- Create the orders table to store customer purchase and return-related information.
CREATE TABLE orders (
  order_id VARCHAR(10) PRIMARY KEY,
  customer_id VARCHAR(10) NOT NULL,
  product_id VARCHAR(10) NOT NULL,
  order_date DATE NOT NULL,
  quantity INT NOT NULL,
  discount_pct INT,
  payment_method VARCHAR(10) NOT NULL,
  rating INT,
  returned INT NOT NULL DEFAULT 0,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);
