-- ==========================================================
-- EJERCICIO 9
-- Evaluación final: JOIN + Modelo ER
-- ==========================================================

-- ----------------------------------------------------------
-- PARTE 1: consultas sobre las tablas entregadas
-- ----------------------------------------------------------

-- Nota:
-- Se asume que ya existen las tablas:
-- reparto_soltera_otra_vez
-- reparto_papi_ricky
-- con los datos entregados en el archivo complementario.

-- 1. Actores que participaron en ambas teleseries,
--    sueldo en cada una y suma de ambos sueldos.
SELECT
    s.nombre,
    s.sueldo AS sueldo_soltera_otra_vez,
    p.sueldo AS sueldo_papi_ricky,
    s.sueldo + p.sueldo AS sueldo_total
FROM reparto_soltera_otra_vez s
INNER JOIN reparto_papi_ricky p
    ON s.nombre = p.nombre
ORDER BY s.nombre;


-- 2. Actores que participaron exclusivamente en Soltera Otra Vez,
--    con sueldo mayor a 90.
SELECT
    s.nombre,
    s.temporadas,
    s.protagonico,
    s.sueldo
FROM reparto_soltera_otra_vez s
LEFT JOIN reparto_papi_ricky p
    ON s.nombre = p.nombre
WHERE p.nombre IS NULL
  AND s.sueldo > 90
ORDER BY s.nombre;


-- 3. Actores con sueldo inferior a 85 que actuaron en cualquiera
--    de las dos teleseries, pero no en ambas.
SELECT
    s.nombre,
    'Soltera Otra Vez' AS teleserie,
    s.sueldo
FROM reparto_soltera_otra_vez s
LEFT JOIN reparto_papi_ricky p
    ON s.nombre = p.nombre
WHERE p.nombre IS NULL
  AND s.sueldo < 85

UNION ALL

SELECT
    p.nombre,
    'Papi Ricky' AS teleserie,
    p.sueldo
FROM reparto_papi_ricky p
LEFT JOIN reparto_soltera_otra_vez s
    ON p.nombre = s.nombre
WHERE s.nombre IS NULL
  AND p.sueldo < 85
ORDER BY nombre;


-- ----------------------------------------------------------
-- PARTE 2: modelo entidad-relación propuesto
-- ----------------------------------------------------------
-- Propuesta de modelo normalizado:
-- 1) actores
-- 2) teleseries
-- 3) participaciones
--
-- Relación:
-- un actor puede participar en muchas teleseries
-- una teleserie puede tener muchos actores
-- => relación N:M resuelta con la tabla participaciones
--
-- Para adaptar ambos archivos originales a un solo sistema,
-- se usa un campo genérico de unidades_participacion y un tipo_unidad,
-- ya que en una teleserie se habla de temporadas y en la otra de capítulos.

DROP TABLE IF EXISTS participaciones;
DROP TABLE IF EXISTS teleseries;
DROP TABLE IF EXISTS actores;

CREATE TABLE actores (
    id_actor SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE teleseries (
    id_teleserie SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE participaciones (
    id_participacion SERIAL PRIMARY KEY,
    id_actor INT NOT NULL,
    id_teleserie INT NOT NULL,
    tipo_unidad VARCHAR(20) NOT NULL CHECK (tipo_unidad IN ('temporadas', 'capitulos')),
    unidades_participacion INT NOT NULL CHECK (unidades_participacion > 0),
    protagonico BOOLEAN NOT NULL,
    sueldo INT NOT NULL CHECK (sueldo >= 0),
    CONSTRAINT fk_participacion_actor
        FOREIGN KEY (id_actor)
        REFERENCES actores(id_actor)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_participacion_teleserie
        FOREIGN KEY (id_teleserie)
        REFERENCES teleseries(id_teleserie)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT uq_actor_teleserie UNIQUE (id_actor, id_teleserie)
);


-- ----------------------------------------------------------
-- Inserts adaptados desde el ejercicio anterior
-- ----------------------------------------------------------

-- Actores
INSERT INTO actores (nombre) VALUES
('Paz Bascuñán'),
('Pablo Macaya'),
('Cristián Arriagada'),
('Josefina Montané'),
('Loreto Aravena'),
('Lorena Bosch'),
('Nicolás Poblete'),
('Héctor Morales'),
('Aranzazú Yankovic'),
('Luis Gnecco'),
('Catalina Guerra'),
('Solange Lackington'),
('Ignacio Garmendia'),
('Julio González'),
('Antonella Orsini'),
('Tamara Acosta'),
('Silvia Santelices'),
('Alejandro Trejo'),
('Grimanesa Jiménez'),
('Jorge Zabaleta'),
('Belén Soto'),
('María Elena Swett'),
('Juan Falcón'),
('Leonardo Perucci'),
('Teresita Reyes'),
('Remigio Remedy'),
('María Paz Grandjean'),
('César Caillet'),
('José Tomás Guzmán'),
('Manuel Aguirre');

-- Teleseries
INSERT INTO teleseries (nombre) VALUES
('Soltera Otra Vez'),
('Papi Ricky');

-- Participaciones adaptadas desde reparto_soltera_otra_vez
INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'temporadas', 3, true, 100
FROM actores a, teleseries t
WHERE a.nombre = 'Paz Bascuñán' AND t.nombre = 'Soltera Otra Vez';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'temporadas', 3, true, 100
FROM actores a, teleseries t
WHERE a.nombre = 'Pablo Macaya' AND t.nombre = 'Soltera Otra Vez';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'temporadas', 3, true, 95
FROM actores a, teleseries t
WHERE a.nombre = 'Cristián Arriagada' AND t.nombre = 'Soltera Otra Vez';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'temporadas', 2, true, 90
FROM actores a, teleseries t
WHERE a.nombre = 'Josefina Montané' AND t.nombre = 'Soltera Otra Vez';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'temporadas', 3, true, 95
FROM actores a, teleseries t
WHERE a.nombre = 'Loreto Aravena' AND t.nombre = 'Soltera Otra Vez';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'temporadas', 2, true, 90
FROM actores a, teleseries t
WHERE a.nombre = 'Lorena Bosch' AND t.nombre = 'Soltera Otra Vez';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'temporadas', 2, true, 85
FROM actores a, teleseries t
WHERE a.nombre = 'Nicolás Poblete' AND t.nombre = 'Soltera Otra Vez';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'temporadas', 3, true, 80
FROM actores a, teleseries t
WHERE a.nombre = 'Héctor Morales' AND t.nombre = 'Soltera Otra Vez';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'temporadas', 2, true, 80
FROM actores a, teleseries t
WHERE a.nombre = 'Aranzazú Yankovic' AND t.nombre = 'Soltera Otra Vez';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'temporadas', 3, true, 95
FROM actores a, teleseries t
WHERE a.nombre = 'Luis Gnecco' AND t.nombre = 'Soltera Otra Vez';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'temporadas', 3, true, 90
FROM actores a, teleseries t
WHERE a.nombre = 'Catalina Guerra' AND t.nombre = 'Soltera Otra Vez';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'temporadas', 2, true, 70
FROM actores a, teleseries t
WHERE a.nombre = 'Solange Lackington' AND t.nombre = 'Soltera Otra Vez';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'temporadas', 2, true, 70
FROM actores a, teleseries t
WHERE a.nombre = 'Ignacio Garmendia' AND t.nombre = 'Soltera Otra Vez';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'temporadas', 3, true, 75
FROM actores a, teleseries t
WHERE a.nombre = 'Julio González' AND t.nombre = 'Soltera Otra Vez';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'temporadas', 3, true, 70
FROM actores a, teleseries t
WHERE a.nombre = 'Antonella Orsini' AND t.nombre = 'Soltera Otra Vez';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'temporadas', 1, false, 60
FROM actores a, teleseries t
WHERE a.nombre = 'Tamara Acosta' AND t.nombre = 'Soltera Otra Vez';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'temporadas', 1, false, 55
FROM actores a, teleseries t
WHERE a.nombre = 'Silvia Santelices' AND t.nombre = 'Soltera Otra Vez';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'temporadas', 1, false, 55
FROM actores a, teleseries t
WHERE a.nombre = 'Alejandro Trejo' AND t.nombre = 'Soltera Otra Vez';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'temporadas', 1, false, 60
FROM actores a, teleseries t
WHERE a.nombre = 'Grimanesa Jiménez' AND t.nombre = 'Soltera Otra Vez';

-- Participaciones adaptadas desde reparto_papi_ricky
INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'capitulos', 135, true, 100
FROM actores a, teleseries t
WHERE a.nombre = 'Jorge Zabaleta' AND t.nombre = 'Papi Ricky';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'capitulos', 135, true, 100
FROM actores a, teleseries t
WHERE a.nombre = 'Belén Soto' AND t.nombre = 'Papi Ricky';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'capitulos', 135, true, 100
FROM actores a, teleseries t
WHERE a.nombre = 'Tamara Acosta' AND t.nombre = 'Papi Ricky';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'capitulos', 135, true, 100
FROM actores a, teleseries t
WHERE a.nombre = 'María Elena Swett' AND t.nombre = 'Papi Ricky';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'capitulos', 135, true, 95
FROM actores a, teleseries t
WHERE a.nombre = 'Juan Falcón' AND t.nombre = 'Papi Ricky';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'capitulos', 135, true, 85
FROM actores a, teleseries t
WHERE a.nombre = 'Silvia Santelices' AND t.nombre = 'Papi Ricky';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'capitulos', 135, true, 85
FROM actores a, teleseries t
WHERE a.nombre = 'Leonardo Perucci' AND t.nombre = 'Papi Ricky';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'capitulos', 135, true, 80
FROM actores a, teleseries t
WHERE a.nombre = 'Teresita Reyes' AND t.nombre = 'Papi Ricky';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'capitulos', 135, true, 75
FROM actores a, teleseries t
WHERE a.nombre = 'Luis Gnecco' AND t.nombre = 'Papi Ricky';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'capitulos', 135, true, 65
FROM actores a, teleseries t
WHERE a.nombre = 'Alejandro Trejo' AND t.nombre = 'Papi Ricky';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'capitulos', 135, true, 60
FROM actores a, teleseries t
WHERE a.nombre = 'Grimanesa Jiménez' AND t.nombre = 'Papi Ricky';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'capitulos', 135, true, 60
FROM actores a, teleseries t
WHERE a.nombre = 'Remigio Remedy' AND t.nombre = 'Papi Ricky';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'capitulos', 135, true, 55
FROM actores a, teleseries t
WHERE a.nombre = 'María Paz Grandjean' AND t.nombre = 'Papi Ricky';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'capitulos', 135, true, 50
FROM actores a, teleseries t
WHERE a.nombre = 'Héctor Morales' AND t.nombre = 'Papi Ricky';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'capitulos', 135, true, 40
FROM actores a, teleseries t
WHERE a.nombre = 'César Caillet' AND t.nombre = 'Papi Ricky';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'capitulos', 135, true, 25
FROM actores a, teleseries t
WHERE a.nombre = 'José Tomás Guzmán' AND t.nombre = 'Papi Ricky';

INSERT INTO participaciones (id_actor, id_teleserie, tipo_unidad, unidades_participacion, protagonico, sueldo)
SELECT a.id_actor, t.id_teleserie, 'capitulos', 135, true, 30
FROM actores a, teleseries t
WHERE a.nombre = 'Manuel Aguirre' AND t.nombre = 'Papi Ricky';


-- ----------------------------------------------------------
-- Consulta solicitada sobre el nuevo sistema mejorado
-- Mostrar todas las teleseries y todos los actores de reparto asociados.
-- No incluir actores de rol secundario.
-- ----------------------------------------------------------
SELECT
    t.nombre AS teleserie,
    a.nombre AS actor,
    p.tipo_unidad,
    p.unidades_participacion,
    p.sueldo
FROM participaciones p
INNER JOIN actores a
    ON p.id_actor = a.id_actor
INNER JOIN teleseries t
    ON p.id_teleserie = t.id_teleserie
WHERE p.protagonico = true
ORDER BY t.nombre, a.nombre;


