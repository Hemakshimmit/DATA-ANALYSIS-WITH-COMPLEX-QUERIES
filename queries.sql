
USE AdvancedDataAnalysis;
DROP TABLE IF EXISTS Sales;

--  Create the Sales Table
CREATE TABLE Sales (
    SaleID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT NOT NULL,
    Revenue DECIMAL(10, 2) NOT NULL,
    SaleDate DATE NOT NULL
);

--  Insert Sample Data into the Sales Table
INSERT INTO Sales (ProductID, Revenue, SaleDate)
VALUES 
    (1, 5000.00, '2025-01-01'),
    (2, 3000.00, '2025-01-02'),
    (3, 7000.00, '2025-01-03'),
    (1, 2000.00, '2025-01-04'),
    (2, 4000.00, '2025-01-05'),
    (3, 1000.00, '2025-01-06'),
    (4, 6000.00, '2025-01-07');

--  Use Common Table Expressions (CTEs) for Data Analysis
WITH ProductPerformance AS (
    SELECT 
        ProductID,
        SUM(Revenue) AS TotalRevenue,
        RANK() OVER (ORDER BY SUM(Revenue) DESC) AS `Rank`
    FROM Sales
    GROUP BY ProductID
)
SELECT * 
FROM ProductPerformance
WHERE `Rank` <= 3;

-- Use Window Functions for Advanced Insights
SELECT 
    ProductID,
    Revenue,
    SaleDate,
    SUM(Revenue) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS RunningTotal,
    ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY SaleDate) AS SaleRank
FROM Sales;

--  Subquery to Find Top Products by Revenue
SELECT 
    ProductID,
    TotalRevenue
FROM (
    SELECT 
        ProductID,
        SUM(Revenue) AS TotalRevenue
    FROM Sales
    GROUP BY ProductID
) AS Subquery
WHERE TotalRevenue > 5000;

--  Combining CTEs, Window Functions, and Subqueries
WITH ProductPerformance AS (
    SELECT 
        ProductID,
        SUM(Revenue) AS TotalRevenue,
        RANK() OVER (ORDER BY SUM(Revenue) DESC) AS `Rank`
    FROM Sales
    GROUP BY ProductID
),
DetailedSales AS (
    SELECT 
        ProductID,
        Revenue,
        SaleDate,
        SUM(Revenue) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS RunningTotal
    FROM Sales
)
SELECT 
    dp.ProductID,
    dp.TotalRevenue,
    ds.RunningTotal,
    dp.`Rank`
FROM ProductPerformance dp
JOIN DetailedSales ds ON dp.ProductID = ds.ProductID
WHERE dp.`Rank` <= 3;
