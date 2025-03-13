CREATE DATABASE amazon;
USE amazon;

CREATE TABLE amazon_orders (
    order_ID VARCHAR(50),
    date DATE,
    ship_status VARCHAR(50),
    fullfilment VARCHAR(50),
    service_level VARCHAR(50),
    style VARCHAR(100),
    sku VARCHAR(50),
    product_category VARCHAR(100),
    size VARCHAR(50),
    asin VARCHAR(50),
    courier_ship_status VARCHAR(50),
    order_quantity INT,
    order_amount DECIMAL(10,2),
    city VARCHAR(100),
    state VARCHAR(100),
    zip VARCHAR(20),
    promotion VARCHAR(10000),
    customer_type VARCHAR(50)
);

LOAD DATA INFILE 'E:/Project/e-commerce/amazon_data.csv'
INTO TABLE amazon_orders
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT * FROM amazon_orders;

-- Total Revenue
SELECT 
    SUM(order_amount) AS Total_Revenue, 
    COUNT(*) AS Total_Orders
FROM amazon_orders
WHERE order_quantity > 0;

SELECT 
   ROUND(SUM(order_amount) / 1000000, 2) AS Total_Revenue_Million, 
    COUNT(*) AS Total_Orders
FROM amazon_orders
WHERE order_quantity > 0;

-- Top-Selling Products
SELECT 
    product_category, 
    SUM(order_amount) AS Total_Sales
FROM amazon_orders
GROUP BY product_category
ORDER BY Total_Sales DESC
LIMIT 5;

-- Finding Cancellation Impact
SELECT 
    ship_status AS Status, 
    COUNT(*) AS Total_Orders, 
    ROUND(SUM(order_amount)/ 1000000,2) AS Revenue_Loss_Million
FROM amazon_orders
WHERE ship_status = 'Cancelled'
GROUP BY ship_status;

-- Average Order Value
SELECT 
    ROUND(SUM(order_amount) / COUNT(*),2) AS Average_Order_Value
FROM amazon_orders;

--  Finding Return Impact
SELECT 
    product_category AS Category, 
    COUNT(*) AS Total_Returns, 
    SUM(order_amount) AS Total_Return_Amount
FROM amazon_orders
WHERE ship_status IN ('shipped - returning to seller', 'shipped - returned to seller', 'shipped - rejected by buyer')
GROUP BY product_category
ORDER BY Total_Return_Amount DESC
LIMIT 3;

-- Identify Underperforming Cities & Boost Sales
SELECT 
    city AS Ship_City, 
    SUM(order_amount) AS City_Sales
FROM amazon_orders
WHERE order_amount > 0  -- Exclude cities with zero sales
GROUP BY city
ORDER BY City_Sales ASC
LIMIT 10;



