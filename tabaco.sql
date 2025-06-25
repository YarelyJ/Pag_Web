-- Tabaco_1
CREATE TABLE Tabaco_1 (
    nombre VARCHAR(50),
    licencia VARCHAR(50),
    hoja VARCHAR(30),
    nicotina DECIMAL(3,1),
    alquitrán INT
);

INSERT INTO Tabaco_1 VALUES
('Camel sin filtro', 'R.J. Reynolds Tobacco Co.', 'Turca', 1.1, 15),
('Marlboro', 'Phillips Morris', 'sin especificar', 0.9, 12),
('coronas', 'Tabacalera S.A.', 'Canaria', 0.9, 15),
('Rex', 'Tabacalera S.A.', 'Canaria', 0.9, 12);

-- Tabaco_2
CREATE TABLE Tabaco_2 (
    nombre VARCHAR(50),
    licencia VARCHAR(50),
    hoja VARCHAR(30),
    nicotina DECIMAL(3,1),
    alquitrán INT
);

INSERT INTO Tabaco_2 VALUES
('Ducados', 'Tabacalera S.A.', 'sin especificar', 1.1, 14),
('Fortuna', 'Tabacalera S.A.', 'sin especificar', 1.0, 14),
('Camel sin filtro', 'R.J. Reynolds Tobacco Co.', 'Turca', 1.1, 15),
('Lucky sin filtro', 'sin especificar', 'sin especificar', 1.1, 15),
('Habanos', 'Tabacalera S.A.', 'sin especificar', 1.3, 15);

-- Estancos
CREATE TABLE Estancos (
    propietario VARCHAR(50),
    calle VARCHAR(50),
    telefono VARCHAR(20)
);

INSERT INTO Estancos VALUES
('La pajarita', 'El nido, 5', '276-5578'),
('El clavel', 'El jardín, 23', '444-8765');

-- Tabaco_3 = Tabaco_1 UNION Tabaco_2
SELECT * FROM Tabaco_1
UNION
SELECT * FROM Tabaco_2;

-- Tabaco_4 = Tabaco_1 MINUS Tabaco_2
SELECT * FROM Tabaco_1
WHERE NOT EXISTS (
  SELECT 1 FROM Tabaco_2
  WHERE Tabaco_1.nombre = Tabaco_2.nombre
    AND Tabaco_1.licencia = Tabaco_2.licencia
    AND Tabaco_1.hoja = Tabaco_2.hoja
    AND Tabaco_1.nicotina = Tabaco_2.nicotina
    AND Tabaco_1.alquitrán = Tabaco_2.alquitrán
);

-- Select * from Tabaco_1 where licencia = Tabacalera S.A.
SELECT * FROM Tabaco_1
WHERE licencia = 'Tabacalera S.A.';

-- Tabaco_5 = Project (nombre, nicotina, alquitrán)
SELECT nombre, nicotina, alquitrán FROM Tabaco_1;

-- Tabaco_6 = Tabaco_1 PRODUCT Estancos
SELECT * FROM Tabaco_1
CROSS JOIN Estancos;
