-- ================================================
-- PRACTICA U3_1: Control de Acceso Basado en Roles
-- ================================================

-- 1. Crear la base de datos
CREATE DATABASE empresas1;
GO
USE Control_Acceso;
GO

-- 2. Crear las tablas con relaciones
CREATE TABLE Departamentos (
    id_departamento INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL,
    ubicacion VARCHAR(50),
    presupuesto DECIMAL(10,2)
);

CREATE TABLE Empleados (
    id_empleado INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    salario DECIMAL(10,2),
    fecha_contratacion DATE,
    id_departamento INT FOREIGN KEY REFERENCES Departamentos(id_departamento)
);

CREATE TABLE Proyectos (
    id_proyecto INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATE,
    fecha_fin DATE,
    presupuesto DECIMAL(12,2),
    id_departamento_responsable INT FOREIGN KEY REFERENCES Departamentos(id_departamento)
);
GO

-- 3. Insertar datos en Departamentos
INSERT INTO Departamentos (nombre, ubicacion, presupuesto) VALUES  
('Recursos Humanos', 'Piso 1', 500000.00),
('Sistemas', 'Piso 3', 750000.00),
('Contabilidad', 'Piso 2', 600000.00),
('Ventas', 'Piso 4', 450000.00),
('Marketing', 'Piso 1', 400000.00);
GO

-- 4. Insertar empleados (20 registros)
INSERT INTO Empleados (nombre, apellido, email, salario, fecha_contratacion, id_departamento)
VALUES
('Juan', 'Pérez', 'juan.perez@empresa1.com', 25000.00, '2020-05-15', 1),
('María', 'Gómez', 'maria.gomez@empresa1.com', 28000.00, '2019-08-20', 1),
('Carlos', 'López', 'carlos.lopez@empresa1.com', 32000.00, '2018-03-10', 2),
('Ana', 'Martínez', 'ana.martinez@empresa1.com', 30000.00, '2021-01-25', 2),
('Luis', 'Rodríguez', 'luis.rodriguez@empresa1.com', 27000.00, '2020-11-05', 3),
('Laura', 'Hernández', 'laura.hernandez@empresa1.com', 29000.00, '2019-06-18', 3),
('Pedro', 'Sánchez', 'pedro.sanchez@empresa1.com', 35000.00, '2017-09-12', 2),
('Sofía', 'Díaz', 'sofia.diaz@empresa1.com', 31000.00, '2020-02-28', 1),
('Miguel', 'Torres', 'miguel.torres@empresa1.com', 33000.00, '2018-07-15', 3),
('Elena', 'Ramírez', 'elena.ramirez@empresa1.com', 26500.00, '2021-04-03', 4),
('Jorge', 'Flores', 'jorge.flores@empresa1.com', 28500.00, '2019-10-22', 4),
('Patricia', 'Castro', 'patricia.castro@empresa1.com', 30500.00, '2020-08-14', 5),
('Ricardo', 'Ortega', 'ricardo.ortega@empresa1.com', 27500.00, '2021-03-30', 5),
('Carmen', 'Vargas', 'carmen.vargas@empresa1.com', 31500.00, '2018-12-05', 2),
('Fernando', 'Mendoza', 'fernando.mendoza@empresa1.com', 29500.00, '2019-05-20', 3),
('Diana', 'Guerrero', 'diana.guerrero@empresa1.com', 32500.00, '2017-11-15', 1),
('Roberto', 'Silva', 'roberto.silva@empresa1.com', 34000.00, '2016-09-08', 2),
('Lucía', 'Rojas', 'lucia.rojas@empresa1.com', 26000.00, '2020-07-12', 4),
('Oscar', 'Navarro', 'oscar.navarro@empresa1.com', 30000.00, '2019-02-25', 5),
('Teresa', 'Miranda', 'teresa.miranda@empresa1.com', 28000.00, '2021-01-10', 1);
GO

-- 5. Insertar proyectos
INSERT INTO Proyectos (nombre, descripcion, fecha_inicio, fecha_fin, presupuesto, id_departamento_responsable)
VALUES
('Sistema de Nómina', 'Desarrollo del nuevo sistema de nómina', '2023-01-15', '2023-06-30', 150000.00, 2),
('Capacitación RH', 'Programa de capacitación para empleados', '2023-02-01', '2023-12-31', 50000.00, 1),
('Migración Contable', 'Migración al nuevo sistema contable', '2023-03-01', '2023-09-30', 120000.00, 3),
('Portal del Empleado', 'Desarrollo del portal interno', '2023-04-01', '2023-08-31', 90000.00, 2),
('Campaña Publicitaria', 'Campaña de marketing para nuevo producto', '2023-05-15', '2023-11-30', 200000.00, 5);
GO

-- 6. Crear usuarios simulados
CREATE USER usuario_rh WITHOUT LOGIN;
CREATE USER usuario_sistemas WITHOUT LOGIN;
CREATE USER usuario_contabilidad WITHOUT LOGIN;
CREATE USER usuario_gerente WITHOUT LOGIN;
GO

-- 7. Crear roles por departamento
CREATE ROLE rol_recursos_humanos;
CREATE ROLE rol_sistemas;
CREATE ROLE rol_contabilidad;
CREATE ROLE rol_gerencia;
GO

-- 8. Asignar permisos a los roles
-- Recursos Humanos
GRANT SELECT, INSERT, UPDATE ON Empleados TO rol_recursos_humanos;
GRANT SELECT ON Departamentos TO rol_recursos_humanos;
DENY DELETE ON Empleados TO rol_recursos_humanos;

-- Sistemas
GRANT SELECT, INSERT, UPDATE, DELETE ON Proyectos TO rol_sistemas;
GRANT SELECT ON Empleados TO rol_sistemas;
GRANT SELECT ON Departamentos TO rol_sistemas;
GRANT EXECUTE TO rol_sistemas;

-- Contabilidad
GRANT SELECT ON Empleados TO rol_contabilidad;
GRANT SELECT, UPDATE ON Departamentos TO rol_contabilidad;

-- Gerencia
GRANT SELECT ON Departamentos TO rol_gerencia;
GRANT SELECT ON Empleados TO rol_gerencia;
GRANT SELECT ON Proyectos TO rol_gerencia;
GRANT INSERT, UPDATE ON Departamentos TO rol_gerencia;
GRANT INSERT, UPDATE ON Proyectos TO rol_gerencia;
GO

-- 9. Asignar usuarios a roles
ALTER ROLE rol_recursos_humanos ADD MEMBER usuario_rh;
ALTER ROLE rol_sistemas ADD MEMBER usuario_sistemas;
ALTER ROLE rol_contabilidad ADD MEMBER usuario_contabilidad;
ALTER ROLE rol_gerencia ADD MEMBER usuario_gerente;
GO

-- 10. Crear un procedimiento almacenado
CREATE PROCEDURE sp_obtener_empleados_departamento
    @id_departamento INT
AS
BEGIN
    SELECT e.id_empleado, e.nombre, e.apellido, e.salario, d.nombre AS departamento
    FROM Empleados e
    JOIN Departamentos d ON e.id_departamento = d.id_departamento
    WHERE e.id_departamento = @id_departamento;
END;
GO

GRANT EXECUTE ON sp_obtener_empleados_departamento TO rol_recursos_humanos;
GO

-- 11. Pruebas de permisos

-- Simular acceso de Recursos Humanos
EXECUTE AS USER = 'usuario_rh';
SELECT * FROM Empleados; -- ✔ permitido
DELETE FROM Empleados WHERE id_empleado = 1; -- ❌ denegado
SELECT * FROM Proyectos; -- ❌ denegado
REVERT;
GO

-- Simular acceso de Sistemas
EXECUTE AS USER = 'usuario_sistemas';
UPDATE Proyectos SET presupuesto = 160000 WHERE id_proyecto = 1; -- ✔ permitido
DELETE FROM Empleados; -- ❌ denegado
REVERT;
GO

-- Simular acceso de Gerencia
EXECUTE AS USER = 'usuario_gerente';
SELECT * FROM Proyectos; -- ✔ permitido
UPDATE Departamentos SET presupuesto = 550000 WHERE id_departamento = 1; -- ✔ permitido
REVERT;
GO