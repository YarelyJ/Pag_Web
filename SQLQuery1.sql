-- Tabla PEDIDOS (1FN)
CREATE TABLE PEDIDOS_1FN (
    ID_Pedido INT PRIMARY KEY,
    Fecha_Pedido DATE,
    ID_Cliente VARCHAR(10),
    Nombre_Cliente VARCHAR(100),
    Direccion_Cliente VARCHAR(150),
    Ciudad_Cliente VARCHAR(100)
);

-- Tabla DETALLES_PEDIDO (1FN)
CREATE TABLE DETALLES_PEDIDO_1FN (
    ID_Detalle INT PRIMARY KEY IDENTITY(1,1),
    ID_Pedido INT,
    Producto VARCHAR(100),
    Cantidad INT,
    Precio_Unitario DECIMAL(10,2),
    FOREIGN KEY (ID_Pedido) REFERENCES PEDIDOS_1FN(ID_Pedido)
);

-- Inserts PEDIDOS
INSERT INTO PEDIDOS_1FN VALUES
(1001, '2023-05-10', 'C101', 'Juan Pérez', 'Av. Principal 123', 'Lima'),
(1002, '2023-05-11', 'C102', 'María Gómez', 'Calle Secundaria 456', 'Arequipa'),
(1003, '2023-05-12', 'C101', 'Juan Pérez', 'Av. Principal 123', 'Lima');

-- Inserts DETALLES
INSERT INTO DETALLES_PEDIDO_1FN (ID_Pedido, Producto, Cantidad, Precio_Unitario) VALUES
(1001, 'Laptop1', 1, 1200),
(1001, 'mouse', 2, 25),
(1001, 'Teclado1', 1, 50),
(1002, 'Monitor', 2, 200),
(1003, 'Impresora', 1, 300),
(1003, 'cartucho', 3, 40);

-- Ver tablas (1FN)
SELECT * FROM PEDIDOS_1FN;
SELECT * FROM DETALLES_PEDIDO_1FN;
