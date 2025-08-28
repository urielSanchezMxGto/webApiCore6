-- ==============================================
-- CREAR BASE DE DATOS
-- ==============================================
IF DB_ID('EmpresaDB') IS NOT NULL
    DROP DATABASE EmpresaDB;
GO

CREATE DATABASE EmpresaDB;
GO

USE EmpresaDB;
GO

-- ==============================================
-- CREACIÓN DE TABLAS
-- ==============================================

IF OBJECT_ID('FacturaDetalle') IS NOT NULL DROP TABLE FacturaDetalle;
IF OBJECT_ID('Facturas') IS NOT NULL DROP TABLE Facturas;
IF OBJECT_ID('Articulos') IS NOT NULL DROP TABLE Articulos;
IF OBJECT_ID('Vendedores') IS NOT NULL DROP TABLE Vendedores;
IF OBJECT_ID('Clientes') IS NOT NULL DROP TABLE Clientes;
IF OBJECT_ID('Ciudades') IS NOT NULL DROP TABLE Ciudades;
IF OBJECT_ID('Estados') IS NOT NULL DROP TABLE Estados;
GO

CREATE TABLE Estados (
    IdEstado INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL
);

CREATE TABLE Ciudades (
    IdCiudad INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    IdEstado INT NOT NULL FOREIGN KEY REFERENCES Estados(IdEstado)
);

CREATE TABLE Clientes (
    IdCliente INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(150) NOT NULL,
    Direccion NVARCHAR(200),
    CodigoPostal NVARCHAR(10),
    IdCiudad INT NOT NULL FOREIGN KEY REFERENCES Ciudades(IdCiudad)
);

CREATE TABLE Vendedores (
    IdVendedor INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(150) NOT NULL,
    Direccion NVARCHAR(200),
    CodigoPostal NVARCHAR(10),
    IdCiudad INT NOT NULL FOREIGN KEY REFERENCES Ciudades(IdCiudad),
    IdVendedorSupervisor INT NULL FOREIGN KEY REFERENCES Vendedores(IdVendedor)
);

CREATE TABLE Articulos (
    IdArticulo INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion NVARCHAR(200) NOT NULL,
    Precio DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL,
    StockMinimo INT NOT NULL
);

CREATE TABLE Facturas (
    IdFactura INT IDENTITY(1,1) PRIMARY KEY,
    Fecha DATE NOT NULL,
    IdCliente INT NOT NULL FOREIGN KEY REFERENCES Clientes(IdCliente),
    IdVendedor INT NOT NULL FOREIGN KEY REFERENCES Vendedores(IdVendedor),
    Iva DECIMAL(5,2) NOT NULL
);

CREATE TABLE FacturaDetalle (
    IdFactura INT NOT NULL FOREIGN KEY REFERENCES Facturas(IdFactura),
    NumLinea INT NOT NULL,
    Cantidad INT NOT NULL,
    IdArticulo INT NOT NULL FOREIGN KEY REFERENCES Articulos(IdArticulo),
    Precio DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (IdFactura, NumLinea)
);

-- ==============================================
-- INSERTAR DATOS DUMMY
-- ==============================================

-- Estados
INSERT INTO Estados (Nombre)
VALUES ('Jalisco'),('Nuevo León'),('CDMX'),('Yucatán'),('Zacatecas');

-- Ciudades
INSERT INTO Ciudades (Nombre, IdEstado)
VALUES ('Guadalajara',1),('Zapopan',1),('Monterrey',2),('San Nicolás',2),
       ('Coyoacán',3),('Iztapalapa',3),('Mérida',4),('Valladolid',4),
       ('Zacatecas',5),('Fresnillo',5);

-- Clientes (20 dummy)
INSERT INTO Clientes (Nombre, Direccion, CodigoPostal, IdCiudad)
VALUES 
('Cliente A','Calle 1','44100',1),
('Cliente B','Calle 2','44110',2),
('Cliente C','Av 123','64000',3),
('Cliente D','Col Roma','03000',5),
('Cliente E','Col Centro','97000',7),
('Cliente F','Col Sur','99100',9),
('Cliente G','Calle Norte','44120',1),
('Cliente H','Av Central','64010',4),
('Cliente I','Calle Larga','03010',6),
('Cliente J','Col Este','97010',8),
('Cliente K','Calle Oeste','99110',10),
('Cliente L','Privada 1','44130',2),
('Cliente M','Privada 2','44140',1),
('Cliente N','Av Hidalgo','64020',3),
('Cliente O','Av Juárez','03020',5),
('Cliente P','Col San Luis','97020',7),
('Cliente Q','Col Norte','99120',9),
('Cliente R','Calle Real','44150',2),
('Cliente S','Av Reforma','64030',4),
('Cliente T','Col Industrial','03030',6);

-- Vendedores (10 dummy, algunos con supervisores)
INSERT INTO Vendedores (Nombre, Direccion, CodigoPostal, IdCiudad, IdVendedorSupervisor)
VALUES 
('Vendedor 1','Dir V1','44100',1,NULL),
('Vendedor 2','Dir V2','44110',2,1),
('Vendedor 3','Dir V3','64000',3,1),
('Vendedor 4','Dir V4','03000',5,2),
('Vendedor 5','Dir V5','97000',7,2),
('Vendedor 6','Dir V6','99100',9,3),
('Vendedor 7','Dir V7','44120',1,3),
('Vendedor 8','Dir V8','64010',4,4),
('Vendedor 9','Dir V9','03010',6,5),
('Vendedor 10','Dir V10','97010',8,6);

-- Articulos (15 dummy)
INSERT INTO Articulos (Descripcion, Precio, Stock, StockMinimo)
VALUES 
('Laptop',15000,50,5),
('Mouse',300,200,20),
('Teclado',500,150,15),
('Monitor',4000,80,10),
('Impresora',3500,60,5),
('USB 32GB',200,500,50),
('Disco Duro 1TB',1800,100,10),
('Memoria RAM 8GB',1200,120,15),
('Silla Oficina',2500,40,5),
('Escritorio',5000,30,3),
('Cámara Web',900,90,10),
('Audífonos',700,150,20),
('Proyector',8000,15,2),
('Tablet',6000,35,5),
('Smartphone',12000,45,5);

-- Facturas (20 dummy)
INSERT INTO Facturas (Fecha, IdCliente, IdVendedor, Iva)
VALUES 
('2023-01-01',1,1,16),('2023-01-02',2,2,16),('2023-01-03',3,3,16),
('2023-01-04',4,4,16),('2023-01-05',5,5,16),('2023-01-06',6,6,16),
('2023-01-07',7,7,16),('2023-01-08',8,8,16),('2023-01-09',9,9,16),
('2023-01-10',10,10,16),('2023-01-11',11,1,16),('2023-01-12',12,2,16),
('2023-01-13',13,3,16),('2023-01-14',14,4,16),('2023-01-15',15,5,16),
('2023-01-16',16,6,16),('2023-01-17',17,7,16),('2023-01-18',18,8,16),
('2023-01-19',19,9,16),('2023-01-20',20,10,16);

-- FacturaDetalle (35 dummy líneas)
INSERT INTO FacturaDetalle (IdFactura, NumLinea, Cantidad, IdArticulo, Precio)
VALUES
(1,1,1,1,15000),(1,2,2,2,300),(2,1,1,3,500),
(2,2,1,4,4000),(3,1,2,5,3500),(3,2,3,6,200),
(4,1,1,7,1800),(5,1,2,8,1200),(6,1,1,9,2500),
(7,1,1,10,5000),(8,1,2,11,900),(9,1,2,12,700),
(10,1,1,13,8000),(11,1,1,14,6000),(12,1,2,15,12000),
(13,1,3,2,300),(14,1,1,3,500),(15,1,2,4,4000),
(16,1,2,5,3500),(17,1,1,6,200),(18,1,1,7,1800),
(19,1,1,8,1200),(20,1,2,9,2500),(20,2,1,1,15000),
(5,2,1,2,300),(6,2,1,3,500),(7,2,1,4,4000),
(8,2,1,5,3500),(9,2,2,6,200),(10,2,2,7,1800),
(11,2,2,8,1200),(12,2,1,9,2500),(13,2,1,10,5000),
(14,2,2,11,900),(15,2,2,12,700);
