-------------------------------------------Creacion de tablas----------------------
-- Crar tabla producto
DROP TABLE producto;
CREATE TABLE producto(cod_producto NUMBER(1)PRIMARY KEY, nom_producto VARCHAR(30));
-- Crear tabla bodega
DROP TABLE bodega;
CREATE TABLE bodega(cod_bodega NUMBER(5)PRIMARY KEY, nom_bodega VARCHAR(30), ubicacion_x NUMBER(2) CHECK(ubicacion_x BETWEEN 1 and 99)
, ubicacion_y NUMBER(2) CHECK(ubicacion_y BETWEEN 1 and 99));
-- Crear tabla anidada pedido

DROP TYPE detalle_tipo FORCE;
CREATE OR REPLACE TYPE detalle_tipo
AS OBJECT( 
 cod_producto NUMBER(3), 
 cantidad NUMBER(10));
/
DROP TYPE nest_detalle FORCE;
CREATE OR REPLACE TYPE nest_detalle AS TABLE OF detalle_tipo;
/
DROP TYPE pedido_type FORCE;
CREATE OR REPLACE TYPE pedido_type AS 
OBJECT(cod_bodega NUMBER(3), 
       fecha NUMBER(5),
       detalles nest_detalle);
/
DROP TABLE pedido;
CREATE TABLE pedido OF pedido_type
NESTED TABLE detalles STORE AS store_detalle
((PRIMARY KEY(NESTED_TABLE_ID, cod_producto)));


alter table pedido ADD PRIMARY KEY (cod_bodega, fecha);
alter table pedido ADD CONSTRAINT  fecha_positiva CHECK(fecha > 0);


--Crear foraneas de pedido y detalle

alter table pedido
  add constraint foranea_bodega
  foreign key (cod_bodega)
  references bodega (cod_bodega);


-- Crear tabla aidada registro

DROP TYPE inventario_tipo FORCE;
CREATE OR REPLACE TYPE inventario_tipo
AS OBJECT( 
 cod_producto NUMBER(3), 
 existencias NUMBER(10));
/
DROP TYPE nest_inventario FORCE;
CREATE OR REPLACE TYPE nest_inventario AS TABLE OF inventario_tipo;
/
DROP TYPE registro_type FORCE;
CREATE OR REPLACE TYPE registro_type AS 
OBJECT(cod_bodega NUMBER(3), 
       inventario nest_inventario);
/
DROP TABLE registro;
CREATE TABLE registro OF registro_type
(cod_bodega PRIMARY KEY) 
NESTED TABLE inventario STORE AS store_inventario
((PRIMARY KEY(NESTED_TABLE_ID, cod_producto)));

--Crear foraneas de registro e inventario

alter table registro
  add constraint foranea_rbodega
  foreign key (cod_bodega)
  references bodega (cod_bodega)
  ON DELETE CASCADE; 
  
