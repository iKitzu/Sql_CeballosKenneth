-- ####################
-- Consultas multitabla

-- Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.

SELECT cliente.*
FROM cliente
LEFT JOIN pago ON cliente.codigo_cliente = pago.codigo_cliente
WHERE pago.codigo_cliente IS NULL;


-- Devuelve un listado que muestre solamente los clientes que no han realizado ningún pedido.

SELECT cliente.*
FROM cliente
LEFT JOIN pedido ON cliente.codigo_cliente = pedido.codigo_cliente
WHERE pedido.codigo_cliente IS NULL;

-- Devuelve un listado que muestre los clientes que no han realizado ningún pago y los que no han realizado ningún pedido.

SELECT DISTINCT cliente.*
FROM cliente
LEFT JOIN pago ON cliente.codigo_cliente = pago.codigo_cliente
LEFT JOIN pedido ON cliente.codigo_cliente = pedido.codigo_cliente
WHERE pago.codigo_cliente IS NULL OR pedido.codigo_cliente IS NULL;


-- # Devuelve un listado que muestre solamente los empleados que no tienen una oficina asociada.

SELECT empleado.*
FROM empleado
LEFT JOIN oficina ON empleado.codigo_oficina = oficina.codigo_oficina
WHERE oficina.codigo_oficina IS NULL;


-- Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado.

SELECT empleado.*
FROM empleado
LEFT JOIN cliente ON empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas
WHERE cliente.codigo_cliente IS NULL;


-- Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado junto con los datos de la oficina donde trabajan.

SELECT empleado.*, oficina.*
FROM empleado
LEFT JOIN cliente ON empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas
LEFT JOIN oficina ON empleado.codigo_oficina = oficina.codigo_oficina
WHERE cliente.codigo_cliente IS NULL;


-- Devuelve un listado que muestre los empleados que no tienen una oficina asociada y los que no tienen un cliente asociado.

SELECT DISTINCT empleado.*
FROM empleado
LEFT JOIN oficina ON empleado.codigo_oficina = oficina.codigo_oficina
LEFT JOIN cliente ON empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas
WHERE oficina.codigo_oficina IS NULL OR cliente.codigo_cliente IS NULL;

-- Devuelve un listado de los productos que nunca han aparecido en un pedido.

SELECT producto.*
FROM producto
LEFT JOIN detalle_pedido ON producto.codigo_producto = detalle_pedido.codigo_producto
WHERE detalle_pedido.codigo_producto IS NULL;

-- # Devuelve un listado de los productos que nunca han aparecido en un pedido. El resultado debe mostrar el nombre, la descripción y la imagen del producto.

SELECT producto.nombre, producto.descripcion, producto.imagen
FROM producto
LEFT JOIN detalle_pedido ON producto.codigo_producto = detalle_pedido.codigo_producto
WHERE detalle_pedido.codigo_producto IS NULL;

-- # Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales.

SELECT oficina.*
FROM oficina
LEFT JOIN empleado ON oficina.codigo_oficina = empleado.codigo_oficina
LEFT JOIN cliente ON empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas
LEFT JOIN pedido ON cliente.codigo_cliente = pedido.codigo_cliente
LEFT JOIN detalle_pedido ON pedido.codigo_pedido = detalle_pedido.codigo_pedido
LEFT JOIN producto ON detalle_pedido.codigo_producto = producto.codigo_producto
WHERE producto.gama = 'Frutales' AND empleado.codigo_empleado IS NULL;

-- Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.

SELECT cliente.*
FROM cliente
LEFT JOIN pedido ON cliente.codigo_cliente = pedido.codigo_cliente
LEFT JOIN pago ON cliente.codigo_cliente = pago.codigo_cliente
WHERE pedido.codigo_cliente IS NOT NULL AND pago.codigo_cliente IS NULL;

-- Devuelve un listado con los datos de los empleados que no tienen clientes asociados y el nombre de su jefe asociado.

SELECT empleado.*, jefe.nombre AS nombre_jefe, jefe.apellido1 AS apellido1_jefe, jefe.apellido2 AS apellido2_jefe
FROM empleado
LEFT JOIN cliente ON empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas
LEFT JOIN empleado jefe ON empleado.codigo_jefe = jefe.codigo_empleado
WHERE cliente.codigo_cliente IS NULL;

-- #################
-- Consultas resumen


-- ¿Cuántos empleados hay en la compañía?

SELECT COUNT(*) AS numero_empleados
FROM empleado;

-- ¿Cuántos clientes tiene cada país?

SELECT pais, COUNT(*) AS numero_clientes
FROM cliente
GROUP BY pais;

-- ¿Cuál fue el pago medio en 2009?

SELECT AVG(total) AS pago_medio_2009
FROM pago
WHERE YEAR(fecha_pago) = 2009;

-- ¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma descendente por el número de pedidos.

SELECT estado, COUNT(*) AS numero_pedidos
FROM pedido
GROUP BY estado
ORDER BY numero_pedidos DESC;

-- Calcula el precio de venta del producto más caro y más barato en una misma consulta.

SELECT MAX(precio_venta) AS precio_maximo, MIN(precio_venta) AS precio_minimo
FROM producto;

-- Calcula el número de clientes que tiene la empresa.

SELECT COUNT(*) AS numero_clientes
FROM cliente;

-- ¿Cuántos clientes existen con domicilio en la ciudad de Madrid?

SELECT COUNT(*) AS numero_clientes_madrid
FROM cliente
WHERE ciudad = 'Madrid';

-- Calcula cuántos clientes tiene cada una de las ciudades que empiezan por M.

SELECT ciudad, COUNT(*) AS numero_clientes
FROM cliente
WHERE ciudad LIKE 'M%'
GROUP BY ciudad;

-- Devuelve el nombre de los representantes de ventas y el número de clientes al que atiende cada uno.

SELECT e.nombre, e.apellido1, e.apellido2, COUNT(c.codigo_cliente) AS numero_clientes
FROM empleado e
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
GROUP BY e.codigo_empleado;

-- #IDK Calcula el número de clientes que no tiene asignado representante de ventas.

SELECT COUNT(*) AS numero_clientes_sin_rep_ventas
FROM cliente
WHERE codigo_empleado_rep_ventas IS NULL;

-- Calcula la fecha del primer y último pago realizado por cada uno de los clientes. El listado deberá mostrar el nombre y los apellidos de cada cliente.

SELECT c.nombre_cliente, c.nombre_contacto, c.apellido_contacto,
       MIN(p.fecha_pago) AS primer_pago, MAX(p.fecha_pago) AS ultimo_pago
FROM cliente c
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
GROUP BY c.codigo_cliente;

-- Calcula el número de productos diferentes que hay en cada uno de los pedidos.

SELECT codigo_pedido, COUNT(DISTINCT codigo_producto) AS numero_productos_diferentes
FROM detalle_pedido
GROUP BY codigo_pedido;

-- Calcula la suma de la cantidad total de todos los productos que aparecen en cada uno de los pedidos.

SELECT codigo_pedido, SUM(cantidad) AS cantidad_total
FROM detalle_pedido
GROUP BY codigo_pedido;

-- Devuelve un listado de los 20 productos más vendidos y el número total de unidades que se han vendido de cada uno. El listado deberá estar ordenado por el número total de unidades vendidas.

SELECT p.nombre, SUM(dp.cantidad) AS unidades_vendidas
FROM producto p
JOIN detalle_pedido dp ON p.codigo_producto = dp.codigo_producto
GROUP BY p.codigo_producto
ORDER BY unidades_vendidas DESC
LIMIT 20;

-- La facturación que ha tenido la empresa en toda la historia, indicando la base imponible, el IVA y el total facturado.

SELECT SUM(dp.cantidad * dp.precio_unidad) AS base_imponible,
       SUM(dp.cantidad * dp.precio_unidad) * 0.21 AS iva,
       SUM(dp.cantidad * dp.precio_unidad) * 1.21 AS total_facturado
FROM detalle_pedido dp;

-- La misma información que en la pregunta anterior, pero agrupada por código de producto.

SELECT dp.codigo_producto,
       SUM(dp.cantidad * dp.precio_unidad) AS base_imponible,
       SUM(dp.cantidad * dp.precio_unidad) * 0.21 AS iva,
       SUM(dp.cantidad * dp.precio_unidad) * 1.21 AS total_facturado
FROM detalle_pedido dp
GROUP BY dp.codigo_producto;

-- La misma información que en la pregunta anterior, pero agrupada por código de producto filtrada por los códigos que empiecen por OR.

SELECT dp.codigo_producto,
       SUM(dp.cantidad * dp.precio_unidad) AS base_imponible,
       SUM(dp.cantidad * dp.precio_unidad) * 0.21 AS iva,
       SUM(dp.cantidad * dp.precio_unidad) * 1.21 AS total_facturado
FROM detalle_pedido dp
WHERE dp.codigo_producto LIKE 'OR%'
GROUP BY dp.codigo_producto;

-- Lista las ventas totales de los productos que hayan facturado más de 3000 euros. Se mostrará el nombre, unidades vendidas, total facturado y total facturado con impuestos (21% IVA).

SELECT p.nombre,
       SUM(dp.cantidad) AS unidades_vendidas,
       SUM(dp.cantidad * dp.precio_unidad) AS total_facturado,
       SUM(dp.cantidad * dp.precio_unidad) * 1.21 AS total_con_iva
FROM producto p
JOIN detalle_pedido dp ON p.codigo_producto = dp.codigo_producto
GROUP BY p.codigo_producto
HAVING total_facturado > 3000;

-- Muestre la suma total de todos los pagos que se realizaron para cada uno de los años que aparecen en la tabla pagos.

SELECT YEAR(fecha_pago) AS ano, SUM(total) AS suma_total_pagos
FROM pago
GROUP BY YEAR(fecha_pago);

-- ############
-- Subconsultas

-- Devuelve el nombre del cliente con mayor límite de crédito.

SELECT nombre_cliente
FROM cliente
WHERE limite_credito = (SELECT MAX(limite_credito) FROM cliente);

-- Devuelve el nombre del producto que tenga el precio de venta más caro.

SELECT nombre
FROM producto
WHERE precio_venta = (SELECT MAX(precio_venta) FROM producto);

-- Devuelve el nombre del producto del que se han vendido más unidades.

SELECT nombre
FROM producto
WHERE codigo_producto = (
    SELECT codigo_producto
    FROM detalle_pedido
    GROUP BY codigo_producto
    ORDER BY SUM(cantidad) DESC
    LIMIT 1
);

-- Los clientes cuyo límite de crédito sea mayor que los pagos que haya realizado. (Sin utilizar INNER JOIN).

SELECT nombre_cliente
FROM cliente
WHERE limite_credito > (
    SELECT IFNULL(SUM(total), 0)
    FROM pago
    WHERE cliente.codigo_cliente = pago.codigo_cliente
);

-- Devuelve el producto que más unidades tiene en stock.

SELECT nombre
FROM producto
WHERE cantidad_en_stock = (SELECT MAX(cantidad_en_stock) FROM producto);

-- Devuelve el producto que menos unidades tiene en stock.

SELECT nombre
FROM producto
WHERE cantidad_en_stock = (SELECT MIN(cantidad_en_stock) FROM producto);

-- Devuelve el nombre, los apellidos y el email de los empleados que están a cargo de Alberto Soria.

SELECT nombre, apellido1, apellido2, email
FROM empleado
WHERE codigo_jefe = (
    SELECT codigo_empleado
    FROM empleado
    WHERE nombre = 'Alberto' AND apellido1 = 'Soria'
);


-- ###########################
-- Subconsultas con ALL y ANY

-- Devuelve el nombre del cliente con mayor límite de crédito.

SELECT nombre_cliente
FROM cliente
WHERE limite_credito >= ALL (SELECT limite_credito FROM cliente);

-- Devuelve el nombre del producto que tenga el precio de venta más caro.

SELECT nombre
FROM producto
WHERE precio_venta >= ALL (SELECT precio_venta FROM producto);

-- Devuelve el producto que menos unidades tiene en stock.

SELECT nombre
FROM producto
WHERE cantidad_en_stock <= ALL (SELECT cantidad_en_stock FROM producto);

-- #############################
-- Subconsultas con IN y NOT IN

-- Devuelve el nombre, apellido1 y cargo de los empleados que no representen a ningún cliente.

SELECT nombre, apellido1, puesto
FROM empleado
WHERE codigo_empleado NOT IN (SELECT codigo_empleado_rep_ventas FROM cliente);

-- Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.

SELECT nombre_cliente
FROM cliente
WHERE codigo_cliente NOT IN (SELECT codigo_cliente FROM pago);

-- Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago.

SELECT nombre_cliente
FROM cliente
WHERE codigo_cliente IN (SELECT codigo_cliente FROM pago);

-- Devuelve un listado de los productos que nunca han aparecido en un pedido.

SELECT nombre
FROM producto
WHERE codigo_producto NOT IN (SELECT codigo_producto FROM detalle_pedido);

-- Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no sean representante de ventas de ningún cliente.

SELECT e.nombre, e.apellido1, e.apellido2, e.puesto, o.telefono
FROM empleado e
JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE e.codigo_empleado NOT IN (SELECT codigo_empleado_rep_ventas FROM cliente);

-- Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales.

SELECT o.*
FROM oficina o
WHERE o.codigo_oficina NOT IN (
    SELECT e.codigo_oficina
    FROM empleado e
    JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
    JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
    JOIN detalle_pedido dp ON p.codigo_pedido = dp.codigo_pedido
    JOIN producto pr ON dp.codigo_producto = pr.codigo_producto
    WHERE pr.gama = 'Frutales'
);

-- #IDK Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.

SELECT nombre_cliente
FROM cliente
WHERE codigo_cliente IN (SELECT codigo_cliente FROM pedido)
AND codigo_cliente NOT IN (SELECT codigo_cliente FROM pago);

-- #####################################
-- Subconsultas con EXISTS y NOT EXISTS

-- Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.

SELECT nombre_cliente
FROM cliente c
WHERE NOT EXISTS (
    SELECT 1
    FROM pago p
    WHERE c.codigo_cliente = p.codigo_cliente
);

-- Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago.

SELECT nombre_cliente
FROM cliente c
WHERE EXISTS (
    SELECT 1
    FROM pago p
    WHERE c.codigo_cliente = p.codigo_cliente
);

-- Devuelve un listado de los productos que nunca han aparecido en un pedido.

SELECT nombre
FROM producto p
WHERE NOT EXISTS (
    SELECT 1
    FROM detalle_pedido dp
    WHERE p.codigo_producto = dp.codigo_producto
);

-- Devuelve un listado de los productos que han aparecido en un pedido alguna vez.

SELECT nombre
FROM producto p
WHERE EXISTS (
    SELECT 1
    FROM detalle_pedido dp
    WHERE p.codigo_producto = dp.codigo_producto
);
