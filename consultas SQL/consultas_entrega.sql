-- Ejercicio 01: Consultas SQL sobre tabla clientes (filtros y patrones)


 1. Todos los clientes con rut 13133133-3
SELECT * FROM clientes
WHERE rut = '13133133-3';

-- 2. Todos los clientes mayores de 25 años
SELECT * FROM clientes
WHERE edad > 25;

-- 3. Todos los clientes que no se llamen Mario
-- PostgreSQL, insensible a mayúsculas/minúsculas
SELECT * FROM clientes
WHERE nombre NOT ILIKE 'mario';

-- Alternativa genérica (sensible a mayúsculas/minúsculas)
-- SELECT * FROM clientes
-- WHERE nombre <> 'Mario';

-- 4. Todos los clientes con rut empezado en 13
SELECT * FROM clientes
WHERE rut LIKE '13%';

-- 5. Todos los clientes con nombre finalizado en a
SELECT * FROM clientes
WHERE nombre ILIKE '%a';

-- 6. Todos los clientes con nombre empezado en P y edad mayor a 34
SELECT * FROM clientes
WHERE nombre ILIKE 'P%' AND edad > 34;

-- 7. Todos los clientes con rut empezado en 1,
--    nombre no empezado en M y edad menor a 40
SELECT * FROM clientes
WHERE rut LIKE '1%'
  AND nombre NOT ILIKE 'M%'
  AND edad < 40;

-- 8. Todos los clientes con rut empezado en 13 o terminado en 1,
--    con nombres en {Diego, Mario, Pato, Pepa}
--    y edad entre 20 y 80 (incluidos)
SELECT * FROM clientes
WHERE (rut LIKE '13%' OR rut LIKE '%1')
  AND nombre IN ('Diego', 'Mario', 'Pato', 'Pepa')
  AND edad BETWEEN 20 AND 80;