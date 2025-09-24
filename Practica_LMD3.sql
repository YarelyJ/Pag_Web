-- ========================================
-- 1. CREACIÓN DE BASE DE DATOS Y TABLAS
-- ========================================
CREATE DATABASE VideoGameStore;
GO

USE VideoGameStore;
GO

CREATE TABLE Juegos (
    JuegoID INT PRIMARY KEY IDENTITY(1,1),
    Titulo NVARCHAR(100),
    Genero NVARCHAR(50),
    Precio DECIMAL(10, 2),
    FechaLanzamiento DATE
);
GO

CREATE TABLE Ventas (
    VentaID INT PRIMARY KEY IDENTITY(1,1),
    JuegoID INT,
    Cantidad INT,
    FechaVenta DATE,
    FOREIGN KEY (JuegoID) REFERENCES Juegos(JuegoID)
);
GO

-- ========================================
-- 2. INSERCIÓN DE DATOS
-- ========================================

-- Insertar Juegos
INSERT INTO Juegos (Titulo, Genero, Precio, FechaLanzamiento) VALUES
('The Legend of Zelda: Breath of the Wild', 'Aventura', 59.99, '2017-03-03'),
('Super Mario Odyssey', 'Plataformas', 59.99, '2017-10-27'),
('Call of Duty: Modern Warfare', 'Shooter', 59.99, '2019-10-25'),
('FIFA 21', 'Deportes', 59.99, '2020-10-09'),
('Animal Crossing: New Horizons', 'Simulación', 59.99, '2020-03-20'),
('Cyberpunk 2077', 'RPG', 59.99, '2020-12-10'),
('Minecraft', 'Aventura', 26.95, '2011-11-18'),
('Red Dead Redemption 2', 'Aventura', 59.99, '2018-10-26'),
('Fortnite', 'Battle Royale', 0.00, '2017-07-25'),
('Overwatch', 'Shooter', 39.99, '2016-05-24');

-- Insertar Ventas
INSERT INTO Ventas (JuegoID, Cantidad, FechaVenta) VALUES
(1, 1, '2023-07-01'),
(2, 2, '2023-07-02'),
(3, 1, '2023-07-03'),
(4, 3, '2023-07-04'),
(5, 1, '2023-07-05'),
(6, 2, '2023-07-06'),
(7, 4, '2023-07-07'),
(8, 1, '2023-07-08'),
(9, 10, '2023-07-09'),
(10, 5, '2023-07-10');

-- ========================================
-- 3. CONSULTAS A DESARROLLAR
-- ========================================

-- 1. Total de Ventas por Juego
SELECT j.Titulo, SUM(v.Cantidad) AS TotalVentas
FROM Juegos j
JOIN Ventas v ON j.JuegoID = v.JuegoID
GROUP BY j.Titulo;

-- 2. Precio Promedio de los Juegos por Género
SELECT Genero, AVG(Precio) AS PrecioPromedio
FROM Juegos
GROUP BY Genero;

-- 3. Contar la Cantidad de Juegos por Género
SELECT Genero, COUNT(*) AS CantidadJuegos
FROM Juegos
GROUP BY Genero;

-- 4. Juegos con Precio Mayor a 50
SELECT * 
FROM Juegos 
WHERE Precio > 50;

-- 5. Ventas Totales en un Día Específico (2023-07-01)
SELECT SUM(Cantidad) AS TotalVentas
FROM Ventas
WHERE FechaVenta = '2023-07-01';

-- 6. Juegos Lanzados en el Último Año (desde 2025-09-21)
SELECT * 
FROM Juegos 
WHERE FechaLanzamiento >= DATEADD(YEAR, -1, '2025-09-21');

-- 7. Cantidad de Juegos Vendidos por Fecha
SELECT FechaVenta, SUM(Cantidad) AS JuegosVendidos
FROM Ventas
GROUP BY FechaVenta
ORDER BY FechaVenta;

-- 8. Conversión de Precios a Euros (Tasa: 0.85)
SELECT Titulo, Precio, Precio * 0.85 AS PrecioEuros
FROM Juegos;

-- 9. Top 5 Juegos Más Vendidos
SELECT TOP 5 j.Titulo, SUM(v.Cantidad) AS TotalVendidos
FROM Juegos j
JOIN Ventas v ON j.JuegoID = v.JuegoID
GROUP BY j.Titulo
ORDER BY TotalVendidos DESC;

-- 10. Ventas por Juego y Precio Total
SELECT j.Titulo, SUM(v.Cantidad) AS TotalUnidades, 
       SUM(v.Cantidad * j.Precio) AS PrecioTotal
FROM Juegos j
JOIN Ventas v ON j.JuegoID = v.JuegoID
GROUP BY j.Titulo;

-- 11. Detalles de Ventas con Títulos de Juegos
SELECT v.VentaID, j.Titulo, v.Cantidad, v.FechaVenta
FROM Ventas v
JOIN Juegos j ON v.JuegoID = j.JuegoID;

-- 12. Total Ventas por Género
SELECT j.Genero, SUM(v.Cantidad) AS TotalVentas
FROM Juegos j
JOIN Ventas v ON j.JuegoID = v.JuegoID
GROUP BY j.Genero;

-- 13. Ventas de Juegos que Superan un Precio Específico (Precio > 50)
SELECT j.Titulo, v.Cantidad, j.Precio
FROM Juegos j
JOIN Ventas v ON j.JuegoID = v.JuegoID
WHERE j.Precio > 50;

-- 14. Juegos Vendidos en una Fecha Específica ('2023-07-01')
SELECT j.Titulo, v.Cantidad
FROM Ventas v
JOIN Juegos j ON v.JuegoID = j.JuegoID
WHERE v.FechaVenta = '2023-07-01';

-- 15. Total de Juegos Vendidos y Precio Promedio
SELECT SUM(v.Cantidad) AS TotalVendidos,
       AVG(j.Precio) AS PrecioPromedio
FROM Ventas v
JOIN Juegos j ON v.JuegoID = j.JuegoID;

-- 16. Juegos que Tienen Ventas por Encima de la Media
SELECT j.Titulo, SUM(v.Cantidad) AS TotalVentas
FROM Juegos j
JOIN Ventas v ON j.JuegoID = v.JuegoID
GROUP BY j.Titulo
HAVING SUM(v.Cantidad) > (
    SELECT AVG(Cantidad * 1.0)
    FROM Ventas
);

-- 17. Juegos que no Han Sido Vendidos
SELECT j.Titulo
FROM Juegos j
LEFT JOIN Ventas v ON j.JuegoID = v.JuegoID
WHERE v.VentaID IS NULL;

-- 18. Juegos con Precio Mayor que el Promedio
SELECT *
FROM Juegos
WHERE Precio > (
    SELECT AVG(Precio) FROM Juegos
);

-- 19. Ventas de Juegos que Superan el Precio del Juego Más Caro
SELECT j.Titulo, j.Precio, v.Cantidad
FROM Juegos j
JOIN Ventas v ON j.JuegoID = v.JuegoID
WHERE j.Precio > (
    SELECT MAX(Precio) FROM Juegos
);

-- 20. Géneros con Más de 2 Juegos Vendidos
SELECT j.Genero, SUM(v.Cantidad) AS TotalVendidos
FROM Juegos j
JOIN Ventas v ON j.JuegoID = v.JuegoID
GROUP BY j.Genero
HAVING SUM(v.Cantidad) > 2;
