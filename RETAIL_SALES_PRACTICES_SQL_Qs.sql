Retail sales Analysis USing SQL Project
Table Relationships
Sales (Fact Table)
------------------
CustomerKey  ------> Customers.CustomerKey
ProductKey   ------> Products.ProductKey
StoreKey     ------> Stores.StoreKey
Currency Code -----> Exchange Rates.Currency
Order Date   ------> Exchange Rates.Date
________________________________________
Exchange Rate Logic
The Exchange Rates table contains
Date	Currency	Exchange
2024-01-01	USD	1
2024-01-01	EUR	0.92
2024-01-01	GBP	0.79
2024-01-01	INR	83.10

Meaning
1 USD = Exchange Local Currency
Example
1 USD = 83.10 INR
Therefore
Local Currency
Local Amount = USD Amount * Exchange
Example
100 USD

100 × 83.10

= 8310 INR
________________________________________
USD Amount
USD Amount = Local Amount / Exchange
Example
8310 INR

8310 / 83.10

=100 USD
________________________________________
Assume
Sales Amount USD

= Quantity * Unit Price USD
________________________________________
Question 1
Interview Question: Write a query to display every sales order along with the corresponding customer name, product name, and quantity purchased.
Expected Output (Columns):
Output Column
Order Number
Name
Product Name
Quantity


---------------------------------------------------------------------------------------------------------------------------
select [Order_Number],[Name] ,[Product_Name],[Quantity]from [dbo].[Sales]as s
left join [dbo].[Customers] as c
on s.[CustomerKey]=c.[CustomerKey]
left join [dbo].[Products]as p
on s.[ProductKey]=p.[ProductKey]

-----------------------------------------------------------------------------------------------------------------------------------------------------------
Question 2
Interview Question: Write a query to display, for every sale, the customer name, customer country, product name, product category, and quantity sold.
Expected Output (Columns):
Output Column
Name
Country
Product Name
Category
Quantity

-------------------------------------------------------------------------------
select [Name] ,[Country],[Product_Name],[Category],[Quantity]from [dbo].[Sales] as s
left  join [dbo].[Customers] as c
on s.[CustomerKey]=c.[CustomerKey]
left join [dbo].[Products]as p
on s.[ProductKey]=p.[ProductKey]
---------------------------------------------------------------------------------------------------------------------------------------------------------------
Question 3
Interview Question: Write a query to calculate the total quantity sold for each combination of store country and product category.
Expected Output (Columns):
Output Column
Country
Category
TotalQty

------------------------------------------------------------------------
select[Country],[Category] ,sum([Quantity] ) as totalqty 
from [dbo].[Sales] as s
 left join
[dbo].[Customers] as c
on s.[CustomerKey]=c.[CustomerKey] 
left join [dbo].[Products] as p
on s.[ProductKey]=p.[ProductKey]
group by c.[Country],
p.[Category]

----------------
select[Country],[Category] ,sum([Quantity] ) as totalqty 
from [dbo].[Customers] as c
 right join
 [dbo].[Sales] as s
on c.[CustomerKey]=s.[CustomerKey] 
left join [dbo].[Products] as p
on p.[ProductKey]=s.[ProductKey]
group by c.[Country],
p.[Category]
---------------------------------------------------------------------------------------------------------------------------------------
Question 4
Interview Question: Write a query to calculate the total sales revenue (in USD) generated across all orders.
Expected Output (Columns):
Output Column
TotalSalesUSD

------------------------------------

SELECT sum( [Quantity]*[Unit_Price_USD]) AS TotalSalesUSD
FROM Sales as s
left join [dbo].[Products] as p
on s.[ProductKey]=p.[ProductKey]
---------------------------------------------------------------------------------------------------------------------------------------
Question 5
Interview Question: Write a query to calculate total sales converted into each orders local currency, using the exchange rate matched by currency code and order date.
Expected Output (Columns):
Output Column
Order Number
Currency Code
LocalSales
--------------------------------------------------------------------------------------------------------------------------------------------
   
	select [Order_Number], [Currency_Code],
	sum([Quantity]*[Order_Number])as localsales  from[dbo].[Sales] as s
	group by [Order_Number],[Currency_Code]
	
-------------------------------------------------------------------------------------------------------------------------------------------------
Question 6
Interview Question: Write a query to display, for each order, the total sales in both USD and the local currency side by side.
Expected Output (Columns):
Output Column
Order Number
SalesUSD
LocalSales
-------------------------------------
select[Unit_Price_USD] ,
sum([Quantity]*[Unit_Price_USD]) as localsales from[dbo].[Products] as p
left join[dbo].[Sales] as s
on p.[ProductKey]=s.[ProductKey]
group by p.[Unit_Price_USD]
------------------------------------------------------------------------------------------------------------------------------------------------
Question 7
Interview Question: Assume the Sales table stores the order amount in local currency. Write a query to convert this local currency amount into USD for each order using the applicable exchange rate.
Expected Output (Columns):
Output Column
Order Number
USDAmount
--------------------
select [Order_Number], sum([Quantity]*[Unit_Price_USD]) as usd_amount, [Currency_Code]from[dbo].[Sales] as s right join [dbo].[Products]  as p
on s.[ProductKey]=p.[ProductKey]
group by s. [Order_Number],s.[Currency_Code]
-----------------------------------------------------------------------------------------------------------------------------------------
Question 8
Interview Question: Write a query to identify the top 10 customers ranked by total sales revenue.
Expected Output (Columns):
Output Column
Name
Sales
------------------------------------
select  top 10 [Name], sum([Quantity]*[Order_Number]) as sales from [dbo].[Customers]as c
left join [dbo].[Sales] as s
on c.[CustomerKey]=s.[CustomerKey]
group by c.[Name]
-----------------------------------------------------------------------------------------------------------------------------------------------
Question 10
Interview Question: Write a query to calculate the number of days taken to deliver each order, along with the customer name.
Expected Output (Columns):
Output Column
Order Number
DeliveryDays
Name

----------------------------
select [Name] ,[Order_Number],datepart(dd,[Delivery_Date]) as delivary_days from [dbo].[Sales] as s
left join [dbo].[Customers] as c
on s.[CustomerKey]=c.[CustomerKey]


select * from[dbo].[Sales]
--------------------------------------------------------------------------------------------------------------------------------------------------
Question 11
Interview Question: Write a query to calculate the average order delivery time (in days) for each customer country.
Expected Output (Columns):
Output Column
Country
AvgDays
--------------------------------
select [Country],avg(datediff(dd,[Order_Date],[Delivery_Date])) as avg_days  from[dbo].[Customers]as c
left join [dbo].[Sales] as s
on c.[CustomerKey]=s.[CustomerKey]
group by c.[Country]
--------------------------------------------------------------------------------------------------------------------------------------------------
Question 12
Interview Question: Write a query to identify the top 5 product brands ranked by total revenue.
Expected Output (Columns):
Output Column
Brand
Revenue
----------------------------
select top 5 [Brand],sum(([Unit_Cost_USD]*[Unit_Price_USD]))as revenue,
from [dbo].[Products]
group by [Brand]
order by revenue desc
------------------------------------------------------------------------------------------------------------------------------------------------------
Question 13
Interview Question: Write a query to identify the single store that has generated the highest total revenue.
Expected Output (Columns):
Output Column
StoreKey
Revenue

------------------------------------------------
select se.[StoreKey],([Quantity]*[Unit_Price_USD]) as revenue from[dbo].[Stores] as se
left join [dbo].[Sales] as s
on se.[StoreKey]=s.[StoreKey]
left join [Products]as p
on s.[ProductKey]=p.[ProductKey]
group by se.[StoreKey],s.[Quantity],p.[Unit_Price_USD]
----------------------------------------------------------------------------------------------------------------------------------------------------
Question 14
Interview Question: Write a query to calculate the total profit generated by each product category.
Expected Output (Columns):
Output Column
Category
Profit
-----------
select [Category] ,sum(([Unit_Cost_USD]-[Unit_Price_USD]))as profit from [dbo].[Products]
group by [Category]
--------------------------------------------------------------------------------------------------------------------------------------------------
Question 15
Interview Question: Write a query to calculate the total profit generated by customers in each country.
Expected Output (Columns):
Output Column
Country
Profit
-----------------------------------------------------------
select [Country],sum([Unit_Cost_USD]-[Unit_Price_USD]) as profit from [dbo].[Customers] as c
inner join [dbo].[Products]as p
on c.
------------------------------------------------------------------------------------------------------------------------------
Question 16
Interview Question: Write a query to identify the top 3 best-selling products (by revenue) within each product category, using a ranking window function such as ROW_NUMBER(), RANK(), or DENSE_RANK().
Expected Output (Columns):
Output Column
Category
Product Name
Revenue
Rank
 -----------------

 WITH ProductRevenue AS
(
    SELECT
        p.Category,
        p.Product_Name,
        SUM(s.Quantity * p.Unit_Price_USD) AS Revenue
    FROM Products p
    JOIN Sales s
        ON p.ProductKey = s.ProductKey
    GROUP BY
        p.Category,
        p.Product_Name
)
SELECT TOP 3
    Category,
    Product_Name,
    Revenue,
    RANK() OVER(ORDER BY Revenue DESC) AS Rank
FROM ProductRevenue;
-----------------------------------------------------------------------------------------------------------------------------------------
Interview Question: Write a query to calculate each customers age at the time they placed each order.
Expected Output (Columns):
Output Column
Name
Age
----------------------
select [Name],datediff(yyyy,[Birthday],getdate()) as age from[dbo].[Customers]
-------------------------------------------------------------------------------------------------------------------------------------------------
Question 18
Interview Question: Write a query to identify customers who have made purchases from more than one store.
Expected Output (Columns):
Output Column
Name
StoresVisited
---------------------------
SELECT
    CustomerKey,
    COUNT(DISTINCT StoreKey) AS Storevisited
FROM Sales
GROUP BY CustomerKey
HAVING COUNT(DISTINCT StoreKey) > 1;
--------------------------------------------------------------------------------------------------------------------------------
Question 19
Interview Question: Write a query to calculate total revenue generated by each store, grouped by store country and state.
Expected Output (Columns):
Output Column
Country
State
Revenue

--------------------------------------
select 
    st.Country,
    st.State,
    SUM(s.Quantity * p.Unit_Price_USD) AS Revenue
FROM Stores st
JOIN Sales s
    ON st.StoreKey = s.StoreKey
JOIN Products p
    ON s.ProductKey = p.ProductKey
GROUP BY
    st.Country,
    st.State;

-------------------------------------------------------------------------------------------------------------------------------------------------------
Question 20
Interview Question: Write a query to calculate total revenue generated on each continent.
Expected Output (Columns):
Output Column
Continent
Revenue
------------------------------------
select 
c.[Continent],sum(( [Quantity]*[Unit_Price_USD])) as revenue from [dbo].[Sales]as s
join
[dbo].[Products] as p
on s.[ProductKey]=p.[ProductKey]
join [dbo].[Customers] as c
   on s.[CustomerKey]=c.[CustomerKey] 
   group by c. [Continent]
   -----------------------------------------------------------------------------------------------------------------------------------------------
   Question 21
Interview Question: Write a query to identify repeat customers, i.e., customers who have placed more than one order.
Expected Output (Columns):
Output Column
Name
TotalOrders
-----------------------------------
SELECT
    c.Name,
    COUNT(s.Order_number) AS TotalOrders
FROM Customers c
JOIN [dbo].[Sales]as s
    ON c.CustomerKey = s.CustomerKey
GROUP BY
    c.Name
HAVING COUNT(s.Order_number) > 1;

-------------------------------------------------------------------------------
Question 22
Interview Question: Write a query to identify customers who have purchased products from more than one product category.
Expected Output (Columns):
Output Column
Name
CategoriesPurchased
select * from sales
------------------------------------------------------------------
select [Category],count(distinct [Category])  as Category_purchased from [dbo].[Products]
group by [Category]
having count([Category])>1
--------------------------------------------------------------------------------------------------------------------------------------------------
Question 23
Interview Question: Write a query to calculate total monthly sales revenue for each country.
Expected Output (Columns):
Output Column
SalesYear
SalesMonth
Country
SalesUSD
-----------------------
select sum([Quantity]*[Unit_Price_USD]) as  salesusd,
year (s.[Order_Date]) as salesyear,
month(s.[Order_Date]) as salesmonth,
st.[Country] from [dbo].[Sales] as s
join [dbo].[Products] as p
on s.[ProductKey]=p.[ProductKey]
join [dbo].[Stores] as st
on s.[StoreKey]=st.[StoreKey]

group by s.[Order_Date],s.[Order_Date],st.[Country]
---------------------------------------------------------------------------------------------------------------------------------------------
Question 24
Interview Question: Write a query to identify the top-selling product (by quantity) in each country.
Expected Output (Columns):
Output Column
Country
Product Name
TotalQty
select * from [dbo].[Products]
----------------------------------
select  s.[Quantity] as totalqty,p.[Product_Name],st.[Country] from[dbo].[Sales] as s
join [dbo].[Products] as p
on s.[ProductKey]=p.[ProductKey]
join[dbo].[Stores]as st
on s.[StoreKey]=st.[StoreKey]
group by s.[Quantity],p.[Product_Name],st.[Country]
order by totalqty
----------------------------------------------------------------------------------------------------------------------------------------------
Question 25
Interview Question: Write a query to calculate revenue, cost, profit, profit percentage, and revenue in local currency for each country.
Expected Output (Columns):
Output Column
Country
RevenueUSD
CostUSD
ProfitUSD
ProfitPercentage
RevenueLocalCurrency
----------------------------------------------
select [Unit_Cost_USD], sum(([Unit_Cost_USD]-[Unit_Price_USD]))as profit,([Quantity]*[Unit_Price_USD]) as revenue,[Country],
 ((Unit_Price_USD - Unit_Cost_USD) * 100.0 / Unit_Cost_USD) AS ProfitPercentage
from [dbo].[Stores] as st
join [dbo].[Sales] as s
on st.[StoreKey]=s.[StoreKey]
join [dbo].[Products] as p
on s.[ProductKey]=p.[ProductKey]
group by [Unit_Cost_USD],[Unit_Price_USD],[Country],[Quantity]
-----------------------------------------------------------------------------------------------------------------------------------------
Question 26
Interview Question: The marketing team wants to identify high-value customers for a loyalty program. Write a query to display each customers name, country, total number of orders, total quantity purchased, and total sales in USD, sorted by highest sales.
Expected Output (Columns):
Output Column
Name
Country
TotalOrders
TotalQuantity
TotalSalesUSD
-------------------------------------
select c. [Name],c.[Country],count(s.[Order_Date]) as totalorders,sum( s.[Quantity]) as totalqty,sum(s.[Quantity]*p.[Unit_Cost_USD]) as totalsalesusd from [dbo].[Customers] as c
join [dbo].[Sales] as s
on c.[CustomerKey]=s.[CustomerKey]
join [dbo].[Products] as p
on s.[ProductKey]=p.[ProductKey]
group by c. [Name],c.[Country],

-----------------------------------------------------------------------------------------------------------------------------------------------------
Question 27
Interview Question: The procurement department wants to identify products with the highest profit contribution. Write a query to 
display product name, brand, revenue, cost, and profit, sorted by profit in descending order.
Expected Output (Columns):
Output Column
Product Name
Brand
Revenue
Cost
Profit
--------------------------------
select p. [Product_Name],p.[Brand],(s.[Quantity]*p.[Unit_Price_USD]) as revenue ,p.[Unit_Cost_USD] as cost,([Unit_Cost_USD]-[Unit_Price_USD]) as profit
from [dbo].[Products] as p
join [dbo].[Sales] as s
on p.[ProductKey]=s.[ProductKey]

-----------------------------------------------------------------------------------------------------------------------------------
Question 28
Interview Question: Management wants to know which stores are generating the highest sales. Write a query to display total revenue for every store along with store country, state, and store size (square meters).
Expected Output (Columns):
Output Column
Country
State
Square Meters
Revenue
---------------------------
WITH StoreRevenue AS
(
    SELECT
        st.Country,
        st.State,
        st.Square_Meters,
        SUM(s.Quantity * p.Unit_Price_USD) AS Revenue
    FROM Stores as st
    JOIN Sales as  s
        ON st.StoreKey = s.StoreKey
    JOIN Products as p
        ON s.ProductKey = p.ProductKey
    GROUP BY
        st.Country,
        st.State,
        st.Square_Meters
)
SELECT *
FROM StoreRevenue
ORDER BY Revenue DESC;
-----------------------------------------------------------------------------------------------------------------------------------------
Question 29
Interview Question: The CEO wants to identify the best-selling product category in each country. Write a query to display the top-selling category (by revenue) for every customer country.
Expected Output (Columns):
Output Column
Country
Category
Revenue
-----------------------------------------------------------------------------------------
select c.[Country],p.[Category],(s.[Quantity]*p.[Unit_Price_USD])as revenue ,
rank() over ( partition by [Category] order by [Country] desc) as rnk from [dbo].[Products] as p
join[dbo].[Sales] as s
 on p.[ProductKey]=s.[ProductKey]
 join [dbo].[Customers] as c
 on s.[CustomerKey]=c.[CustomerKey]
-----------------------------------------------------------------------------------------------------------------------------------------------
Question 30
Interview Question: Finance wants to calculate revenue in each customers local currency. Write a query to 
display order number, customer name, currency code, revenue in USD, and revenue in local currency.
Expected Output (Columns):
Output Column
Order Number
Name
Currency Code
RevenueUSD
RevenueLocal
-------------------------------------------------------------------------------------------------
select s. [Order_Number],c.name,s.[Currency_Code],

----------------------------------------------------------------------------------------------------------------------------------------------
Question 31
Interview Question: Write a query to find customers who have purchased products from at least three different brands.
Expected Output (Columns):
Output Column
Name
BrandsPurchased

------------------------------------------
SELECT
    c.Name,
    COUNT(DISTINCT p.Brand) AS BrandsPurchased
FROM Customers c
JOIN Sales s
    ON c.CustomerKey = s.CustomerKey
JOIN Products p
    ON s.ProductKey = p.ProductKey
GROUP BY
    c.Name
HAVING
    COUNT(DISTINCT p.Brand) >= 3;
-----------------------------------------------------------------------------------------------------------------------------------
Question 32
Interview Question: Write a query to calculate the average order value for each country.
Expected Output (Columns):
Output Column
Country
AvgOrderValue
---------------------------------
SELECT
    c.Country,
    AVG(s.Quantity * p.Unit_Price_USD) AS AvgOrderValue
FROM Customers c
JOIN Sales s
    ON c.CustomerKey = s.CustomerKey
JOIN Products p
    ON s.ProductKey = p.ProductKey
GROUP BY
    c.Country;
-------------------------------------------------------------------------------------
Question 33
Interview Question: Write a query to find the oldest customer (by birthday) who has placed at least one order.
Expected Output (Columns):
Output Column
Name
Country
Birthday
------------------------
select top 1 [Name],[Country],[Birthday] from[dbo].[Customers]
group by [Country],name,[Birthday]
order  by [Birthday] asc
---------------------------------------------------------------------------------------------------------------------
Question 34
Interview Question: Write a query to display yearly revenue for each product category.
Expected Output (Columns):
Output Column
SalesYear
Category
Revenue
-----------------------------------------------------------------
select p.[Category],(s.[Quantity]*p.[Unit_Price_USD]) as revenue, datepart(yyyy,[Order_Date]) as sales_year from[dbo].[Products]  as p
inner join[dbo].[Sales] as s
on p.[ProductKey]=s.[ProductKey]

-------------------------------------------------------------------------------------------------------------------------------------------------------
Question 35
Interview Question: Write a query to identify products that have never been sold.
Expected Output (Columns):
Output Column
ProductKey
Product Name
-----------------------------------------------------------------------------------------------
SELECT
    p.ProductKey,
    p.Product_Name
FROM Products p
LEFT JOIN Sales s
    ON p.ProductKey = s.ProductKey
WHERE s.ProductKey IS NULL;
------------------------------------------------------------------------------------------------------------------------------------------------
Question 36
Interview Question: Write a query to identify stores that have never processed an order.
Expected Output (Columns):
Output Column
StoreKey
Country
State
------------------------------
select st. [StoreKey],st.[Country],st.[State] from[dbo].[Stores] as st
left join [dbo].[Sales] as s
on st.[StoreKey]=s.[StoreKey]
where s.[StoreKey] is null
-----------------------------------------------------------------------------------------------------------------------------------------------------------
Question 37
Interview Question: Write a query to display monthly revenue for each product brand.
Expected Output (Columns):
Output Column
SalesYear
SalesMonth
Brand
Revenue
--------------------------------------------------------------------------------------------
select year(s.[Order_Date]) as sale_year,month(s.[Order_Date]) as sale_month ,p.[Brand],(s.[Quantity]*p.[Unit_Price_USD]) as revenue
from [dbo].[Products] as p
 left join [dbo].[Sales] as s
on p. [ProductKey]=s.[ProductKey]
 ----------------------------------------------------------------------------------------------------------------------
 Question 38
Interview Question: Write a query to identify customers whose total spending exceeds the overall average customer spending.
Expected Output (Columns):
Output Column
Name
Sales
-------------------------------------
	SELECT
    c.Name,
    SUM(s.Quantity * p.Unit_Price_USD) AS TotalSpending
FROM Customers c
JOIN Sales s
    ON c.CustomerKey = s.CustomerKey
JOIN Products p
    ON s.ProductKey = p.ProductKey
GROUP BY
    c.Name;

------------------------------------------------------------------------------------------------------------------------------------
Question 39
Interview Question: Write a query to rank all stores based on their total revenue.
Expected Output (Columns):
Output Column
StoreKey
Country
Revenue
StoreRank
-----------------------

WITH StoreRevenue AS
(
    SELECT
        st.StoreKey,
        st.Country,
        SUM(s.Quantity * p.Unit_Price_USD) AS Revenue
    FROM Stores st
    JOIN Sales s
        ON st.StoreKey = s.StoreKey
    JOIN Products p
        ON s.ProductKey = p.ProductKey
    GROUP BY
        st.StoreKey,
        st.Country
)
SELECT
    StoreKey,
    Country,
    Revenue,
    RANK() OVER(ORDER BY Revenue DESC) AS StoreRank
FROM StoreRevenue;
---------------------------------------------------------------------------------------------------
Question 40
Interview Question: Write a query to calculate each customers percentage contribution to total company revenue.
Expected Output (Columns):
Output Column
Name
Revenue
ContributionPercent

-------------------
WITH CustomerRevenue AS
(
    SELECT
        c.Name,
        SUM(s.Quantity * p.Unit_Price_USD) AS Revenue
    FROM Customers c
    JOIN Sales s
        ON c.CustomerKey = s.CustomerKey
    JOIN Products p
        ON s.ProductKey = p.ProductKey
    GROUP BY c.Name
)
SELECT
    Name,
    Revenue,
    (Revenue * 100.0 / SUM(Revenue) OVER()) AS ContributionPercent
FROM CustomerRevenue;
--------------------------------------
Question 41
Interview Question: The Operations Manager wants to identify which stores consistently deliver orders the fastest. Write a query to display store key, country, state, total orders, and average delivery days, sorted by the fastest delivery time.
Expected Output (Columns):
Output Column
StoreKey
Country
State
TotalOrders
AvgDeliveryDays

------------------------
with delivery
SELECT
    st.StoreKey,
    st.Country,
    st.State,
    COUNT(s.Order_Number) AS TotalOrders,
    AVG(DATEDIFF(DAY, s.Order_Date, s.Delivery_Date)) AS AvgDeliveryDays
FROM Stores st
JOIN Sales s
    ON st.StoreKey = s.StoreKey
GROUP BY
    st.StoreKey,
    st.Country,
    st.State
ORDER BY
    AvgDeliveryDays ASC;

	-------------------------------------------------------------------------------------
	Question 42
Interview Question: Management wants to investigate stores with poor delivery performance. Write a query to display the top 5 stores with the highest average delivery days.
Expected Output (Columns):
Output Column
StoreKey
Country
State
AvgDeliveryDays
-------------------
with delivery
SELECT
    st.StoreKey,
    st.Country,
    st.State,
    ------------COUNT(s.Order_Number) AS TotalOrders,---------------
    AVG(DATEDIFF(DAY, s.Order_Date, s.Delivery_Date)) AS AvgDeliveryDays
FROM Stores st
JOIN Sales s
    ON st.StoreKey = s.StoreKey
GROUP BY
    st.StoreKey,
    st.Country,
    st.State
ORDER BY
    AvgDeliveryDays ASC;
-----------------------------------------------------------------------------------------------------------
Question 43
Interview Question: Finance wants to know which product categories generate the highest profit margin. Write a query to display category, revenue, cost, profit, and profit percentage, sorted by profit percentage in descending order.
Expected Output (Columns):
Output Column
Category
Revenue
Cost
Profit
ProfitPercentage
--------------------------------
select p.[Category],(s.[Quantity]*p.[Unit_Price_USD]) as revenue,p.[Unit_Cost_USD] as cost,(p.[Unit_Cost_USD]-[Unit_Price_USD]) profit,
(p.[Unit_Cost_USD]-p.[Unit_Price_USD])*100/([Unit_Price_USD]) as profitpersentage
from[dbo].[Products] as p
join [dbo].[Sales] as s
on p. [ProductKey]=s.[ProductKey]
----------------------------------------------------------------------------------------------------------
Question 44
Interview Question: Marketing wants to know which brands dominate each country. Write a query to display the top 5 brands
(by revenue) within each country, along with their rank.
Expected Output (Columns):
Output Column
Country
Brand
Revenue
RN
--------------------------------------------------
with high as(
      select 
       c. [Country],
       p.[Brand],
	   (s.[Quantity]*p.[Unit_Price_USD]) as revenue
	   from [dbo].[Customers] as c
	   left join [dbo].[Sales] as s
	   on c.[CustomerKey]=s.[CustomerKey]
	   left join [dbo].[Products] as p
	   on s.[ProductKey]=p.[ProductKey]
	 ----  group by [Country],[Brand],[Quantity],[Unit_Price_USD]---
)
select  top 5 [Brand],[Country],revenue,rank() over(order by [Country] desc) as rk from high
-----------------------------------------------------------------------------------------------------------------------
Question 45
Interview Question: The CFO wants to track cumulative revenue throughout the year. Write a query to display year, month, monthly revenue, and running (cumulative) revenue.
Expected Output (Columns):
Output Column
SalesYear
SalesMonth
Revenue
RunningRevenue
--------------------------------------------------------------------------
select 
WITH MonthlyRevenue AS
(
    SELECT
        YEAR(s.Order_Date) AS SalesYear,
        MONTH(s.Order_Date) AS SalesMonth,
        SUM(s.Quantity * p.Unit_Price_USD) AS Revenue
    FROM Sales s
    JOIN Products p
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
		)
     AS RunningRevenue
FROM MonthlyRevenue;
----------------------------------------------------------------------------------------------------
Question 46
Interview Question: Management wants to compare each months revenue with the previous month. Write a query to display year, month, current month revenue, previous month revenue, and month-over-month growth.
Expected Output (Columns):
Output Column
SalesYear
SalesMonth
Revenue
PreviousMonthRevenue
MoMGrowth
----------------------------------------
WITH MonthlyRevenue AS
(
    SELECT
        YEAR(s.Order_Date) AS SalesYear,
        MONTH(s.Order_Date) AS SalesMonth,
        SUM(s.Quantity * p.Unit_Price_USD) AS Revenue
    FROM Sales s
    JOIN Products p
        ON s.ProductKey = p.ProductKey
    GROUP BY
        YEAR(s.Order_Date),
        MONTH(s.Order_Date)
)

SELECT
    SalesYear,
    SalesMonth,
    Revenue,
    LAG(Revenue) OVER
    (
        ORDER BY SalesYear, SalesMonth
    ) AS PreviousMonthRevenue,

    ((Revenue - LAG(Revenue) OVER
    (
        ORDER BY SalesYear, SalesMonth
    )) * 100.0
    /
    LAG(Revenue) OVER
    (
        ORDER BY SalesYear, SalesMonth
    )) AS MoMGrowth

FROM MonthlyRevenue;

-----------------------------------------------------------------------------------------------------------
Question 47
Interview Question: Write a query to find the highest-selling product color (by quantity) within each product category.
Expected Output (Columns):
Output Column
Category
Color
Qty
RN
-----------------
WITH ColorSales AS
(
    SELECT
        p.Category,
        p.Color,
        SUM(s.Quantity) AS Qty
    FROM Products p
    JOIN Sales s
        ON p.ProductKey = s.ProductKey
    GROUP BY
        p.Category,
        p.Color
)

SELECT
    Category,
    Color,
    Qty,
    ROW_NUMBER() OVER
    (
        PARTITION BY Category
        ORDER BY Qty DESC
    ) AS RN
FROM ColorSales;
----------------------------------------------
Question 48
Interview Question: Question 48
Interview Question: Write a query to identify customers who have made purchases in more than one store country (e.g., customers who travel and shop internationally).
Expected Output (Columns):
Output Column
Name
CountriesPurchased
----------------
SELECT
    c.Name,
    COUNT(DISTINCT st.Country) AS CountriesPurchased
FROM Customers c
JOIN Sales s
    ON c.CustomerKey = s.CustomerKey
JOIN Stores st
    ON s.StoreKey = st.StoreKey
GROUP BY
    c.Name
HAVING
    COUNT(DISTINCT st.Country) > 1;
	------------------------------------------------
	Question 49
Interview Question: Marketing wants age-wise revenue insights. Write a query to calculate total revenue by customer age group (18-25, 26-35, 36-45, 46-60, 60+) at the time of purchase.
Expected Output (Columns):
Output Column
AgeGroup
Revenue
------------------------
SELECT
    CASE
        WHEN DATEDIFF(YEAR, c.Birthday, s.Order_Date) BETWEEN 18 AND 25 THEN '18-25'
        WHEN DATEDIFF(YEAR, c.Birthday, s.Order_Date) BETWEEN 26 AND 35 THEN '26-35'
        WHEN DATEDIFF(YEAR, c.Birthday, s.Order_Date) BETWEEN 36 AND 45 THEN '36-45'
        WHEN DATEDIFF(YEAR, c.Birthday, s.Order_Date) BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+'
    END AS AgeGroup,

    SUM(s.Quantity * p.Unit_Price_USD) AS Revenue

FROM Customers c
JOIN Sales s
    ON c.CustomerKey = s.CustomerKey
JOIN Products p
    ON s.ProductKey = p.ProductKey

GROUP BY
    CASE
        WHEN DATEDIFF(YEAR, c.Birthday, s.Order_Date) BETWEEN 18 AND 25 THEN '18-25'
        WHEN DATEDIFF(YEAR, c.Birthday, s.Order_Date) BETWEEN 26 AND 35 THEN '26-35'
        WHEN DATEDIFF(YEAR, c.Birthday, s.Order_Date) BETWEEN 36 AND 45 THEN '36-45'
        WHEN DATEDIFF(YEAR, c.Birthday, s.Order_Date) BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+'
    END;
--------------------------------------------------------------------------------------------------------
The CEO requires a single query to power an executive dashboard. Write a query to return total revenue (USD), total cost (USD), total profit (USD), profit percentage, total orders, total customers, total products sold, average order value, and total revenue in local currency.
Expected Output (Columns):
Output Column
TotalRevenueUSD
TotalCostUSD
TotalProfitUSD
ProfitPercentage
TotalOrders
TotalCustomers
TotalProductsSold
AverageOrderValueUSD
TotalRevenueLocalCurrency
---------------------------------------------------

   ------------------------
   SELECT
    SUM(s.Quantity * p.Unit_Price_USD) AS TotalRevenueUSD,

    SUM(s.Quantity * p.Unit_Cost_USD) AS TotalCostUSD,

    SUM((p.Unit_Price_USD - p.Unit_Cost_USD) * s.Quantity) AS TotalProfitUSD,

    (
        SUM((p.Unit_Price_USD - p.Unit_Cost_USD) * s.Quantity) * 100.0
        / SUM(p.Unit_Cost_USD * s.Quantity)
    ) AS ProfitPercentage,

    COUNT(DISTINCT s.Order_Number) AS TotalOrders,

    COUNT(DISTINCT s.CustomerKey) AS TotalCustomers,

    SUM(s.Quantity) AS TotalProductsSold,

    SUM(s.Quantity * p.Unit_Price_USD) * 1.0 
        / COUNT(DISTINCT s.Order_Number) AS AverageOrderValueUSD

FROM Sales s
JOIN Products p
    ON s.ProductKey = p.ProductKey;
