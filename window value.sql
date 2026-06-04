-- LEAD and LAG (access previous/next row)

SELECT 
*,
CurrentMonthSales - PreviousMonthSales AS MoM_Change,
ROUND((CurrentMonthSales - PreviousMonthSales)/PreviousMonthSales * 100, 2) AS MoM_Perc
FROM(
    SELECT
        MONTH(OrderDate) OrderMonth,
        SUM(Sales) CurrentMonthSales,
        LAG(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate)) PreviousMonthSales
        FROM Orders
        GROUP BY MONTH(OrderDate)
)t

SELECT
CustomerID,
AVG(DaysUntilNextOrder) AvgDays,
RANK() OVER (ORDER BY COALESCE(AVG(DaysUntilNextOrder), 99999999) ASC) RankAvg
FROM(
    SELECT
        OrderID,
        CustomerID,
        OrderDate AS CurrentOrder,
        LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) NextOrder,
        DATEDIFF(OrderDate, LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate)) * (-1) DaysUntilNextOrder
        FROM Orders
        ORDER BY CustomerID, OrderDate
)t 
GROUP BY CustomerID

SELECT
    MONTH(OrderDate),
    AVG(DATEDIFF(OrderDate, ShipDate) * (-1)) AvgShip
    FROM Orders
    GROUP BY MONTH(OrderDate)

SELECT
    OrderID,
    OrderDate AS CurrentOrderDate,
    LAG(OrderDate) OVER (ORDER BY OrderDate) AS PreviousOrderDate, 
    DATEDIFF(LAG(OrderDate) OVER (ORDER BY OrderDate), OrderDate) * (-1) AS NrOfDays
    FROM Orders

-- FIRST and LAST

SELECT
    OrderID,
    ProductID,
    Sales,
    FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) LowestSales, -- lowest sales for each product
    LAST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) HighestSales, -- highest sales for each product
    FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales DESC) HighestSales2, -- get highest sales without defining frame
    MIN(Sales) OVER (PARTITION BY ProductID) LowestSales2, -- get lowest sales using MIN
    MAX(Sales) OVER (PARTITION BY ProductID) HighestSales3, -- get highest sales using MAX
    Sales - FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) AS SalesDiff -- difference between sales and lowest sales
FROM Orders

