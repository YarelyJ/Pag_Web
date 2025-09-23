-- Si existen, eliminarlas primero
IF OBJECT_ID('Productos', 'U') IS NOT NULL
    DROP TABLE Productos;

IF OBJECT_ID('Categorias', 'U') IS NOT NULL
    DROP TABLE Categorias;

-- Ahora s� crear tablas
CREATE TABLE Categorias (
    CategoriaID INT PRIMARY KEY IDENTITY,
    Nombre VARCHAR(255) NOT NULL
);

CREATE TABLE Productos (
    ProductoID INT PRIMARY KEY IDENTITY,
    Nombre VARCHAR(255) NOT NULL,
    Descripcion TEXT,
    Precio DECIMAL(10, 2) NOT NULL,
    CategoriaID INT,
    FOREIGN KEY (CategoriaID) REFERENCES Categorias(CategoriaID)
);


-- ==============================
-- INSERTAR DATOS DE EJEMPLO
-- ==============================
INSERT INTO Categorias (Nombre) VALUES ('Electr�nicos');
INSERT INTO Categorias (Nombre) VALUES ('Ropa');
INSERT INTO Categorias (Nombre) VALUES ('Hogar');

INSERT INTO Productos (Nombre, Descripcion, Precio, CategoriaID) 
VALUES ('Smartphone', 'Tel�fono inteligente de �ltima generaci�n', 8000.00, 1);

INSERT INTO Productos (Nombre, Descripcion, Precio, CategoriaID) 
VALUES ('Laptop', 'Computadora port�til para trabajo y estudio', 15000.00, 1);

INSERT INTO Productos (Nombre, Descripcion, Precio, CategoriaID) 
VALUES ('Camisa', 'Camisa de algod�n', 500.00, 2);

INSERT INTO Productos (Nombre, Descripcion, Precio, CategoriaID) 
VALUES ('Sill�n', 'Sill�n de sala color gris', 3500.00, 3);

INSERT INTO Productos (Nombre, Descripcion, Precio, CategoriaID) 
VALUES ('Aud�fonos', 'Auriculares inal�mbricos', 1200.00, 1);

SELECT * FROM Productos;

