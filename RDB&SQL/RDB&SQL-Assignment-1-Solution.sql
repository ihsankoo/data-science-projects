IF EXISTS (SELECT * FROM sys.databases WHERE name = 'Manufacturer')
BEGIN
DROP DATABASE [Manufacturer];
END
GO

CREATE DATABASE [Manufacturer];
GO

USE [Manufacturer];
GO

CREATE TABLE [Product] (
[prod_id] INT IDENTITY(1,1) NOT NULL,
[prod_name] NVARCHAR(50) NOT NULL,
[quantity] INT NOT NULL,
PRIMARY KEY ([prod_id])
);

CREATE TABLE [Prod_Comp] (
[prod_id] INT NOT NULL,
[comp_id] INT NOT NULL,
[quantity_comp] INT NOT NULL,
PRIMARY KEY ([prod_id], [comp_id]),
FOREIGN KEY ([prod_id]) REFERENCES Product
);

CREATE TABLE [Component] (
[comp_id] INT IDENTITY(1,1) NOT NULL,
[comp_name] NVARCHAR(50) NOT NULL,
[description] NVARCHAR(50) NOT NULL,
[quantity_comp] INT NOT NULL,
PRIMARY KEY ([comp_id])
);

CREATE TABLE [Comp_Supp] (
[supp_id] INT NOT NULL,
[comp_id] INT NOT NULL,
[order_date] DATE NOT NULL,
[quantity] INT NOT NULL,
PRIMARY KEY ([comp_id], [supp_id]),
FOREIGN KEY ([comp_id]) REFERENCES Component
);

CREATE TABLE [Supplier] (
[supp_id] INT IDENTITY(1,1) NOT NULL,
[supp_name] NVARCHAR(50) NOT NULL,
[supp_location] NVARCHAR(50) NOT NULL,
[supp_country] NVARCHAR(50) NOT NULL,
[is_active] BIT NOT NULL DEFAULT 1,
PRIMARY KEY ([supp_id])
);
