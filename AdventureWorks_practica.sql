USE AdventureWorks2022;
GO

-- Consulta 1: Información básica de empleados 
SELECT 
  p.FirstName AS 'Nombre', -- Selecciona el nombre del empleado y le asigna un alias 
  p.LastName AS 'Apellido', -- Selecciona el apellido del empleado 
  e.JobTitle AS 'Puesto', -- Selecciona el puesto/trabajo del empleado 
  e.HireDate AS 'Fecha de contratación' -- Selecciona la fecha de contratación 
FROM HumanResources.Employee e -- Tabla principal: empleados 
JOIN Person.Person p -- Une con la tabla de personas 
  ON e.BusinessEntityID = p.BusinessEntityID -- Condición de unión por ID 
ORDER BY p.LastName, p.FirstName; -- Ordena por apellido y luego nombre 

-- Consulta 2: Productos más vendidos 
SELECT TOP 10 -- Limita a 10 resultados 
  p.Name AS 'Producto', -- Nombre del producto 
  pc.Name AS 'Categoría', -- Nombre de la categoría 
  SUM(sod.OrderQty) AS 'Cantidad Vendida' -- Suma las cantidades vendidas 
FROM Sales.SalesOrderDetail sod -- Tabla de detalles de órdenes 
JOIN Production.Product p -- Une con productos 
  ON sod.ProductID = p.ProductID -- Por ID de producto 
JOIN Production.ProductSubcategory psc -- Une con subcategorías 
  ON p.ProductSubcategoryID = psc.ProductSubcategoryID 
JOIN Production.ProductCategory pc -- Une con categorías 
  ON psc.ProductCategoryID = pc.ProductCategoryID 
GROUP BY p.Name, pc.Name -- Agrupa por producto y categoría 
ORDER BY SUM(sod.OrderQty) DESC; -- Ordena por cantidad vendida (descendente) 

-- Consulta 3: Ventas por territorio 
SELECT 
  st.Name AS 'Territorio', -- Nombre del territorio
  SUM(soh.TotalDue) AS 'Total Ventas' -- Suma el total de ventas 
FROM Sales.SalesTerritory st -- Tabla de territorios 
JOIN Sales.SalesOrderHeader soh -- Une con cabeceras de órdenes 
  ON st.TerritoryID = soh.TerritoryID -- Por ID de territorio 
GROUP BY st.Name -- Agrupa por nombre de territorio 
ORDER BY SUM(soh.TotalDue) DESC; -- Ordena por ventas totales (descendente) 

-- Consulta 4: Clientes con más compras 
SELECT TOP 15 -- Limita a 15 resultados 
   p.FirstName + ' ' + p.LastName AS 'Cliente', -- Combina nombre y apellido 
   SUM(soh.TotalDue) AS 'Total Gastado' -- Suma total gastado 
 FROM Sales.Customer c -- Tabla de clientes 
 JOIN Person.Person p -- Une con personas 
   ON c.PersonID = p.BusinessEntityID -- Por ID de persona 
 JOIN Sales.SalesOrderHeader soh -- Une con cabeceras de órdenes 
   ON c.CustomerID = soh.CustomerID -- Por ID de cliente 
 GROUP BY p.FirstName + ' ' + p.LastName -- Agrupa por nombre completo 
 ORDER BY SUM(soh.TotalDue) DESC; -- Ordena por total gastado (descendente) 
 
 -- Consulta 5: Productos sin stock 
 SELECT 
   p.ProductID, -- ID del producto 
   p.Name AS 'Producto' -- Nombre del producto 
 FROM Production.Product p -- Tabla de productos 
 WHERE p.ProductID NOT IN ( -- Filtra productos que NO están 
   SELECT DISTINCT ProductID -- Selecciona IDs distintos 
   FROM Production.ProductInventory -- De la tabla de inventario 
   WHERE Quantity > 0 -- Donde haya cantidad > 0 
) 
AND p.SellEndDate IS NULL; -- Y que sigan estando a la venta 

-- Consulta 6: Ventas mensuales 
SELECT 
  YEAR(OrderDate) AS 'Año', -- Extrae el año de la fecha 
  MONTH(OrderDate) AS 'Mes', -- Extrae el mes de la fecha 
  SUM(TotalDue) AS 'Total Ventas' -- Suma el total de ventas 
FROM Sales.SalesOrderHeader -- Tabla de cabeceras de órdenes 
GROUP BY YEAR(OrderDate), MONTH(OrderDate) -- Agrupa por año y mes 
ORDER BY YEAR(OrderDate), MONTH(OrderDate); -- Ordena cronológicamente

-- Consulta 7: Empleados por departamento 
SELECT 
  d.Name AS 'Departamento', -- Nombre del departamento 
  COUNT(*) AS 'Cantidad Empleados' -- Cuenta empleados 
FROM HumanResources.Employee e -- Tabla de empleados 
JOIN HumanResources.EmployeeDepartmentHistory edh -- Une con historial de deptos 
  ON e.BusinessEntityID = edh.BusinessEntityID 
JOIN HumanResources.Department d -- Une con departamentos 
  ON edh.DepartmentID = d.DepartmentID 
WHERE edh.EndDate IS NULL -- Filtra solo asignaciones actuales 
GROUP BY d.Name -- Agrupa por nombre de departamento 
ORDER BY COUNT(*) DESC; -- Ordena por cantidad de empleados 

-- Consulta 8: Pedidos en proceso 
SELECT 
  soh.SalesOrderID, -- ID de la orden 
  soh.OrderDate, -- Fecha de la orden 
  p.FirstName + ' ' + p.LastName AS 'Cliente', -- Nombre completo cliente 
  soh.TotalDue -- Total de la orden 
FROM Sales.SalesOrderHeader soh -- Tabla de cabeceras de órdenes 
JOIN Sales.Customer c -- Une con clientes 
  ON soh.CustomerID = c.CustomerID 
JOIN Person.Person p -- Une con personas 
  ON c.PersonID = p.BusinessEntityID 
WHERE soh.Status = 1 -- Filtra solo órdenes en proceso 
ORDER BY soh.OrderDate; -- Ordena por fecha de orden 

-- Consulta 9: Productos con descuento especial 
SELECT DISTINCT -- Elimina duplicados 
  p.ProductID, -- ID del producto 
  p.Name AS 'Producto', -- Nombre del producto 
  sod.UnitPriceDiscount AS 'Descuento Unitario' -- Monto de descuento 
FROM Sales.SpecialOffer so -- Tabla de ofertas especiales 
JOIN Sales.SpecialOfferProduct sop -- Une con productos en oferta 
  ON so.SpecialOfferID = sop.SpecialOfferID 
JOIN Production.Product p -- Une con productos 
  ON sop.ProductID = p.ProductID 
JOIN Sales.SalesOrderDetail sod -- Une con detalles de órdenes 
  ON p.ProductID = sod.ProductID 
WHERE so.StartDate <= GETDATE() -- Ofertas que ya comenzaron
AND so.EndDate >= GETDATE() -- Ofertas que no han terminado 
AND sod.UnitPriceDiscount > 0 -- Con descuento aplicado 
ORDER BY sod.UnitPriceDiscount DESC; -- Ordena por descuento (mayor primero) 

-- Consulta 10: Tiempo promedio de envío 
SELECT 
  st.Name AS 'Territorio', -- Nombre del territorio 
  AVG(DATEDIFF(day, soh.OrderDate, soh.ShipDate)) AS 'Días promedio de envío' -- Calcula días promedio entre orden y envío 
FROM Sales.SalesOrderHeader soh -- Tabla de cabeceras de órdenes 
JOIN Sales.SalesTerritory st -- Une con territorios 
  ON soh.TerritoryID = st.TerritoryID 
WHERE soh.ShipDate IS NOT NULL -- Filtra órdenes ya enviadas 
GROUP BY st.Name -- Agrupa por territorio 
ORDER BY AVG(DATEDIFF(day, soh.OrderDate, soh.ShipDate)); -- Ordena por tiempo

-- Consulta 11: Historial de precios de productos 
SELECT 
  p.ProductID, -- ID del producto 
  p.Name AS 'Producto', -- Nombre del producto 
  ph.StartDate, -- Fecha inicio del precio 
  ph.EndDate, -- Fecha fin del precio (NULL si es el actual) 
  ph.ListPrice AS 'Precio' -- Precio listado 
FROM Production.Product p -- Tabla de productos 
JOIN Production.ProductListPriceHistory ph -- Une con historial de precios 
  ON p.ProductID = ph.ProductID -- Relación por ID de producto 
ORDER BY p.Name, ph.StartDate; -- Ordena por nombre y fecha inicio

-- Consulta 12: Comisiones de vendedores 
SELECT 
  p.FirstName + ' ' + p.LastName AS 'Vendedor', -- Nombre completo vendedor 
  SUM(soh.CommissionPct * soh.TotalDue) AS 'Comisión Total' -- Cálculo comisión 
FROM Sales.SalesPerson sp -- Tabla de vendedores 
JOIN HumanResources.Employee e -- Une con empleados 
  ON sp.BusinessEntityID = e.BusinessEntityID 
JOIN Person.Person p -- Une con personas 
  ON e.BusinessEntityID = p.BusinessEntityID 
JOIN Sales.SalesOrderHeader soh -- Une con órdenes
  ON sp.BusinessEntityID = soh.SalesPersonID 
GROUP BY p.FirstName + ' ' + p.LastName -- Agrupa por vendedor 
ORDER BY SUM(soh.CommissionPct * soh.TotalDue) DESC; -- Ordena por comisión

-- Consulta 13: Productos nunca vendidos 
SELECT 
  p.ProductID, -- ID del producto 
  p.Name AS 'Producto' -- Nombre del producto 
FROM Production.Product p -- Tabla de productos 
WHERE p.ProductID NOT IN ( -- Filtra productos que no están en... 
  SELECT DISTINCT ProductID -- Selecciona IDs únicos 
  FROM Sales.SalesOrderDetail -- De la tabla de detalles de órdenes 
) 
AND p.SellEndDate IS NULL; -- Y que siguen activos para venta

-- Consulta 14: Resumen de inventario 
SELECT 
  l.Name AS 'Ubicación', -- Nombre de la ubicación 
  SUM(i.Quantity) AS 'Cantidad Total', -- Suma total de inventario 
  COUNT(DISTINCT i.ProductID) AS 'Productos Diferentes' -- Conteo productos únicos 
FROM Production.Location l -- Tabla de ubicaciones 
JOIN Production.ProductInventory i -- Une con inventario 
  ON l.LocationID = i.LocationID GROUP BY l.Name -- Agrupa por ubicación 
ORDER BY SUM(i.Quantity) DESC; -- Ordena por cantidad total

-- Consulta 15: Clientes con compras recientes 
SELECT 
  p.FirstName + ' ' + p.LastName AS 'Cliente', -- Nombre completo cliente 
  MAX(soh.OrderDate) AS 'Última Compra', -- Fecha de última compra 
  COUNT(*) AS 'Total Pedidos' -- Conteo de pedidos 
FROM Sales.Customer c -- Tabla de clientes 
JOIN Person.Person p -- Une con personas 
  ON c.PersonID = p.BusinessEntityID 
JOIN Sales.SalesOrderHeader soh -- Une con órdenes 
  ON c.CustomerID = soh.CustomerID 
WHERE soh.OrderDate >= DATEADD(day, -30, GETDATE()) -- Últimos 30 días 
GROUP BY p.FirstName + ' ' + p.LastName -- Agrupa por cliente 
ORDER BY MAX(soh.OrderDate) DESC; -- Ordena por fecha reciente

-- Consulta 16: Productos con bajo stock 
SELECT 
  p.ProductID, -- ID del producto 
  p.Name AS 'Producto', -- Nombre del producto 
  i.Quantity AS 'Stock Actual', -- Cantidad en inventario 
  p.ReorderPoint AS 'Punto de Reorden' -- Nivel mínimo establecido 
FROM Production.Product p -- Tabla de productos 
JOIN Production.ProductInventory i -- Une con inventario 
  ON p.ProductID = i.ProductID WHERE i.Quantity < p.ReorderPoint -- Filtra stock bajo el punto de reorden }
ORDER BY (p.ReorderPoint - i.Quantity) DESC; -- Ordena por diferencia mayor

-- Consulta 17: Ventas por método de envío 
SELECT 
  sm.Name AS 'Método de Envío', -- Nombre del método de envío 
  COUNT(*) AS 'Total Pedidos', -- Conteo de pedidos 
  SUM(soh.TotalDue) AS 'Total Ventas' -- Suma de ventas 
FROM Purchasing.ShipMethod sm -- Tabla de métodos de envío 
JOIN Sales.SalesOrderHeader soh -- Une con órdenes 
  ON sm.ShipMethodID = soh.ShipMethodID GROUP BY sm.Name -- Agrupa por método de envío 
ORDER BY SUM(soh.TotalDue) DESC; -- Ordena por ventas totales

-- Consulta 18: Historial de empleados por departamento 
SELECT 
  p.FirstName + ' ' + p.LastName AS 'Empleado', -- Nombre completo 
  d.Name AS 'Departamento', -- Nombre departamento 
  edh.StartDate AS 'Fecha Inicio', -- Fecha inicio en depto 
  edh.EndDate AS 'Fecha Fin' -- Fecha fin (NULL si actual) 
FROM HumanResources.EmployeeDepartmentHistory edh -- Historial deptos 
JOIN HumanResources.Employee e -- Une con empleados 
  ON edh.BusinessEntityID = e.BusinessEntityID 
JOIN Person.Person p -- Une con personas 
  ON e.BusinessEntityID = p.BusinessEntityID 
JOIN HumanResources.Department d -- Une con departamentos 
  ON edh.DepartmentID = d.DepartmentID 
ORDER BY p.LastName, p.FirstName, edh.StartDate; -- Ordena por nombre y fecha

-- Consulta 19: Resumen de garantías de productos 
SELECT 
  p.ProductID, -- ID del producto 
  p.Name AS 'Producto', -- Nombre del producto 
  p.WarrantyPeriod AS 'Periodo de Garantía (meses)', -- Duración garantía 
  p.WarrantyDescription AS 'Descripción Garantía' -- Detalles garantía 
FROM Production.Product p -- Tabla de productos 
WHERE p.WarrantyPeriod IS NOT NULL -- Filtra productos con garantía 
ORDER BY p.WarrantyPeriod DESC; -- Ordena por mayor período

-- Consulta 20: Tendencias de ventas por categoría 
SELECT 
  pc.Name AS 'Categoría', -- Nombre categoría producto 
  YEAR(soh.OrderDate) AS 'Año', -- Año de la orden 
  MONTH(soh.OrderDate) AS 'Mes', -- Mes de la orden 
  SUM(sod.LineTotal) AS 'Total Ventas' -- Suma ventas 
FROM Sales.SalesOrderHeader soh -- Tabla cabeceras órdenes 
JOIN Sales.SalesOrderDetail sod -- Une con detalles 
  ON soh.SalesOrderID = sod.SalesOrderID 
JOIN Production.Product p -- Une con productos 
  ON sod.ProductID = p.ProductID 
JOIN Production.ProductSubcategory psc -- Une con subcategorías 
  ON p.ProductSubcategoryID = psc.ProductSubcategoryID 
JOIN Production.ProductCategory pc -- Une con categorías 
  ON psc.ProductCategoryID = pc.ProductCategoryID 
GROUP BY pc.Name, YEAR(soh.OrderDate), MONTH(soh.OrderDate) -- Agrupa por categoría, año y mes 
ORDER BY pc.Name, YEAR(soh.OrderDate), MONTH(soh.OrderDate); -- Ordena cronológicamente