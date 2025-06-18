GO
USE Biblioteca2
Go


-- Tabla Autor
CREATE TABLE Autor (
    ID_Autor INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL,
    Nacionalidad VARCHAR(50)
);

-- Tabla Libro
CREATE TABLE Libro (
    ISBN VARCHAR(20) PRIMARY KEY,
    Titulo VARCHAR(200) NOT NULL,
    A�oPublicacion INT,
    Genero VARCHAR(50)
);

-- Tabla Libro_Autor (relaci�n muchos a muchos)
CREATE TABLE Libro_Autor (
    ISBN VARCHAR(20),
    ID_Autor INT,
    FOREIGN KEY (ISBN) REFERENCES Libro(ISBN),
    FOREIGN KEY (ID_Autor) REFERENCES Autor(ID_Autor)
);

-- Tabla Usuario
CREATE TABLE Usuario (
    ID_Usuario INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL,
    Direccion VARCHAR(200),
    Telefono VARCHAR(15)
);

-- Tabla Prestamo
CREATE TABLE Prestamo (
    ID_Prestamo INT PRIMARY KEY IDENTITY(1,1),
    ID_Usuario INT FOREIGN KEY REFERENCES Usuario(ID_Usuario),
    ISBN VARCHAR(20) FOREIGN KEY REFERENCES Libro(ISBN),
    Fecha_Prestamo DATE NOT NULL,
    Fecha_Devolucion DATE,
    Estado VARCHAR(20) CHECK (Estado IN ('Activo', 'Devuelto', 'Vencido'))
);
-- Insertar Autores
INSERT INTO Autor (Nombre, Nacionalidad) VALUES
('Gabriel Garc�a M�rquez', 'Colombiano'),
('J.K. Rowling', 'Brit�nica'),
('George Orwell', 'Brit�nico');

-- Insertar Libros
INSERT INTO Libro (ISBN, Titulo, A�oPublicacion, Genero) VALUES
('9780307474278', 'Cien a�os de soledad', 1967, 'Realismo m�gico'),
('9788478888567', 'Harry Potter y la piedra filosofal', 1997, 'Fantas�a'),
('9788499890944', '1984', 1949, 'Ciencia ficci�n');

-- Relacionar Libros con Autores
INSERT INTO Libro_Autor (ISBN, ID_Autor) VALUES
('9780307474278', 1),
('9788478888567', 2),
('9788499890944', 3);

-- Insertar Usuarios
INSERT INTO Usuario (Nombre, Direccion, Telefono) VALUES
('Ana L�pez', 'Calle 123, Ciudad', '555-1234'),
('Carlos P�rez', 'Avenida 456, Pueblo', '555-5678'),
('Luisa G�mez', 'Boulevard 789, Villa', '555-9012');

-- Insertar Pr�stamos
INSERT INTO Prestamo (ID_Usuario, ISBN, Fecha_Prestamo, Fecha_Devolucion, Estado) VALUES
(1, '9780307474278', '2023-10-01', '2023-10-15', 'Devuelto'),
(2, '9788478888567', '2023-10-10', NULL, 'Activo'),
(3, '9788499890944', '2023-09-20', '2023-10-05', 'Vencido');
-- 1. Libros prestados actualmente con sus autores
SELECT L.Titulo, A.Nombre AS Autor
FROM Prestamo P
JOIN Libro L ON P.ISBN = L.ISBN
JOIN Libro_Autor LA ON L.ISBN = LA.ISBN
JOIN Autor A ON LA.ID_Autor = A.ID_Autor
WHERE P.Estado = 'Activo';

-- 2. Usuarios con pr�stamos vencidos
SELECT U.Nombre, P.Fecha_Devolucion
FROM Prestamo P
JOIN Usuario U ON P.ID_Usuario = U.ID_Usuario
WHERE P.Estado = 'Vencido';

-- 3. Cantidad de libros por g�nero
SELECT Genero, COUNT(*) AS TotalLibros
FROM Libro
GROUP BY Genero;