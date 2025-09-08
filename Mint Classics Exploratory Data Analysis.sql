-- Mint Classics Inventory Analysis 
use mintclassics;
-- VIEW THE TABLES STORING THE COMPANY'S DATA
SHOW TABLES;

-- Explore the products table, 5 rows just to view the fields available
SELECT * FROM products
limit 5;

-- Quick product analysis:
-- list all the products names offered by the company
SELECT productName, count(*) AS COUNT
FROM products group by productName;
-- total products  offered by the company
SELECT COUNT(DISTINCT productName) AS Total_Num_Product
FROM products;
-- Findings:
-- Mintclassics have 110 different products


-- Warehouse quick analysis
-- explore products that are stored only in one warehouse
SELECT 
    p.productCode,
    p.productName,
    p.warehouseCode
FROM products p
GROUP BY p.productCode
HAVING COUNT(DISTINCT p.warehouseCode) = 1;
-- Findings = 110 
-- Warehouse a = 25, Warehouse b = 38, Warehouse c = 24, Warehouse d = 23 
-- Warehouse b shows many exclusives, closing it might not be a good decision 
-- Warehouse d might be easier to close with minimal impact

-- Focus on warehouse b, earlier it showed feasibility but now it's a different story
-- Products available only in one warehouse
SELECT p.warehouseCode, w.warehouseName, p.productCode, p.productName
FROM products p
JOIN warehouses w ON p.warehouseCode = w.warehouseCode
GROUP BY p.warehouseCode, w.warehouseName, p.productCode, p.productName
HAVING COUNT(DISTINCT p.warehouseCode) = 1;
-- Findings:
-- 110 products are available only in one warehouse

-- Products available accross warehouses(not exclusive)
SELECT 
    p.productCode,
    p.productName,
    COUNT(DISTINCT p.warehouseCode) AS warehouse_count
FROM products p
GROUP BY p.productCode, p.productName
HAVING COUNT(DISTINCT p.warehouseCode) > 1;
-- Findings: 0
-- Each product is stored in only one warehouse, therefore eliminating any warehouse would eliminate access to all its products, unless we move those 
-- products to another warehouse


-- Distinct products by warehouse
SELECT  
    i.warehouseCode,
    w.warehouseName,
    COUNT(DISTINCT i.productCode) AS Num_Products,
    SUM(i.quantityInStock) AS Total_Quantity
FROM products i
JOIN warehouses w ON i.warehouseCode = w.warehouseCode
GROUP BY i.warehouseCode, w.warehouseName;
-- Findings
-- Again, Warehouse East(b) stores 219183 units
-- And it is the warehouse with many distinct products, 38
-- This may indicate the warehouse is not a good candidate for closure
-- If we want to close a warehouse with minimal disruption, South(d) is the best candidate.We lose fewer products and less stock.

-- The most ordered product
SELECT 
    o.productCode, 
    p.productName,
    SUM(o.quantityOrdered) AS total_quantity_ordered
FROM 
    orderdetails o
JOIN 
    products p ON o.productCode = p.productCode
GROUP BY 
    o.productCode, p.productName
ORDER BY 
    total_quantity_ordered DESC
LIMIT 5; 
-- Findings
-- 1992 Ferrari 360 Spider red is the top selling product.

-- Does the price affect sales?
SELECT 
    o.productCode, 
    p.productName,
    o.priceEach,
    SUM(o.quantityOrdered) AS Total_Quantity,
    SUM(o.priceEach * o.quantityOrdered) AS Total_Revenue
FROM orderdetails o
JOIN products p ON o.productCode = p.productCode
GROUP BY o.productCode, p.productName, o.priceEach
ORDER BY o.priceEach DESC;
-- This does not rule out non linear or category dependent relationships, only that price alone isn't a strong driver of sales
-- The revenue is high where both price and quantity sold are high, as it should.

-- Calculate the correlation, price, Total_Quantity
SELECT
  (COUNT(*) * SUM(priceEach * Total_Quantity) - SUM(priceEach) * SUM(Total_Quantity)) /
  (SQRT(COUNT(*) * SUM(POW(priceEach, 2)) - POW(SUM(priceEach), 2)) *
   SQRT(COUNT(*) * SUM(POW(Total_Quantity, 2)) - POW(SUM(Total_Quantity), 2))
  ) AS correlation_price_quantity
FROM sales_summary;
-- Findings: 
-- correlation = '0.007721579973443918' very close to 0, this further suppots the statement saying there's no linear relationship 
-- between price and sales, price alone is not a strong factor to help prioritize the product

-- Where is the lest selling product stored?
SELECT 
    p.warehouseCode,
    COUNT(*) AS num_low_selling_products
FROM (
    SELECT 
        p.productCode,
        p.warehouseCode,
        SUM(o.quantityOrdered) AS total_quantity
    FROM orderdetails o
    JOIN products p ON o.productCode = p.productCode
    GROUP BY p.productCode, p.warehouseCode
    HAVING SUM(o.quantityOrdered) < 1000
) AS low_sellers
GROUP BY warehouseCode
ORDER BY num_low_selling_products DESC;
-- Findings:
-- Warehouse B = 13 products, warehouse C = 7, A = 4, D = 4
-- Though B has low selling products, they have moderate to high revenue
-- Not a good pick for closure, despite many low sellers.The disruption to total revenue and product availability would be significant
-- Warehouse c?: next step check revenue for all

-- Revenue per warehouse(and product count)
SELECT 
    p.warehouseCode,
    COUNT(DISTINCT p.productCode) AS total_products,
    SUM(o.quantityOrdered) AS total_quantity,
    SUM(o.priceEach * o.quantityOrdered) AS total_revenue
FROM orderdetails o
JOIN products p ON o.productCode = p.productCode
GROUP BY p.warehouseCode;
-- Findings:
-- Warehouse C: least revenue, fewest products(besides D), low sales volume,and some high value 
-- products can be relocated to A or D with minimal impact
-- what about the storage? 
select warehouseCode,warehousePctCap from warehouses;
-- A = 72, B = 67, C = 50, D = 75 in percentages(capacity used)

-- Final warehouse evaluation summary -- | Warehouse | Capacity (%) | Quantity Sold  | Revenue ($)    | Recommendation   |
-- |-----------|--------------|-------------------------------- |------------------|
-- | A         | 72%          | 24,650         | 2,076,063.66   | Retain           |
-- | B         | 67%          | 35,582         | 3,853,922.49   | Retain           |
-- | C         | **50%**      | **22,933**     | **1,797,559.63*| **Close**        |
-- | D         | 75%          | 22,351         | 1,876,644.83   | Retain (Monitor) |



/*Interpretation: warehouse C  is the strongest candidate for closure, even though it showed high value products but overall it underperforms
D is worth monitoring, but C is the best candidate 
-- We can move products to A or D(same utilisation but more productive)
*/
-- A = North
-- B = East
-- C = West
-- D = South














