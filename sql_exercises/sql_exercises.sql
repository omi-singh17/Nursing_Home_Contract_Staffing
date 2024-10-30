
--------------

-- 1
SELECT
c.customer_name
, p.product_name
, SUM(s.total_amount) 

FROM Sales s
LEFT JOIN Customers c
ON s.customer_id = c.customer_id
LEFT JOIN Products p
ON s.product_id = p.prodcut_id

WHERE ((s.sale_date <= getdate()) AND (s.sale_date >= DATEADD(d,-30,GETDATE())))

GROUP BY c.customer_name, p.product_name



---------------

-- 2
SELECT 
p.category 
, SUM(s.total_amount) 

FROM Products p
LEFT JOIN Sales s
ON p.product_id = s.product_id

WHERE ((s.sale_date <= getdate()) AND (s.sale_date >= DATEADD(m,-12,GETDATE())))

GROUP BY p.category

-------

-- 3
SELECT DISTINCT
c.customer_id
, c.customer_name


FROM Sales s
LEFT JOIN Customers c
ON s.customer_id = c.customer_id

WHERE sales_region = 'West'
AND DATEPART(Year, s.sale_date) = 2023


--------------

-- 4
SELECT 

c.customer_name
, COUNT(s.sale_id) AS total_sales
, SUM(s.quantity) AS total_quantity
, SUM(s.total_amount) AS total_revenue 

FROM Sales s
LEFT JOIN Customers c
ON s.customer_id = c.customer_id
LEFT JOIN Products p
ON s.product_id = p.prodcut_id

GROUP BY c.customer_name

-----------

-- 5
SELECT TOP 3 -- Following MS SQL Server Syntax
c.customer_id
, c.customer_name
, SUM(s.total_amount) AS total_revenue 

FROM Sales s
LEFT JOIN Customers c
ON s.customer_id = c.customer_id
LEFT JOIN Products p
ON s.product_id = p.prodcut_id

WHERE DATEPART(Year, s.sale_date) = 2023

GROUP BY c.customer_id, c.customer_name
ORDER BY 3 DESC

----

-- 6
SELECT
p.product_name
, SUM(s.quantity) AS total_quantity_sold
, ROW_NUMBER() OVER(ORDER BY SUM(s.quantity) DESC)  AS rank_ 

FROM Products p
LEFT JOIN Sales s
ON p.product_id = s.product_id

WHERE DATEPART(Year, s.sale_date) = 2023

GROUP BY p.product_name

ORDER BY 2 desc

----------------------

-- 7
SELECT DISTINCT 
c.customer_name
, c.sales_region
, CASE WHEN ((c.sign_up_date <= getdate()) AND (c.sign_up_date >= DATEADD(m,-6,GETDATE()))) THEN 'New'
ELSE 'Existing'
END AS customer_category
 
 
FROM Customers c


----------------

-- 8
SELECT 
DATEPART(Month, s.sale_date) AS month_
, DATEPART(Year, s.sale_date) AS year_
, SUM(s.quantity) AS total_sales

FROM Sales s

WHERE ((s.sale_date <= getdate()) AND (s.sale_date >= DATEADD(m,-12,GETDATE())))

GROUP BY DATEPART(Month, s.sale_date) 
, DATEPART(Year, s.sale_date) 

--------------

-- 9

SELECT
p.category
, SUM(s.total_amount) AS revenue 

FROM Products p
LEFT JOIN Sales s
ON p.product_id = s.product_id

WHERE ((s.sale_date <= getdate()) AND (s.sale_date >= DATEADD(m,-6,GETDATE())))

GROUP BY p.category
HAVING SUM(s.total_amount) >=50000


-------------

-- 10

with temp AS (
SELECT
s.sales_id -- pulling to be able to refer where the values don't match
, s.total_amount
, (s.quantity * p.price) AS expected_value

FROM Sales s
LEFT JOIN Products p
ON s.product_id = p.product_id
)

SELECT
*
FROM temp t
WHERE t.total_amount != t.expected_value
