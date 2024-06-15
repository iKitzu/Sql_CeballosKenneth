-- #############################
-- ## CONSULTAS INSANS :hot: ##
-- ############################

-- #########################
-- Consultas sobre una tabla
-- #########################


-- Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.

select codigo_oficina, ciudad
from oficina;

-- Devuelve un listado con la ciudad y el teléfono de las oficinas de España.

select ciudad, telefono
from oficina 
where pais = "España";

-- Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un código de jefe igual a 7.

select nombre, apellido1, apellido2, email
from empleado
where codigo_jefe = 7;

-- Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa.

select puesto, nombre, apellido1, apellido2, email
from empleado
where codigo_jefe is null;

-- Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean representantes de ventas.

select nombre, apellido1, apellido2, puesto
from empleado
where puesto!="Representante Ventas";

-- Devuelve un listado con el nombre de los todos los clientes españoles.

select nombre_cliente
from cliente
where pais= "Spain";

-- Devuelve un listado con los distintos estados por los que puede pasar un pedido.

select distinct estado
from pedido;

-- Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago en 2008. 
-- Tenga en cuenta que deberá eliminar aquellos códigos de cliente que aparezcan repetidos. 
-- Resuelva la consulta:
-- Utilizando la función YEAR de MySQL.

select distinct codigo_cliente
from pedido
where year(fecha_pedido) like "2008"; 

-- Utilizando la función DATE_FORMAT de MySQL.

select distinct codigo_cliente
from pedido
where date_format(fecha_pedido, "%Y") like "2008";

-- Sin utilizar ninguna de las funciones anteriores.

SELECT distinct codigo_cliente
from pedido
where extract(year from fecha_pedido)="2008";

-- Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos que no han sido entregados a tiempo.

Select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
from pedido
where date_format(fecha_esperada,"%M %d %Y")<date_format(fecha_entrega,"%M %d %Y");

-- Devuelve un listado con el código de pedido, código de cliente, fecha esperada y 
-- fecha de entrega de los pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha esperada.
-- Utilizando la función ADDDATE de MySQL.

select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
from pedido
where adddate(fecha_esperada, interval -2 day)>= fecha_entrega;

-- Utilizando la función DATEDIFF de MySQL.

SELECT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
from pedido where DATEDIFF(fecha_esperada,fecha_entrega)<=2;

-- ¿Sería posible resolver esta consulta utilizando el operador de suma + o resta -?

SELECT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
from pedido where fecha_esperada-fecha_entrega<=2; -- Se puede con resta pero no con suma

-- Devuelve un listado de todos los pedidos que fueron en 2009.

select * 
from pedido
where year(fecha_pedido) = "2009";

-- Devuelve un listado de todos los pedidos que han sido en el mes de enero de cualquier año.

select * 
from pedido
where month(fecha_pedido)= 1;

-- Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal. Ordene el resultado de mayor a menor.

select *
from pago
where year(fecha_pago) ="2008" and forma_pago = "PayPal"
-- Pa ordenarlas xd
order by total desc;

-- Devuelve un listado con todas las formas de pago que aparecen en la tabla pago. Tenga en cuenta que no deben aparecer formas de pago repetidas.

select distinct forma_pago 
from pago;

-- Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y que tienen más de 100 unidades en stock.
-- El listado deberá estar ordenado por su precio de venta, mostrando en primer lugar los de mayor precio.

select * 
from producto
where gama = "Ornamentales" and cantidad_en_stock>=100
order by precio_venta desc;

-- Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo representante de ventas tenga el código de empleado 11 o 30.

select *
from cliente
where ciudad ="Madrid" and (codigo_empleado_rep_ventas = 11 or codigo_empleado_rep_ventas = 30);

-- ##########################################
-- Consultas multitabla (Composición interna)
-- ##########################################

-- Resuelva todas las consultas mediante INNER JOIN y NATURAL JOIN.

-- Obtén un listado con el nombre de cada cliente y el nombre y apellido de su representante de ventas.

select cliente.nombre_cliente, empleado.nombre, empleado.apellido1, empleado.apellido2
from cliente
inner join empleado on cliente.codigo_empleado_rep_ventas=empleado.codigo_empleado;

-- Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus representantes de ventas.

select cliente.nombre_cliente, empleado.nombre, empleado.apellido1, empleado.apellido2
from cliente
inner join empleado on cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado
inner join pago on cliente.codigo_cliente = pago.codigo_cliente;

-- Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.
select cliente.nombre_cliente, empleado.nombre, empleado.apellido1, empleado.apellido2, oficina.ciudad
from cliente
inner join empleado on cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado
inner join oficina on empleado.codigo_oficina = oficina.codigo_oficina
inner join pago on cliente.codigo_cliente = pago.codigo_cliente;

-- Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.
select distinct oficina.linea_direccion1, oficina.linea_direccion2
from oficina
inner join empleado on oficina.codigo_oficina = empleado.codigo_oficina
inner join cliente on empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas
where cliente.ciudad = 'Fuenlabrada';

-- Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes.
select e1.nombre as empleado_nombre, e1.apellido1 as empleado_apellido1, e1.apellido2 as empleado_apellido2, 
       e2.nombre as jefe_nombre, e2.apellido1 as jefe_apellido1, e2.apellido2 as jefe_apellido2
from empleado e1
inner join empleado e2 on e1.codigo_jefe = e2.codigo_empleado;

-- Devuelve un listado que muestre el nombre de cada empleado, el nombre de su jefe y el nombre del jefe de su jefe.
select e1.nombre as empleado_nombre, e1.apellido1 as empleado_apellido1, e1.apellido2 as empleado_apellido2, 
       e2.nombre as jefe_nombre, e2.apellido1 as jefe_apellido1, e2.apellido2 as jefe_apellido2,
       e3.nombre as jefe_de_jefe_nombre, e3.apellido1 as jefe_de_jefe_apellido1, e3.apellido2 as jefe_de_jefe_apellido2
from empleado e1
inner join empleado e2 on e1.codigo_jefe = e2.codigo_empleado
inner join empleado e3 on e2.codigo_jefe = e3.codigo_empleado;

-- Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.
select distinct cliente.nombre_cliente
from cliente
inner join pedido on cliente.codigo_cliente = pedido.codigo_cliente
where pedido.fecha_entrega > pedido.fecha_esperada;

-- Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.
select cliente.nombre_cliente, producto.gama
from cliente
inner join pedido on cliente.codigo_cliente = pedido.codigo_cliente
inner join detalle_pedido on pedido.codigo_pedido = detalle_pedido.codigo_pedido
inner join producto on detalle_pedido.codigo_producto = producto.codigo_producto
group by cliente.nombre_cliente, producto.gama;