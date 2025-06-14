-- Tabla CLIENTES
CREATE TABLE CLIENTES (
    ID_Cliente VARCHAR(10) PRIMARY KEY,
    Nombre_Cliente VARCHAR(100),
    Direccion_Cliente VARCHAR(150),
    Ciudad_Cliente VARCHAR(100)
);

-- Tabla PEDIDOS
CREATE TABLE PEDIDOS (
    ID_Pedido INT PRIMARY KEY,
    Fecha_Pedido DATE,
    ID_Cliente VARCHAR(10),
    FOREIGN KEY (ID_Cliente) REFERENCES CLIENTES(ID_Cliente)
);

-- Tabla PRODUCTOS
CREATE TABLE PRODUCTOS (
    ID_Producto INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Producto VARCHAR(100)
);

-- Tabla DETALLES_PEDIDO
CREATE TABLE DETALLES_PEDIDO (
    ID_Detalle INT PRIMARY KEY IDENTITY(1,1),
    ID_Pedido INT,
    ID_Producto INT,
    Cantidad INT,
    Precio_Unitario DECIMAL(10,2),
    FOREIGN KEY (ID_Pedido) REFERENCES PEDIDOS(ID_Pedido),
    FOREIGN KEY (ID_Producto) REFERENCES PRODUCTOS(ID_Producto)
);

-- Inserts CLIENTES
INSERT INTO CLIENTES VALUES
('C101', 'Juan Pérez', 'Av. Principal 123', 'Lima'),
('C102', 'María Gómez', 'Calle Secundaria 456', 'Arequipa');

-- Inserts PEDIDOS
INSERT INTO PEDIDOS VALUES
(1001, '2023-05-10', 'C101'),
(1002, '2023-05-11', 'C102'),
(1003, '2023-05-12', 'C101');

-- Inserts PRODUCTOS
INSERT INTO PRODUCTOS (Nombre_Producto) VALUES
('Laptop1'), ('mouse'), ('Teclado1'), ('Monitor'), ('Impresora'), ('cartucho');

-- ID_Producto asumido: 1 to 6
-- Inserts DETALLES_PEDIDO
INSERT INTO DETALLES_PEDIDO (ID_Pedido, ID_Producto, Cantidad, Precio_Unitario) VALUES
(1001, 1, 1, 1200),  -- Laptop1
(1001, 2, 2, 25),    -- mouse
(1001, 3, 1, 50),    -- Teclado1
(1002, 4, 2, 200),   -- Monitor
(1003, 5, 1, 300),   -- Impresora
(1003, 6, 3, 40);    -- cartucho

-- Ver tablas
SELECT * FROM CLIENTES;
SELECT * FROM PEDIDOS;
SELECT * FROM PRODUCTOS;
SELECT * FROM DETALLES_PEDIDO;

-- Consulta para calcular el total por pedido (3FN)
SELECT 
    p.ID_Pedido,
    SUM(dp.Cantidad * dp.Precio_Unitario) AS Total_Pedido
FROM PEDIDOS p
JOIN DETALLES_PEDIDO dp ON p.ID_Pedido = dp.ID_Pedido
GROUP BY p.ID_Pedido;

