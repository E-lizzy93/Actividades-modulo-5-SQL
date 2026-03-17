-- =====================================================
-- 1. LIMPIEZA DE TABLAS (Para ejecutar desde cero)
-- =====================================================
DROP TABLE IF EXISTS historial_estado_encomienda, encomienda, tarifa_envio, sucursal, cliente_envio CASCADE;
DROP TABLE IF EXISTS detalle_pedido, pago_pedido, pedido, producto, categoria, cliente_retail CASCADE;
DROP TABLE IF EXISTS transaccion_bancaria, cuenta_bancaria, tipo_transaccion, cliente_banco CASCADE;

-- =====================================================
-- 2. SISTEMA DE ENVÍO DE ENCOMIENDAS
-- =====================================================

CREATE TABLE cliente_envio (
    id_cliente SERIAL PRIMARY KEY,
    rut VARCHAR(20) UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(120) UNIQUE,
    direccion VARCHAR(200) NOT NULL
);

CREATE TABLE sucursal (
    id_sucursal SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    telefono VARCHAR(20)
);

CREATE TABLE tarifa_envio (
    id_tarifa SERIAL PRIMARY KEY,
    nombre_tarifa VARCHAR(80) NOT NULL,
    peso_min_kg NUMERIC(10,2) NOT NULL CHECK (peso_min_kg >= 0),
    peso_max_kg NUMERIC(10,2) NOT NULL CHECK (peso_max_kg >= peso_min_kg),
    precio NUMERIC(12,2) NOT NULL CHECK (precio >= 0),
    dias_estimados INT NOT NULL CHECK (dias_estimados > 0)
);

CREATE TABLE encomienda (
    id_encomienda SERIAL PRIMARY KEY,
    id_cliente_remitente INT NOT NULL REFERENCES cliente_envio(id_cliente) ON UPDATE CASCADE ON DELETE RESTRICT,
    id_cliente_destinatario INT NOT NULL REFERENCES cliente_envio(id_cliente) ON UPDATE CASCADE ON DELETE RESTRICT,
    id_sucursal_origen INT NOT NULL REFERENCES sucursal(id_sucursal) ON UPDATE CASCADE ON DELETE RESTRICT,
    id_sucursal_destino INT NOT NULL REFERENCES sucursal(id_sucursal) ON UPDATE CASCADE ON DELETE RESTRICT,
    id_tarifa INT NOT NULL REFERENCES tarifa_envio(id_tarifa) ON UPDATE CASCADE ON DELETE RESTRICT,
    fecha_envio DATE NOT NULL DEFAULT CURRENT_DATE,
    peso_kg NUMERIC(10,2) NOT NULL CHECK (peso_kg > 0),
    descripcion VARCHAR(200),
    direccion_destino VARCHAR(200) NOT NULL,
    estado_actual VARCHAR(30) NOT NULL,
    CONSTRAINT chk_estado_actual_envio CHECK (estado_actual IN ('creada', 'recibida', 'en_transito', 'en_reparto', 'entregada', 'devuelta', 'cancelada')),
    CONSTRAINT chk_clientes_distintos CHECK (id_cliente_remitente <> id_cliente_destinatario)
);

-- =====================================================
-- 3. SISTEMA DE VENTA RETAIL
-- =====================================================

CREATE TABLE cliente_retail (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    direccion VARCHAR(200)
);

CREATE TABLE categoria (
    id_categoria SERIAL PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL UNIQUE,
    descripcion VARCHAR(200)
);

CREATE TABLE producto (
    id_producto SERIAL PRIMARY KEY,
    id_categoria INT NOT NULL REFERENCES categoria(id_categoria) ON UPDATE CASCADE ON DELETE RESTRICT,
    nombre VARCHAR(120) NOT NULL,
    precio NUMERIC(12,2) NOT NULL CHECK (precio >= 0),
    stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0)
);

CREATE TABLE pedido (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL REFERENCES cliente_retail(id_cliente) ON UPDATE CASCADE ON DELETE RESTRICT,
    fecha_pedido TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(30) NOT NULL CHECK (estado IN ('pendiente', 'pagado', 'entregado', 'cancelado')),
    total NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (total >= 0)
);

CREATE TABLE detalle_pedido (
    id_pedido INT REFERENCES pedido(id_pedido) ON DELETE CASCADE,
    id_producto INT REFERENCES producto(id_producto) ON DELETE RESTRICT,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(12,2) NOT NULL,
    PRIMARY KEY (id_pedido, id_producto)
);

-- =====================================================
-- 4. SISTEMA BANCARIO
-- =====================================================

CREATE TABLE cliente_banco (
    id_cliente SERIAL PRIMARY KEY,
    rut VARCHAR(20) UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(120) UNIQUE
);

CREATE TABLE cuenta_bancaria (
    id_cuenta SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL REFERENCES cliente_banco(id_cliente),
    numero_cuenta VARCHAR(30) NOT NULL UNIQUE,
    tipo_cuenta VARCHAR(30) NOT NULL CHECK (tipo_cuenta IN ('corriente', 'vista', 'ahorro')),
    saldo NUMERIC(14,2) NOT NULL DEFAULT 0 CHECK (saldo >= 0),
    fecha_apertura DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE tipo_transaccion (
    id_tipo_transaccion SERIAL PRIMARY KEY,
    nombre VARCHAR(40) NOT NULL UNIQUE,
    signo CHAR(1) NOT NULL CHECK (signo IN ('+', '-'))
);

CREATE TABLE transaccion_bancaria (
    id_transaccion SERIAL PRIMARY KEY,
    id_cuenta INT NOT NULL REFERENCES cuenta_bancaria(id_cuenta) ON DELETE CASCADE,
    id_tipo_transaccion INT NOT NULL REFERENCES tipo_transaccion(id_tipo_transaccion),
    fecha_transaccion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    monto NUMERIC(14,2) NOT NULL CHECK (monto > 0)
);

-- =====================================================
-- 5. INSERCIÓN DE DATOS DE PRUEBA
-- =====================================================

-- Envíos
INSERT INTO cliente_envio (rut, nombre, direccion) VALUES ('12.345.678-9', 'Juan Perez', 'Alameda 123'), ('11.222.333-4', 'Maria Soto', 'Providencia 456');
INSERT INTO sucursal (nombre, ciudad, direccion) VALUES ('Centro Santiago', 'Santiago', 'Huerfanos 800'), ('Sucursal Recoleta', 'Santiago', 'Einstein 100');
INSERT INTO tarifa_envio (nombre_tarifa, peso_min_kg, peso_max_kg, precio, dias_estimados) VALUES ('Estándar', 0, 5, 3500, 2);
INSERT INTO encomienda (id_cliente_remitente, id_cliente_destinatario, id_sucursal_origen, id_sucursal_destino, id_tarifa, peso_kg, direccion_destino, estado_actual) 
VALUES (1, 2, 1, 2, 1, 2.5, 'Providencia 456', 'en_transito');

-- Retail
INSERT INTO cliente_retail (nombre, email) VALUES ('Carlos Ruiz', 'carlos@mail.com');
INSERT INTO categoria (nombre) VALUES ('Tecnología');
INSERT INTO producto (id_categoria, nombre, precio, stock) VALUES (1, 'Mouse Gamer', 15000, 20);
INSERT INTO pedido (id_cliente, estado, total) VALUES (1, 'pagado', 15000);
INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (1, 1, 1, 15000);

-- Banca
INSERT INTO cliente_banco (rut, nombre) VALUES ('9.876.543-2', 'Elena Torres');
INSERT INTO cuenta_bancaria (id_cliente, numero_cuenta, tipo_cuenta, saldo) VALUES (1, '123-456-789', 'corriente', 50000);
INSERT INTO tipo_transaccion (nombre, signo) VALUES ('deposito', '+'), ('giro', '-');
INSERT INTO transaccion_bancaria (id_cuenta, id_tipo_transaccion, monto) VALUES (1, 1, 10000);

-- =====================================================
-- 6. CONSULTAS DE VERIFICACIÓN (PANTALLAZOS)
-- =====================================================

-- Consulta 1: Encomiendas
SELECT e.id_encomienda, r.nombre AS remitente, d.nombre AS destinatario, e.estado_actual
FROM encomienda e
JOIN cliente_envio r ON e.id_cliente_remitente = r.id_cliente
JOIN cliente_envio d ON e.id_cliente_destinatario = d.id_cliente;

-- Consulta 2: Ventas Retail
SELECT p.id_pedido, c.nombre AS cliente, pr.nombre AS producto, dp.cantidad, dp.precio_unitario
FROM pedido p
JOIN cliente_retail c ON p.id_cliente = c.id_cliente
JOIN detalle_pedido dp ON p.id_pedido = dp.id_pedido
JOIN producto pr ON dp.id_producto = pr.id_producto;

-- Consulta 3: Banca
SELECT cb.numero_cuenta, cb.saldo, tt.nombre AS operacion, tb.monto
FROM cuenta_bancaria cb
JOIN transaccion_bancaria tb ON cb.id_cuenta = tb.id_cuenta
JOIN tipo_transaccion tt ON tb.id_tipo_transaccion = tt.id_tipo_transaccion;

