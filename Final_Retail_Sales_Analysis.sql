
/* =========================================================
    - Total quantity sold by store country and product category
   =========================================================*/
SELECT
    st.Country,
    p.Category,
    SUM(s.Quantity) AS TotalQty
FROM Sales AS s
JOIN Stores AS st
    ON s.StoreKey = st.StoreKey
JOIN Products AS p
    ON s.ProductKey = p.ProductKey
GROUP BY
    st.Country,
    p.Category
ORDER BY
    st.Country,
    p.Category;
GO


/* =========================================================
    - Total sales in each order's local currency
   ========================================================= */

SELECT
    s.Order_Number,
    s.Currency_Code,
    SUM(s.Quantity * p.Unit_Price_USD * er.Exchange) AS LocalSales
FROM Sales AS s
JOIN Products AS p
    ON s.ProductKey = p.ProductKey
JOIN Exchange_Rates AS er
    ON s.Currency_Code = er.Currency
    AND s.Order_Date = er.Date
GROUP BY
    s.Order_Number,
    s.Currency_Code
ORDER BY
    s.Order_Number;
GO


/* =========================================================
    - Top 10 customers by total sales revenue
   ========================================================= */

SELECT TOP 10
    c.Name,
    SUM(s.Quantity * p.Unit_Price_USD) AS Sales
FROM Customers AS c
JOIN Sales AS s
    ON c.CustomerKey = s.CustomerKey
JOIN Products AS p
    ON s.ProductKey = p.ProductKey
GROUP BY
    c.Name
ORDER BY
    Sales DESC;
GO


/* =========================================================
   - Delivery days for each order with customer name
   ========================================================= */
SELECT
    s.Order_Number,
    DATEDIFF(DAY, s.Order_Date, s.Delivery_Date) AS DeliveryDays,
    c.Name
FROM Sales AS s
JOIN Customers AS c
    ON s.CustomerKey = c.CustomerKey
WHERE
    s.Delivery_Date IS NOT NULL
ORDER BY
    DeliveryDays;
GO


/* =========================================================
    - Top 3 best-selling products within each category
   ========================================================= */

WITH ProductRevenue AS
(
    SELECT
        p.Category,
        p.Product_Name,
        SUM(s.Quantity * p.Unit_Price_USD) AS Revenue
    FROM Products AS p
    JOIN Sales AS s
        ON p.ProductKey = s.ProductKey
    GROUP BY
        p.Category,
        p.Product_Name
),
RankedProducts AS
(
    SELECT
        Category,
        Product_Name,
        Revenue,
        RANK() OVER
        (
            PARTITION BY Category
            ORDER BY Revenue DESC
        ) AS ProductRank
    FROM ProductRevenue
)
SELECT
    Category,
    Product_Name,
    Revenue,
    ProductRank AS Rank
FROM RankedProducts
WHERE
    ProductRank <= 3
ORDER BY
    Category,
    Revenue DESC;
GO


/* =======================================================
- Customers who purchased from more than one category
   ========================================================= */

SELECT
    c.Name,
    COUNT(DISTINCT p.Category) AS CategoriesPurchased
FROM Customers AS c
JOIN Sales AS s
    ON c.CustomerKey = s.CustomerKey
JOIN Products AS p
    ON s.ProductKey = p.ProductKey
GROUP BY
    c.Name
HAVING
    COUNT(DISTINCT p.Category) > 1
ORDER BY
    CategoriesPurchased DESC;
GO


/* =========================================================
    - Top-selling product by quantity in each country
   ========================================================= */

WITH ProductCountrySales AS
(
    SELECT
        st.Country,
        p.Product_Name,
        SUM(s.Quantity) AS TotalQty
    FROM Sales AS s
    JOIN Products AS p
        ON s.ProductKey = p.ProductKey
    JOIN Stores AS st
        ON s.StoreKey = st.StoreKey
    GROUP BY
        st.Country,
        p.Product_Name
),
RankedProducts AS
(
    SELECT
        Country,
        Product_Name,
        TotalQty,
        RANK() OVER
        (
            PARTITION BY Country
            ORDER BY TotalQty DESC
        ) AS ProductRank
    FROM ProductCountrySales
)
SELECT
    Country,
    Product_Name,
    TotalQty
FROM RankedProducts
WHERE
    ProductRank = 1
ORDER BY
    Country;
GO


/* =========================================================
    - Revenue, cost, profit, margin and local revenue by country
   ========================================================= */

SELECT
    st.Country,
    SUM(s.Quantity * p.Unit_Price_USD) AS RevenueUSD,
    SUM(s.Quantity * p.Unit_Cost_USD) AS CostUSD,
    SUM(s.Quantity * (p.Unit_Price_USD - p.Unit_Cost_USD)) AS ProfitUSD,
    SUM(s.Quantity * (p.Unit_Price_USD - p.Unit_Cost_USD)) * 100.0
        / NULLIF(SUM(s.Quantity * p.Unit_Price_USD), 0) AS ProfitPercentage,
    SUM(s.Quantity * p.Unit_Price_USD * er.Exchange) AS RevenueLocalCurrency
FROM Sales AS s
JOIN Products AS p
    ON s.ProductKey = p.ProductKey
JOIN Stores AS st
    ON s.StoreKey = st.StoreKey
JOIN Exchange_Rates AS er
    ON s.Currency_Code = er.Currency
    AND s.Order_Date = er.Date
GROUP BY
    st.Country
ORDER BY
    RevenueUSD DESC;
GO


/* =========================================================
   - High-value customers for loyalty program
   ========================================================= */

SELECT
    c.Name,
    c.Country,
    COUNT(DISTINCT s.Order_Number) AS TotalOrders,
    SUM(s.Quantity) AS TotalQuantity,
    SUM(s.Quantity * p.Unit_Price_USD) AS TotalSalesUSD
FROM Customers AS c
JOIN Sales AS s
    ON c.CustomerKey = s.CustomerKey
JOIN Products AS p
    ON s.ProductKey = p.ProductKey
GROUP BY
    c.Name,
    c.Country
ORDER BY
    TotalSalesUSD DESC;
GO


/* =========================================================
   - Highest-revenue product category in each country
   ========================================================= */

WITH CategoryRevenue AS
(
    SELECT
        c.Country,
        p.Category,
        SUM(s.Quantity * p.Unit_Price_USD) AS Revenue
    FROM Sales AS s
    JOIN Customers AS c
        ON s.CustomerKey = c.CustomerKey
    JOIN Products AS p
        ON s.ProductKey = p.ProductKey
    GROUP BY
        c.Country,
        p.Category
),
RankedCategories AS
(
    SELECT
        Country,
        Category,
        Revenue,
        RANK() OVER
        (
            PARTITION BY Country
            ORDER BY Revenue DESC
        ) AS CategoryRank
    FROM CategoryRevenue
)
SELECT
    Country,
    Category,
    Revenue
FROM RankedCategories
WHERE
    CategoryRank = 1
ORDER BY
    Country;
GO


/* =========================================================
    - Revenue in USD and customer local currency by order
   ========================================================= */

SELECT
    s.Order_Number,
    c.Name,
    s.Currency_Code,
    SUM(s.Quantity * p.Unit_Price_USD) AS RevenueUSD,
    SUM(s.Quantity * p.Unit_Price_USD * er.Exchange) AS RevenueLocal
FROM Sales AS s
JOIN Customers AS c
    ON s.CustomerKey = c.CustomerKey
JOIN Products AS p
    ON s.ProductKey = p.ProductKey
JOIN Exchange_Rates AS er
    ON s.Currency_Code = er.Currency
    AND s.Order_Date = er.Date
GROUP BY
    s.Order_Number,
    c.Name,
    s.Currency_Code
ORDER BY
    s.Order_Number;
GO


/* =========================================================
    - Average order value for each country
   ========================================================= */

WITH OrderRevenue AS
(
    SELECT
        c.Country,
        s.Order_Number,
        SUM(s.Quantity * p.Unit_Price_USD) AS OrderValue
    FROM Sales AS s
    JOIN Customers AS c
        ON s.CustomerKey = c.CustomerKey
    JOIN Products AS p
        ON s.ProductKey = p.ProductKey
    GROUP BY
        c.Country,
        s.Order_Number
)
SELECT
    Country,
    AVG(OrderValue * 1.0) AS AvgOrderValue
FROM OrderRevenue
GROUP BY
    Country
ORDER BY
    AvgOrderValue DESC;
GO


/* =========================================================
   - Customers whose spending is above average
   ========================================================= */

WITH CustomerSpending AS
(
    SELECT
        c.CustomerKey,
        c.Name,
        SUM(s.Quantity * p.Unit_Price_USD) AS TotalSpending
    FROM Customers AS c
    JOIN Sales AS s
        ON c.CustomerKey = s.CustomerKey
    JOIN Products AS p
        ON s.ProductKey = p.ProductKey
    GROUP BY
        c.CustomerKey,
        c.Name
)
SELECT
    Name,
    TotalSpending
FROM CustomerSpending
WHERE
    TotalSpending >
    (
        SELECT AVG(TotalSpending * 1.0)
        FROM CustomerSpending
    )
ORDER BY
    TotalSpending DESC;
GO


/* =========================================================
    - Customer percentage contribution to company revenue
   ========================================================= */

WITH CustomerRevenue AS
(
    SELECT
        c.Name,
        SUM(s.Quantity * p.Unit_Price_USD) AS Revenue
    FROM Customers AS c
    JOIN Sales AS s
        ON c.CustomerKey = s.CustomerKey
    JOIN Products AS p
        ON s.ProductKey = p.ProductKey
    GROUP BY
        c.Name
)
SELECT
    Name,
    Revenue,
    Revenue * 100.0
        / NULLIF(SUM(Revenue) OVER (), 0) AS ContributionPercent
FROM CustomerRevenue
ORDER BY
    Revenue DESC;
GO


/* =========================================================
    - Top 5 stores with highest average delivery days
   ========================================================= */

SELECT TOP 5
    st.StoreKey,
    st.Country,
    st.State,
    AVG(DATEDIFF(DAY, s.Order_Date, s.Delivery_Date) * 1.0)
        AS AvgDeliveryDays
FROM Stores AS st
JOIN Sales AS s
    ON st.StoreKey = s.StoreKey
WHERE
    s.Delivery_Date IS NOT NULL
GROUP BY
    st.StoreKey,
    st.Country,
    st.State
ORDER BY
    AvgDeliveryDays DESC;
GO


/* =========================================================
    - Product categories with highest profit margin
   ========================================================= */

SELECT
    p.Category,
    SUM(s.Quantity * p.Unit_Price_USD) AS Revenue,
    SUM(s.Quantity * p.Unit_Cost_USD) AS Cost,
    SUM(s.Quantity * (p.Unit_Price_USD - p.Unit_Cost_USD)) AS Profit,
    SUM(s.Quantity * (p.Unit_Price_USD - p.Unit_Cost_USD)) * 100.0
        / NULLIF(SUM(s.Quantity * p.Unit_Price_USD), 0)
        AS ProfitPercentage
FROM Sales AS s
JOIN Products AS p
    ON s.ProductKey = p.ProductKey
GROUP BY
    p.Category
ORDER BY
    ProfitPercentage DESC;
GO


/* =========================================================
   - Top 5 brands by revenue within each country
   ========================================================= */

WITH BrandRevenue AS
(
    SELECT
        c.Country,
        p.Brand,
        SUM(s.Quantity * p.Unit_Price_USD) AS Revenue
    FROM Sales AS s
    JOIN Customers AS c
        ON s.CustomerKey = c.CustomerKey
    JOIN Products AS p
        ON s.ProductKey = p.ProductKey
    GROUP BY
        c.Country,
        p.Brand
),
RankedBrands AS
(
    SELECT
        Country,
        Brand,
        Revenue,
        RANK() OVER
        (
            PARTITION BY Country
            ORDER BY Revenue DESC
        ) AS RN
    FROM BrandRevenue
)
SELECT
    Country,
    Brand,
    Revenue,
    RN
FROM RankedBrands
WHERE
    RN <= 5
ORDER BY
    Country,
    Revenue DESC;
GO


/* =========================================================
   - Monthly revenue and cumulative running revenue
   ========================================================= */

WITH MonthlyRevenue AS
(
    SELECT
        YEAR(s.Order_Date) AS SalesYear,
        MONTH(s.Order_Date) AS SalesMonth,
        SUM(s.Quantity * p.Unit_Price_USD) AS Revenue
    FROM Sales AS s
    JOIN Products AS p
        ON s.ProductKey = p.ProductKey
    GROUP BY
        YEAR(s.Order_Date),
        MONTH(s.Order_Date)
)
SELECT
    SalesYear,
    SalesMonth,
    Revenue,
    SUM(Revenue) OVER
    (
        ORDER BY SalesYear, SalesMonth
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningRevenue
FROM MonthlyRevenue
ORDER BY
    SalesYear,
    SalesMonth;
GO


/* =========================================================
   Q46 - Month-over-month revenue growth
   ========================================================= */
-- Q46
WITH MonthlyRevenue AS
(
    SELECT
        YEAR(s.Order_Date) AS SalesYear,
        MONTH(s.Order_Date) AS SalesMonth,
        SUM(s.Quantity * p.Unit_Price_USD) AS Revenue
    FROM Sales AS s
    JOIN Products AS p
        ON s.ProductKey = p.ProductKey
    GROUP BY
        YEAR(s.Order_Date),
        MONTH(s.Order_Date)
),
RevenueWithPrevious AS
(
    SELECT
        SalesYear,
        SalesMonth,
        Revenue,
        LAG(Revenue) OVER
        (
            ORDER BY SalesYear, SalesMonth
        ) AS PreviousMonthRevenue
    FROM MonthlyRevenue
)
SELECT
    SalesYear,
    SalesMonth,
    Revenue,
    PreviousMonthRevenue,
    (Revenue - PreviousMonthRevenue) * 100.0
        / NULLIF(PreviousMonthRevenue, 0) AS MoMGrowth
FROM RevenueWithPrevious
ORDER BY
    SalesYear,
    SalesMonth;
GO
