-- 1. Turn on local file loading feature
SET GLOBAL local_infile = 1;

-- 1. Clear out previous failed data attempts
TRUNCATE TABLE sales_customer;

-- 2. Import using standard text alignment rules

LOAD DATA LOCAL INFILE 'E:\Naga Lakshmi\Data analysis course details\Portfolio DATA ANALYSIS\Sales Performance Analytics Project\Dataset\sales_customer_dataset.txt' 
INTO TABLE sales_customer 
CHARACTER SET latin1 
FIELDS TERMINATED BY '\t' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(
  `Row ID`, `Order ID`, `Order Date`, `Ship Date`, `Ship Mode`, `Customer ID`, `Customer Name`, `Segment`, `Country`, `City`, `State`, `Postal Code`, `Region`, `Product ID`, `Category`, `Sub-Category`, `Product Name`, `Sales`, `Quantity`, `Discount`, `Profit`
);

SELECT `Row ID`, `Customer Name`, `Product Name`, `Sales`, `Profit`, `Order Year` 
FROM sales_customer 
LIMIT 10;

UPDATE sales_customer 
SET `Order Year` = CAST(RIGHT(`Order Date`, 4) AS UNSIGNED);

-- 1. Turn off safe update mode temporarily
SET SQL_SAFE_UPDATES = 0;

-- 2. Populate the Order Year column
UPDATE sales_customer 
SET `Order Year` = CAST(RIGHT(`Order Date`, 4) AS UNSIGNED);

-- 3. Turn safe update mode back on
SET SQL_SAFE_UPDATES = 1;


DESCRIBE sales_customer;

ALTER TABLE sales_customer
ADD COLUMN `Order Month` VARCHAR(20),
ADD COLUMN `Month Number` INT;

SET SQL_SAFE_UPDATES = 0;

UPDATE sales_customer
SET `Order Month` =
MONTHNAME(STR_TO_DATE(`Order Date`, '%d-%m-%Y'));

UPDATE sales_customer
SET `Month Number` =
MONTH(STR_TO_DATE(`Order Date`, '%d-%m-%Y'));

SET SQL_SAFE_UPDATES = 1;

SELECT
`Order Date`,
`Order Year`,
`Order Month`,
`Month Number`
FROM sales_customer
LIMIT 10;

SELECT
COUNT(*) AS TotalRows,
SUM(CASE WHEN `Sales` = '' OR `Sales` IS NULL THEN 1 ELSE 0 END) AS MissingSales,
SUM(CASE WHEN `Discount` = '' OR `Discount` IS NULL THEN 1 ELSE 0 END) AS MissingDiscount,
SUM(CASE WHEN `Profit` = '' OR `Profit` IS NULL THEN 1 ELSE 0 END) AS MissingProfit
FROM sales_customer;

ALTER TABLE sales_customer
MODIFY COLUMN `Sales` DECIMAL(12,4);

ALTER TABLE sales_customer
MODIFY COLUMN `Discount` DECIMAL(5,2);

ALTER TABLE sales_customer
MODIFY COLUMN `Profit` DECIMAL(12,4);

DESCRIBE sales_customer;

/*Total Sales */
SELECT ROUND(SUM(`Sales`),2) AS Total_Sales
FROM sales_customer;

/*Total Profit*/
SELECT ROUND(SUM(`Profit`),2) AS Total_Profit
FROM sales_customer;

/*Total Orders*/
SELECT COUNT(DISTINCT `Order ID`) AS Total_Orders
FROM sales_customer;

/*Average Order Value*/
SELECT
ROUND(SUM(`Sales`) / COUNT(DISTINCT `Order ID`),2) AS Average_Order_Value
FROM sales_customer;

/*Sales by Category*/
SELECT
`Category`,
ROUND(SUM(`Sales`),2) AS Total_Sales
FROM sales_customer
GROUP BY `Category`
ORDER BY Total_Sales DESC;

/*Profit by Category*/
SELECT
`Category`,
ROUND(SUM(`Profit`),2) AS Total_Profit
FROM sales_customer
GROUP BY `Category`
ORDER BY Total_Profit DESC;

/*Top 10 Products*/
SELECT
`Product Name`,
ROUND(SUM(`Sales`),2) AS Sales
FROM sales_customer
GROUP BY `Product Name`
ORDER BY Sales DESC
LIMIT 10;

/*Sales by Region*/
SELECT
`Region`,
ROUND(SUM(`Sales`),2) AS Sales
FROM sales_customer
GROUP BY `Region`
ORDER BY Sales DESC;

/*Monthly Sales Trend*/
SELECT
`Order Year`,
`Month Number`,
`Order Month`,
ROUND(SUM(`Sales`),2) AS Sales
FROM sales_customer
GROUP BY
`Order Year`,
`Month Number`,
`Order Month`
ORDER BY
`Order Year`,
`Month Number`;

/*Top 10 Customers*/
SELECT
`Customer Name`,
ROUND(SUM(`Sales`),2) AS Sales
FROM sales_customer
GROUP BY `Customer Name`
ORDER BY Sales DESC
LIMIT 10;

SELECT *
FROM sales_customer;

SELECT *
FROM sales_customer
WHERE `Row ID` BETWEEN 18 AND 25;