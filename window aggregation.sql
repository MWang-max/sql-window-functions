-- COUNT (number of non-nulls)
SELECT 
    OrderID, 
    OrderDate,
    COUNT(*) OVER() TotalOrders,
    COUNT(*) OVER(PARTITION BY CustomerID) OrdersByCustomers
FROM Orders

SELECT
    *,
    COUNT(1) OVER() TotalCustomers,
    COUNT(Score) OVER() TotalScores,
    COUNT(Country) OVER() TotalCountries
FROM Customers

SELECT
    OrderID,
    COUNT(*) OVER(PARTITION BY OrderID) CheckPK
FROM Orders

-- identify duplicates
SELECT
    * 
    FROM(
        SELECT
            OrderID,
            COUNT(*) OVER(PARTITION BY OrderID) CheckPK
        FROM OrdersArchive
)t WHERE CheckPK > 1

SELECT 
    OrderID,
    OrderDate,
    Sales,
    SUM(Sales) OVER() TotalSales,
    SUM(Sales) OVER(PARTITION BY ProductID) SalesByProduct
FROM Orders

SELECT 
    OrderID,
    ProductID,
    Sales,
    SUM(Sales) OVER() TotalSales,
    ROUND(Sales / SUM(Sales) OVER() * 100, 2) PercentageOfTotal
FROM Orders

SELECT
    OrderID,
    OrderDate,
    Sales,
    AVG(Sales) OVER() AvgSales,
    AVG(Sales) OVER(PARTITION BY ProductID) AvgSalesByProduct
FROM Orders

SELECT
    CustomerID,
    LastName,
    Score,
    COALESCE(Score, 0) CustomerScore,
    AVG(COALESCE(Score, 0)) OVER() AvgScore
FROM Customers

SELECT
*
FROM(
    SELECT
        OrderID,
        ProductID,
        Sales,
        AVG(Sales) OVER() AvgSales
    FROM Orders
)t Where Sales > AvgSales

SELECT
    OrderID,
    OrderDate,
    ProductID,
    Sales,
    MAX(Sales) OVER() HighestSales,
    MIN(Sales) OVER() LowestSales,
    MAX(Sales) OVER(PARTITION BY ProductID) HighestSalesByProduct,
    MIN(Sales) OVER(PARTITION BY ProductID) LowestSalesByProduct
FROM Orders

SELECT
*
FROM(
SELECT
*,
MAX(Salary) OVER() HighestSalary
FROM Employees)t 
WHERE Salary = HighestSalary

SELECT
    OrderID,
    OrderDate,
    ProductID,
    Sales,
    MAX(Sales) OVER() HighestSales,
    MIN(Sales) OVER() LowestSales,
    Sales - MIN(Sales) OVER() DeviationFromMin,
    MAX(Sales) OVER() - Sales DeviationFromMax
FROM Orders

SELECT
    OrderID,
    ProductID,
    OrderDate,
    Sales,
    AVG(Sales) OVER(PARTITION BY ProductID) AvgByProduct,
    AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) MovingAverage,
    AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) RollingAverage
FROM Orders