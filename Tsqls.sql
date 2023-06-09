  use Northwind
  -------------query to include supplires into question #1

  select     p.ProductID, S.ContactName, productname, sum(quantity) as quntitysold
  from       products as p
  inner join [Order Details]AS OD
  on         P.productid = OD.ProductID 
  inner join Suppliers as S
  on         P.SupplierID= S.SupplierID
  where      S.Country= 'USA'
  group by   ProductName, P.ProductID, ContactName
  order by   sum(Quantity) desc; 


 ------------------roprt that show orderdate , companyname, employee fistname and last name , order date
 ---------------- orderd by order date
  select     Orders.OrderID, Customers.CompanyName,
             Employees.FirstName + ' ' + Employees.LastName as [Employee full name] , 
             cast(Orders.OrderDate as nvarchar(20)) as [order date]
  from       orders 
  inner join Customers
  on         Orders.CustomerID = Customers.CustomerID
  inner join Employees
  on         Orders.EmployeeID = Employees.EmployeeID
  where      shippeddate > requireddate and OrderDate >= '1998-01-01' 
  group by   orderdate, Orders.OrderID, Customers.CompanyName, Employees.FirstName, Employees.LastName;


 -------------------statement to show number of employees and number of customers in the employees city

  select     count(  EmployeeID) as [Total employee], 
             count( customerID) as [Total Customer] , E.City
  from       Employees as E
  left join customers as C
  on         E.city= C.city
  group by   E.City;

 


 ------------------- --query to show orderid and name of employee associated for order that shipped after required date

  select     OrderID, FirstName + ' ' + LastName as [Full Name ]
  from       Orders
  inner join Employees
  on         Orders.EmployeeID = Employees.EmployeeID
  where      ShippedDate > RequiredDate

  ------------------- query to show product name and total quantity less than 200

  select     productname , sum(Quantity) as [Total Quantity]
  from       Products as p
  inner join [Order Details] AS OD
  on         p.ProductID= OD.ProductID
  group by   ProductName
  having     sum(quantity)< '200'


  -------------------statement to show total number of orders ordered by company  morethan  15 times 

  select     customers.CompanyName ,  count(Orders.CustomerID) as [company totalorders]
  from       Orders
  inner join customers
  on         orders.CustomerID=Customers.CustomerID
  where      OrderDate > '1996-12-31'
  group by   CompanyName
  having     count(Orders.CustomerID)>=15


  ---------------STATTMANT TO SHOW COMAPNY NAME, ORDERID AND TOTAL PRICE MORE THAN 10000
    
  select     C.CompanyName , orders.OrderID,(OD.UnitPrice *OD.Quantity  ) as [ Price of total ordered]
  from       [Order Details] as OD
  inner join Orders
  on         OD.OrderID = Orders.OrderID
  inner join Customers AS C
  on         Orders.CustomerID= C.CustomerID
  where      OD.UnitPrice * OD.Quantity > 10000
 group by    C.CompanyName,Orders.OrderID,UnitPrice,Quantity


  --------------statement to show number of customer and emplooyee  from each city

 select     count( distinct EmployeeID) as [Total employee], 
             count(distinct customerID) as [Total Customer] , c.City
  from       Employees as E
  inner join customers as C
  on         E.city= C.city
  group by   c.City;

 --------------------------- delete where customerid is frank
  begin tran
  delete     [Order Details]
  from       [Order Details] 
  inner join Orders	 
  on         [Order Details].OrderID = orders.orderid
  inner join Customers 
  on         Customers.CustomerID= Orders.customerid
  where      Customers.CustomerID = 'Frank'
  rollback
  --------------- select after delete and after rolled back

 select      [Order Details]. OrderID
  from       [Order Details] 
  inner join Orders	 
  on         [Order Details].OrderID = orders.orderid 
  where      Orders.CustomerID ='frank'

  ----VG

  SELECT YEAR(CreationDate) as [Year],
DATENAME(month,CreationDate) AS [MonthName],
COUNT(Id) AS [CountUsers]
FROM [dbo].[vg_Users]
GROUP BY YEAR(CreationDate), DATENAME(month,CreationDate)
ORDER BY YEAR asc