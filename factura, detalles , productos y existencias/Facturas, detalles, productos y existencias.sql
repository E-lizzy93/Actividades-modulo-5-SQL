BEGIN;

-- Limpieza previa
DROP TABLE IF EXISTS detalles_facturas;
DROP TABLE IF EXISTS existencias;
DROP TABLE IF EXISTS facturas;
DROP TABLE IF EXISTS productos;

-- 1) Crear las tablas del diagrama
CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio NUMERIC(10,2) NOT NULL CHECK (precio >= 0)
);

CREATE TABLE facturas (
    id_factura INT PRIMARY KEY,
    cliente VARCHAR(100) NOT NULL
);

CREATE TABLE existencias (
    id_existencia INT PRIMARY KEY,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad >= 0),
    pesoKg NUMERIC(10,2),
    CONSTRAINT fk_existencias_producto
        FOREIGN KEY (id_producto)
        REFERENCES productos(id_producto)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE detalles_facturas (
    id_detalle INT PRIMARY KEY,
    id_factura INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    CONSTRAINT fk_detalle_factura
        FOREIGN KEY (id_factura)
        REFERENCES facturas(id_factura)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (id_producto)
        REFERENCES productos(id_producto)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 2) Insertar 10 productos
INSERT INTO productos (id_producto, nombre, precio) VALUES (1, 'Arroz 1kg', 1800.00);
INSERT INTO productos (id_producto, nombre, precio) VALUES (2, 'Fideos', 1200.00);
INSERT INTO productos (id_producto, nombre, precio) VALUES (3, 'Aceite 1L', 3500.00);
INSERT INTO productos (id_producto, nombre, precio) VALUES (4, 'Leche 1L', 1100.00);
INSERT INTO productos (id_producto, nombre, precio) VALUES (5, 'Pan de molde', 2500.00);
INSERT INTO productos (id_producto, nombre, precio) VALUES (6, 'Azúcar 1kg', 1700.00);
INSERT INTO productos (id_producto, nombre, precio) VALUES (7, 'Café 200g', 5400.00);
INSERT INTO productos (id_producto, nombre, precio) VALUES (8, 'Té 100 bolsas', 2900.00);
INSERT INTO productos (id_producto, nombre, precio) VALUES (9, 'Galletas', 1500.00);
INSERT INTO productos (id_producto, nombre, precio) VALUES (10, 'Chocolate', 2200.00);

-- 3) Insertar existencias para todos los productos
INSERT INTO existencias (id_existencia, id_producto, cantidad, pesoKg) VALUES (1, 1, 25, 1.00);
INSERT INTO existencias (id_existencia, id_producto, cantidad, pesoKg) VALUES (2, 2, 18, 0.50);
INSERT INTO existencias (id_existencia, id_producto, cantidad, pesoKg) VALUES (3, 3, 12, 1.00);
INSERT INTO existencias (id_existencia, id_producto, cantidad, pesoKg) VALUES (4, 4, 30, 1.00);
INSERT INTO existencias (id_existencia, id_producto, cantidad, pesoKg) VALUES (5, 5, 16, 0.70);
INSERT INTO existencias (id_existencia, id_producto, cantidad, pesoKg) VALUES (6, 6, 20, 1.00);
INSERT INTO existencias (id_existencia, id_producto, cantidad, pesoKg) VALUES (7, 7, 8, 0.20);
INSERT INTO existencias (id_existencia, id_producto, cantidad, pesoKg) VALUES (8, 8, 14, 0.25);
INSERT INTO existencias (id_existencia, id_producto, cantidad, pesoKg) VALUES (9, 9, 22, 0.30);
INSERT INTO existencias (id_existencia, id_producto, cantidad, pesoKg) VALUES (10, 10, 11, 0.10);

-- 4) Insertar 5 facturas
INSERT INTO facturas (id_factura, cliente) VALUES (1001, 'Ana García');
INSERT INTO facturas (id_factura, cliente) VALUES (1002, 'Luis Pérez');
INSERT INTO facturas (id_factura, cliente) VALUES (1003, 'María Soto');
INSERT INTO facturas (id_factura, cliente) VALUES (1004, 'Carlos Ruiz');
INSERT INTO facturas (id_factura, cliente) VALUES (1005, 'Elena Torres');

-- 5) Insertar detalle para todas las facturas (entre 3 y 5 productos por factura)
INSERT INTO detalles_facturas (id_detalle, id_factura, id_producto, cantidad) VALUES (1, 1001, 1, 2);
INSERT INTO detalles_facturas (id_detalle, id_factura, id_producto, cantidad) VALUES (2, 1001, 3, 1);
INSERT INTO detalles_facturas (id_detalle, id_factura, id_producto, cantidad) VALUES (3, 1001, 4, 3);

INSERT INTO detalles_facturas (id_detalle, id_factura, id_producto, cantidad) VALUES (4, 1002, 2, 2);
INSERT INTO detalles_facturas (id_detalle, id_factura, id_producto, cantidad) VALUES (5, 1002, 5, 1);
INSERT INTO detalles_facturas (id_detalle, id_factura, id_producto, cantidad) VALUES (6, 1002, 9, 4);
INSERT INTO detalles_facturas (id_detalle, id_factura, id_producto, cantidad) VALUES (7, 1002, 10, 2);

INSERT INTO detalles_facturas (id_detalle, id_factura, id_producto, cantidad) VALUES (8, 1003, 6, 2);
INSERT INTO detalles_facturas (id_detalle, id_factura, id_producto, cantidad) VALUES (9, 1003, 7, 1);
INSERT INTO detalles_facturas (id_detalle, id_factura, id_producto, cantidad) VALUES (10, 1003, 8, 1);
INSERT INTO detalles_facturas (id_detalle, id_factura, id_producto, cantidad) VALUES (11, 1003, 4, 2);
INSERT INTO detalles_facturas (id_detalle, id_factura, id_producto, cantidad) VALUES (12, 1003, 1, 1);

INSERT INTO detalles_facturas (id_detalle, id_factura, id_producto, cantidad) VALUES (13, 1004, 3, 2);
INSERT INTO detalles_facturas (id_detalle, id_factura, id_producto, cantidad) VALUES (14, 1004, 5, 1);
INSERT INTO detalles_facturas (id_detalle, id_factura, id_producto, cantidad) VALUES (15, 1004, 7, 1);

INSERT INTO detalles_facturas (id_detalle, id_factura, id_producto, cantidad) VALUES (16, 1005, 2, 1);
INSERT INTO detalles_facturas (id_detalle, id_factura, id_producto, cantidad) VALUES (17, 1005, 6, 1);
INSERT INTO detalles_facturas (id_detalle, id_factura, id_producto, cantidad) VALUES (18, 1005, 8, 2);
INSERT INTO detalles_facturas (id_detalle, id_factura, id_producto, cantidad) VALUES (19, 1005, 9, 3);

-- 6) Actualizar todas las existencias dejando cantidad = 10
UPDATE existencias
SET cantidad = 10;

-- 7) Agregar la columna fecha a facturas
ALTER TABLE facturas
ADD COLUMN fecha DATE;

-- 8) Actualizar fecha con valores distintos para cada factura
UPDATE facturas SET fecha = '2026-03-01' WHERE id_factura = 1001;
UPDATE facturas SET fecha = '2026-03-02' WHERE id_factura = 1002;
UPDATE facturas SET fecha = '2026-03-03' WHERE id_factura = 1003;
UPDATE facturas SET fecha = '2026-03-04' WHERE id_factura = 1004;
UPDATE facturas SET fecha = '2026-03-05' WHERE id_factura = 1005;

-- 9) Eliminar la columna pesoKg de existencias
ALTER TABLE existencias
DROP COLUMN pesoKg;

COMMIT;

-- 10) Consultar una factura en particular mostrando su detalle,
--     el nombre de cada producto y su precio
SELECT f.id_factura,
       f.cliente,
       f.fecha,
       d.id_detalle,
       p.nombre AS nombre_producto,
       p.precio,
       d.cantidad,
       (d.cantidad * p.precio) AS subtotal_linea
FROM facturas f
JOIN detalles_facturas d
  ON f.id_factura = d.id_factura
JOIN productos p
  ON d.id_producto = p.id_producto
WHERE f.id_factura = 1003
ORDER BY d.id_detalle;

-- 11) Consultar el valor final de una factura
SELECT f.id_factura,
       f.cliente,
       SUM(d.cantidad * p.precio) AS total_factura
FROM facturas f
JOIN detalles_facturas d
  ON f.id_factura = d.id_factura
JOIN productos p
  ON d.id_producto = p.id_producto
WHERE f.id_factura = 1003
GROUP BY f.id_factura, f.cliente;

-- 12) Eliminar todos los productos
-- Gracias al ON DELETE CASCADE, también se eliminarán sus existencias
-- y los detalles asociados en detalles_facturas.
DELETE FROM productos;

