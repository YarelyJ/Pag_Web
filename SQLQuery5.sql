-- Tabla CLIENTES
CREATE TABLE CLIENTES_2FN (
    ID_Cliente VARCHAR(10) PRIMARY KEY,
    Nombre_Cliente VARCHAR(100),
    Direccion_Cliente VARCHAR(150),
    Ciudad_Cliente VARCHAR(100)
);

-- Tabla PEDIDOS
CREATE TABLE PEDIDOS_2FN (
    ID_Pedido INT PRIMARY KEY,
    Fecha_Pedido DATE,
    ID_Cliente VARCHAR(10),
    FOREIGN KEY (ID_Cliente) REFERENCES CLIENTES_2FN(ID_Cliente)
);

-- Tabla PRODUCTOS
CREATE TABLE PRODUCTOS_2FN (
    ID_Producto INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Producto VARCHAR(100)
);

-- Tabla DETALLES_PEDIDO
CREATE TABLE DETALLES_PEDIDO_2FN (
    ID_Detalle INT PRIMARY KEY IDENTITY(1,1),
    ID_Pedido INT,
    ID_Producto INT,
    Cantidad INT,
    Precio_Unitario DECIMAL(10,2),
    FOREIGN KEY (ID_Pedido) REFERENCES PEDIDOS_2FN(ID_Pedido),
    FOREIGN KEY (ID_Producto) REFERENCES PRODUCTOS_2FN(ID_Producto)
);

-- Inserts CLIENTES
INSERT INTO CLIENTES_2FN VALUES
('C101', 'Juan Pérez', 'Av. Principal 123', 'Lima'),
('C102', 'María Gómez', 'Calle Secundaria 456', 'Arequipa');

-- Inserts PEDIDOS
INSERT INTO PEDIDOS_2FN VALUES
(1001, '2023-05-10', 'C101'),
(1002, '2023-05-11', 'C102'),
(1003, '2023-05-12', 'C101');

-- Inserts PRODUCTOS
INSERT INTO PRODUCTOS_2FN (Nombre_Producto) VALUES
('Laptop1'), ('mouse'), ('Teclado1'), ('Monitor'), ('Impresora'), ('cartucho');

-- ID_Producto asumido: 1 to 6
-- Inserts DETALLES_PEDIDO
INSERT INTO DETALLES_PEDIDO_2FN (ID_Pedido, ID_Producto, Cantidad, Precio_Unitario) VALUES
(1001, 1, 1, 1200),  -- Laptop1
(1001, 2, 2, 25),    -- mouse
(1001, 3, 1, 50),    -- Teclado1
(1002, 4, 2, 200),   -- Monitor
(1003, 5, 1, 300),   -- Impresora
(1003, 6, 3, 40);    -- cartucho

-- Ver tablas (2FN)
SELECT * FROM CLIENTES_2FN;
SELECT * FROM PEDIDOS_2FN;
SELECT * FROM PRODUCTOS_2FN;
SELECT * FROM DETALLES_PEDIDO_2FN;
