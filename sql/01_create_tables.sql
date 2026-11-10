CREATE DATABASE IF NOT EXISTS supersales;

USE supersales;


/* ============================================================
   CUSTOMERS
   ============================================================ */

CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(255) NOT NULL
);


/* ============================================================
   PRODUCT GROUPS
   ============================================================ */

CREATE TABLE product_groups (
    group_id VARCHAR(50) PRIMARY KEY,
    `group` VARCHAR(255),
    category VARCHAR(255)
);


/* ============================================================
   PRODUCTS
   ============================================================ */

CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    group_id VARCHAR(50),
    product_name VARCHAR(500),
    product_price DECIMAL(12,2),
    FOREIGN KEY (group_id) REFERENCES product_groups(group_id)
);


/* ============================================================
   ORDERS
   ============================================================ */

CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_date DATE,
    shipping_date DATE,
    shipping_mode VARCHAR(100),
    delivery_city VARCHAR(255),
    delivery_state VARCHAR(255),
    delivery_zip_code VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


/* ============================================================
   ORDER POSITIONS
   ============================================================ */

CREATE TABLE order_positions (
    order_position_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50),
    product_id VARCHAR(50),
    position_discount DECIMAL(10,4),
    item_quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


/* ============================================================
   ORDER RATINGS
   ============================================================ */

CREATE TABLE order_ratings (
    order_id VARCHAR(50) PRIMARY KEY,
    rating INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);


/* ============================================================
   ORDER RETURNS
   ============================================================ */

CREATE TABLE order_returns (
    order_id VARCHAR(50) PRIMARY KEY,
    next_order_free INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);


/* ============================================================
   COST FORECAST
   ============================================================ */

CREATE TABLE cost_forecast (
    cost_forecast_id VARCHAR(50) PRIMARY KEY,
    `year` VARCHAR(10),
    ship VARCHAR(100),
    sales DECIMAL(15,2),
    cost_forecast DECIMAL(15,2)
);