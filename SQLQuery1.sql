-- Crear la base de datos
CREATE DATABASE Ferreteria;
GO
USE Ferreteria;
GO

-- Crear las tablas
CREATE TABLE Clientes (
    ClienteID INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100),
    Telefono NVARCHAR(15),
    Email NVARCHAR(100)
);

CREATE TABLE Productos (
    ProductoID INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100),
    Precio DECIMAL(10, 2),
    Stock INT
);

CREATE TABLE Ventas (
    VentaID INT PRIMARY KEY IDENTITY(1,1),
    ClienteID INT,
    Fecha DATETIME,
    Total DECIMAL(10, 2),
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);

CREATE TABLE DetallesVentas (
    DetalleID INT PRIMARY KEY IDENTITY(1,1),
    VentaID INT,
    ProductoID INT,
    Cantidad INT,
    PrecioUnitario DECIMAL(10, 2),
    FOREIGN KEY (VentaID) REFERENCES Ventas(VentaID),
    FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
);

-- Insertar datos de ejemplo
INSERT INTO Clientes (Nombre, Telefono, Email) VALUES  
('Juan Pérez', '555-1234', 'juan@example.com'), 
('María López', '555-5678', 'maria@example.com');

INSERT INTO Productos (Nombre, Precio, Stock) VALUES  
('Martillo', 10.00, 100), 
('Destornillador', 5.00, 200);

INSERT INTO Ventas (ClienteID, Fecha, Total) VALUES  
(1, GETDATE(), 30.00), 
(2, GETDATE(), 15.00);

INSERT INTO DetallesVentas (VentaID, ProductoID, Cantidad, PrecioUnitario) VALUES  
(1, 1, 2, 10.00), 
(1, 2, 2, 5.00), 
(2, 2, 3, 5.00);

-- Consultas de reporte
-- a) Reporte por Cliente
SELECT  
    c.Nombre, 
    COUNT(v.VentaID) AS TotalVentas,  
    SUM(v.Total) AS TotalGastado 
FROM  
    Clientes c 
JOIN  
    Ventas v ON c.ClienteID = v.ClienteID 
GROUP BY  
    c.Nombre;

-- b) Reporte por Ventas
SELECT  
    v.VentaID, 
    c.Nombre AS Cliente, 
    v.Fecha, 
    v.Total 
FROM  
    Ventas v 
JOIN  
    Clientes c ON v.ClienteID = c.ClienteID 
ORDER BY  
    v.Fecha DESC;

-- c) Reporte por Productos
SELECT  
    p.Nombre AS Producto, 
    SUM(dv.Cantidad) AS TotalVendidos, 
    SUM(dv.Cantidad * dv.PrecioUnitario) AS TotalIngresos 
FROM  
    DetallesVentas dv 
JOIN  
    Productos p ON dv.ProductoID = p.ProductoID 
GROUP BY  
    p.Nombre 
ORDER BY  
    TotalVendidos DESC;