-- ======================================
-- ELIMINAR BASE DE DATOS SI EXISTE
-- ======================================
IF DB_ID('tienda_online') IS NOT NULL
BEGIN
    ALTER DATABASE tienda_online SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE tienda_online;
END
GO

-- ======================================
-- CREAR BASE DE DATOS
-- ======================================
CREATE DATABASE tienda_online;
GO

USE tienda_online;
GO

-- ======================================
-- ELIMINAR TABLAS EXISTENTES
-- ======================================
IF OBJECT_ID('Detalle_Pedido', 'U') IS NOT NULL DROP TABLE Detalle_Pedido;
IF OBJECT_ID('Productos', 'U') IS NOT NULL DROP TABLE Productos;
IF OBJECT_ID('Pedidos', 'U') IS NOT NULL DROP TABLE Pedidos;
IF OBJECT_ID('Clientes', 'U') IS NOT NULL DROP TABLE Clientes;
GO

-- ======================================
-- CREAR TABLAS
-- ======================================

-- Tabla Clientes
CREATE TABLE Clientes (
    cliente_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100),
    email VARCHAR(100)
);

-- Tabla Pedidos
CREATE TABLE Pedidos (
    pedido_id INT IDENTITY(1,1) PRIMARY KEY,
    cliente_id INT,
    fecha_pedido DATE,
    total DECIMAL(10, 2),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id)
);

-- Tabla Productos
CREATE TABLE Productos (
    producto_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre_producto VARCHAR(100),
    precio DECIMAL(10, 2)
);

-- Tabla Detalle_Pedido
CREATE TABLE Detalle_Pedido (
    detalle_id INT IDENTITY(1,1) PRIMARY KEY,
    pedido_id INT,
    producto_id INT,
    cantidad INT,
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(pedido_id),
    FOREIGN KEY (producto_id) REFERENCES Productos(producto_id)
);
GO

-- ======================================
-- INSERTAR REGISTROS
-- ======================================

-- Clientes
INSERT INTO Clientes (nombre, email) VALUES
('Juan Pérez', 'juan.perez@example.com'),
('María López', 'maria.lopez@example.com'),
('Carlos García', 'carlos.garcia@example.com'),
('Ana Martínez', 'ana.martinez@example.com'),
('Luis Fernández', 'luis.fernandez@example.com');

-- Productos
INSERT INTO Productos (nombre_producto, precio) VALUES
('Laptop', 800.00),
('Teléfono', 500.00),
('Tablet', 300.00),
('Auriculares', 150.00),
('Reloj', 200.00);

-- Pedidos
INSERT INTO Pedidos (cliente_id, fecha_pedido, total) VALUES
(1, '2023-07-01', 800.00),
(2, '2023-07-03', 500.00),
(1, '2023-07-05', 300.00),
(3, '2023-07-06', 150.00),
(4, '2023-07-07', 200.00);

-- Detalle_Pedido
INSERT INTO Detalle_Pedido (pedido_id, producto_id, cantidad) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(4, 4, 1),
(5, 5, 1);
GO

-- ======================================
-- CONSULTAS
-- ======================================

-- 1. Total de ventas por cliente (mayor a menor)
SELECT C.cliente_id, C.nombre, SUM(P.total) AS total_ventas
FROM Clientes C
INNER JOIN Pedidos P ON C.cliente_id = P.cliente_id
GROUP BY C.cliente_id, C.nombre
ORDER BY total_ventas DESC;

-- 2. Todos los pedidos con el nombre del cliente y el total
SELECT P.pedido_id, C.nombre AS cliente, P.fecha_pedido, P.total
FROM Pedidos P
INNER JOIN Clientes C ON P.cliente_id = C.cliente_id;


