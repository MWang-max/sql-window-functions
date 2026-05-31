-- aggregate functions
SELECT
    customer_id,
    COUNT(*) AS total_nr_orders,
    SUM(sales) AS total_sales,
    AVG(sales) AS avg_sales,
    MAX(sales) AS highest_sales,
    MIN(sales) AS lowest_sales
FROM orders
GROUP BY customer_id

SELECT
    SUM(Sales) AS TotalSales
FROM Orders

-- PARTITION BY
SELECT
    OrderID,
    OrderDate,
    ProductID,
    SUM(Sales) OVER() TotalSales,
    SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesByProducts,
    SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) SalesByProductsAndStatus
FROM Orders

-- ORDER BY
SELECT
    OrderID,
    OrderDate,
    Sales,
    RANK() OVER(ORDER BY Sales DESC) RankSales
FROM Orders

-- window frame
SELECT
    OrderID,
    OrderDate,
    OrderStatus,
    Sales,
    SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) SalesByProductsAndStatus
FROM Orders

SELECT
    OrderID,
    OrderDate,
    OrderStatus,
    Sales,
    SUM(Sales) OVER(PARTITION BY OrderStatus) TotalSales
FROM Orders
ORDER BY SUM(Sales) OVER(PARTITION BY OrderStatus) DESC

SELECT
    OrderID,
    OrderDate,
    OrderStatus,
    Sales,
    SUM(Sales) OVER(PARTITION BY OrderStatus) TotalSales
FROM Orders
WHERE ProductID IN (101, 102)

SELECT
    CustomerID,
    SUM(Sales) AS TotalSales,
    RANK() OVER(ORDER BY SUM(Sales) DESC) AS RankCustomers
FROM Orders
GROUP BY CustomerID