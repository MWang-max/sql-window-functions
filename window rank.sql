-- ROW_NUMBER (does not skip ranks if there are ties and does not repeat)
SELECT
    OrderID,
    ProductID,
    Sales,
    ROW_NUMBER() OVER(ORDER BY Sales DESC) SalesRank_Row
FROM Orders

-- RANK (repeats, skips ranks if there is a tie)
SELECT
    OrderID,
    ProductID,
    Sales,
    RANK() OVER(ORDER BY Sales DESC) SalesRank_Rank
FROM Orders

-- DENSE_RANK (does not skip ranks if there is a tie - multiple of same rank followed by next rank)
SELECT
    OrderID,
    ProductID,
    Sales,
    DENSE_RANK() OVER(ORDER BY Sales DESC) SalesRank_DenseRank
FROM Orders

-- top N analysis
SELECT *
FROM(
    SELECT
        OrderID,
        ProductID,
        Sales,
        ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) RankByProduct
    FROM Orders
)t WHERE RankByProduct = 1

-- bottom N analysis
SELECT *
FROM(
    SELECT
        CustomerID,
        SUM(Sales) TotalSales,
        ROW_NUMBER() OVER(ORDER BY SUM(Sales) ASC) RankCustomers
    FROM Orders
    GROUP BY CustomerID
)t WHERE RankCustomers <= 2

-- unique IDs
SELECT 
    *, 
    ROW_NUMBER() OVER(ORDER BY OrderID, OrderDate) UniqueID
    FROM OrdersArchive

-- identify duplicates
SELECT * FROM(
    SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) rn
        FROM OrdersArchive
)t WHERE rn = 1

-- CUME_DIST (cumulative distribution - repeats position of last occurrence if there is a tie)
SELECT *,
CONCAT(DistRank * 100, '%') DistRankPerc
FROM(
    SELECT
        Product,
        Price,
        CUME_DIST() OVER(ORDER BY Price DESC) DistRank
    FROM Products
)t WHERE DistRank <= 0.4

-- PERCENT_RANK (position number - 1) / (number of rows - 1) -> repeats position o ffirst occurrence if there is tie
SELECT *,
CONCAT(DistRank * 100, '%') DistRankPerc
FROM(
    SELECT
        Product,
        Price,
        PERCENT_RANK() OVER(ORDER BY Price DESC) DistRank
    FROM Products
)t WHERE DistRank <= 0.4

-- NTILE - buckets, bucket size = number of rows/number of buckets
SELECT
    OrderID,
    Sales,
    NTILE(4) OVER(ORDER BY Sales DESC) FourBucket,
    NTILE(3) OVER(ORDER BY Sales DESC) ThreeBucket,
    NTILE(2) OVER(ORDER BY Sales DESC) TwoBucket,
    NTILE(1) OVER(ORDER BY Sales DESC) OneBucket
FROM Orders

SELECT
*,
CASE WHEN Buckets = 1 THEN 'High'
WHEN Buckets = 2 THEN 'Medium'
WHEN Buckets = 3 THEN 'Low'
END SalesSegmentations
FROM(
SELECT
    OrderID,
    Sales,
    NTILE(3) OVER(ORDER BY Sales DESC) Buckets
FROM Orders
)t

SELECT
    *, 
    NTILE(4) OVER(ORDER BY OrderID) Buckets
    FROM Orders