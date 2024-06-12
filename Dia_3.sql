create database Dia_03;

use Dia_03;

show tables;

CREATE TABLE gama_producto (
    gama VARCHAR(50) PRIMARY KEY NOT NULL,
    descripcion_texto TEXT NOT NULL,
    descripcion_html TEXT NOT NULL,
    imagen VARCHAR(256) NOT NULL
);

CREATE TABLE producto (
    codigo_producto VARCHAR(15) PRIMARY KEY NOT NULL,
    nombre VARCHAR(70),
    gama VARCHAR(50),
    dimensiones VARCHAR(25) NOT NULL,
    proveedor VARCHAR(50) NOT NULL,
    descripcion TEXT NOT NULL,
    cantidad_en_stock SMALLINT(6),
    precio_venta DECIMAL(15,2),
    precio_proveedor DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (gama) REFERENCES gama_producto(gama)
);

CREATE TABLE cliente (
    codigo_cliente INT(11) AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nombre_cliente VARCHAR(50),
    nombre_contacto VARCHAR(30) NOT NULL,
    apellido_contacto VARCHAR(30) NOT NULL,
    telefono VARCHAR(15),
    fax VARCHAR(15),
    linea_direccion1 VARCHAR(50),
    linea_direccion2 VARCHAR(50) NOT NULL,
    ciudad VARCHAR(50),
    region VARCHAR(50) NOT NULL,
    pais VARCHAR(50) NOT NULL,
    codigo_postal VARCHAR(10) NOT NULL,
    codigo_empleado_rep_ventas INT(11) NOT NULL,
    limite_credito DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (codigo_empleado_rep_ventas) REFERENCES empleado(codigo_empleado)
);

CREATE TABLE oficina (
    codigo_oficina VARCHAR(10) PRIMARY KEY NOT NULL,
    ciudad VARCHAR(30),
    pais VARCHAR(50),
    region VARCHAR(50) NOT NULL,
    codigo_postal VARCHAR(10),
    telefono VARCHAR(20),
    linea_direccion1 VARCHAR(50),
    linea_direccion2 VARCHAR(50) NOT NULL
);

CREATE TABLE empleado (
    codigo_empleado INT(11) AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido1 VARCHAR(50),
    apellido2 VARCHAR(50),
    extension VARCHAR(10) NOT NULL,
    email VARCHAR(100),
    codigo_oficina VARCHAR(10),
    codigo_jefe INT(11) NOT NULL,
    puesto VARCHAR(50) NOT NULL,
    FOREIGN KEY (codigo_oficina) REFERENCES oficina(codigo_oficina),
    FOREIGN KEY (codigo_jefe) REFERENCES empleado(codigo_empleado)
);

CREATE TABLE pedido (
    codigo_pedido INT(11) AUTO_INCREMENT PRIMARY KEY,
    fecha_pedido DATE,
    fecha_esperada DATE,
    fecha_entrega DATE NOT NULL,
    estado VARCHAR(15),
    comentarios TEXT NOT NULL,
    codigo_cliente INT(11),
    FOREIGN KEY (codigo_cliente) REFERENCES cliente(codigo_cliente)
);

CREATE TABLE detalle_pedido (
    codigo_pedido INT(11),
    codigo_producto VARCHAR(15),
    cantidad INT(11) NOT NULL,
    precio_unidad DECIMAL(15,2),
    numero_linea SMALLINT NOT NULL,
    PRIMARY KEY (codigo_pedido, codigo_producto, numero_linea),
    FOREIGN KEY (codigo_pedido) REFERENCES pedido(codigo_pedido),
    FOREIGN KEY (codigo_producto) REFERENCES producto(codigo_producto)
);

CREATE TABLE pago (
    codigo_cliente INT(11),
    forma_pago VARCHAR(40),
    id_transaccion VARCHAR(50) PRIMARY KEY,
    fecha_pago DATE,
    total DECIMAL(15,2),
    PRIMARY KEY (codigo_cliente, id_transaccion),
    FOREIGN KEY (codigo_cliente) REFERENCES cliente(codigo_cliente)
);
