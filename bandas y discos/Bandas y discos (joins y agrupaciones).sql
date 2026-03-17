- Ejercicio 4: Bandas y discos (joins y agrupaciones)
-- =========================================================
-- Tablas involucradas:
--   bandas(nombre, pais)
--   bandas_discos(nombre_disco, nombre_banda, anio_disco)
--
-- Idea general:
-- Para relacionar la banda con sus discos usamos un JOIN:
--   bandas.nombre = bandas_discos.nombre_banda
-- =========================================================

-- 1. Listar todos los discos de bandas NO alemanas
--    publicados desde el 2000 en adelante.
SELECT bd.nombre_disco,
       bd.nombre_banda,
       b.pais,
       bd.anio_disco
FROM bandas b
JOIN bandas_discos bd
  ON b.nombre = bd.nombre_banda
WHERE b.pais <> 'Alemania'
  AND bd.anio_disco >= 2000
ORDER BY bd.anio_disco, bd.nombre_banda;


-- 2. Listar el disco más reciente de las bandas inglesas
--    que terminan en 's'.
SELECT bd.nombre_banda,
       bd.nombre_disco,
       bd.anio_disco
FROM bandas b
JOIN bandas_discos bd
  ON b.nombre = bd.nombre_banda
WHERE b.pais = 'UK'
  AND b.nombre LIKE '%s'
  AND bd.anio_disco = (
    SELECT MAX(bd2.anio_disco)
    FROM bandas b2
    JOIN bandas_discos bd2
      ON b2.nombre = bd2.nombre_banda
    WHERE b2.pais = 'UK'
      AND b2.nombre LIKE '%s'
  );


-- 3. Listar todas las bandas alemanas con al menos una letra K
--    en su nombre que tengan discos publicados en 1999 o superior.
SELECT DISTINCT b.nombre,
       b.pais
FROM bandas b
JOIN bandas_discos bd
  ON b.nombre = bd.nombre_banda
WHERE b.pais = 'Alemania'
  AND b.nombre ILIKE '%K%'
  AND bd.anio_disco >= 1999
ORDER BY b.nombre;


-- 4. Listar todas las bandas y el número de discos registrados.
SELECT b.nombre,
       COUNT(bd.nombre_disco) AS cantidad_discos
FROM bandas b
LEFT JOIN bandas_discos bd
  ON b.nombre = bd.nombre_banda
GROUP BY b.nombre
ORDER BY b.nombre;


-- 5. Mostrar todos los años en que las bandas sacaron un disco.
--    Ordenar la lista por año.
SELECT DISTINCT anio_disco
FROM bandas_discos
ORDER BY anio_disco;


-- 6. Listar todas las bandas que tienen un disco con nombre
--    empezado en A. Mostrar banda y disco.
SELECT bd.nombre_banda,
       bd.nombre_disco
FROM bandas_discos bd
WHERE bd.nombre_disco ILIKE 'A%'
ORDER BY bd.nombre_banda, bd.nombre_disco;


-- 7. Listar todas las bandas que tengan discos con más de una palabra.
--    Mostrar banda y disco.
SELECT bd.nombre_banda,
       bd.nombre_disco
FROM bandas_discos bd
WHERE bd.nombre_disco LIKE '% %'
ORDER BY bd.nombre_banda, bd.nombre_disco;


-- 8. Listar todas las bandas que tengan discos con más de una palabra.
--    Mostrar banda y cantidad de discos.
SELECT bd.nombre_banda,
       COUNT(*) AS cantidad_discos_mas_de_una_palabra
FROM bandas_discos bd
WHERE bd.nombre_disco LIKE '% %'
GROUP BY bd.nombre_banda
ORDER BY bd.nombre_banda;

