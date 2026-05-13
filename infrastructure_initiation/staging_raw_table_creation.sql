USE ORDER_DDS;
GO

---------------------------------------------------
-- STAGING RAW: Categories
---------------------------------------------------
CREATE TABLE staging_categories_raw (
    staging_raw_id_sk INT IDENTITY(1,1) PRIMARY KEY,

    CategoryID INT,
    CategoryName NVARCHAR(255),
    Description NVARCHAR(MAX)
);
GO

---------------------------------------------------
-- STAGING RAW: Customers
---------------------------------------------------
CREATE TABLE staging_customers_raw (
    staging_raw_id_sk INT IDENTITY(1,1) PRIMARY KEY,

    CustomerID NVARCHAR(10),
    CompanyName NVARCHAR(255),
    ContactName NVARCHAR(255),
    ContactTitle NVARCHAR(255),
    Address NVARCHAR(255),
    City NVARCHAR(100),
    Region NVARCHAR(100),
    PostalCode NVARCHAR(50),
    Country NVARCHAR(100),
    Phone NVARCHAR(50),
    Fax NVARCHAR(50)
);
GO

---------------------------------------------------
-- STAGING RAW: Employees
---------------------------------------------------
CREATE TABLE staging_employees_raw (
    staging_raw_id_sk INT IDENTITY(1,1) PRIMARY KEY,

    EmployeeID INT,
    LastName NVARCHAR(255),
    FirstName NVARCHAR(255),
    Title NVARCHAR(255),
    TitleOfCourtesy NVARCHAR(50),
    BirthDate DATETIME,
    HireDate DATETIME,
    Address NVARCHAR(255),
    City NVARCHAR(100),
    Region NVARCHAR(100),
    PostalCode NVARCHAR(50),
    Country NVARCHAR(100),
    HomePhone NVARCHAR(50),
    Extension NVARCHAR(50),
    Notes NVARCHAR(MAX),
    ReportsTo INT,
    PhotoPath NVARCHAR(255)
);
GO

---------------------------------------------------
-- STAGING RAW: Order Details
---------------------------------------------------
CREATE TABLE staging_order_details_raw (
    staging_raw_id_sk INT IDENTITY(1,1) PRIMARY KEY,

    OrderID INT,
    ProductID INT,
    UnitPrice DECIMAL(10,2),
    Quantity INT,
    Discount FLOAT
);
GO

---------------------------------------------------
-- STAGING RAW: Orders
---------------------------------------------------
CREATE TABLE staging_orders_raw (
    staging_raw_id_sk INT IDENTITY(1,1) PRIMARY KEY,

    OrderID INT,
    CustomerID NVARCHAR(10),
    EmployeeID INT,
    OrderDate DATETIME,
    RequiredDate DATETIME,
    ShippedDate DATETIME,
    ShipVia INT,
    Freight DECIMAL(10,2),
    ShipName NVARCHAR(255),
    ShipAddress NVARCHAR(255),
    ShipCity NVARCHAR(100),
    ShipRegion NVARCHAR(100),
    ShipPostalCode NVARCHAR(50),
    ShipCountry NVARCHAR(100),
    TerritoryID NVARCHAR(50)
);
GO

---------------------------------------------------
-- STAGING RAW: Products
---------------------------------------------------
CREATE TABLE staging_products_raw (
    staging_raw_id_sk INT IDENTITY(1,1) PRIMARY KEY,

    ProductID INT,
    ProductName NVARCHAR(255),
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit NVARCHAR(100),
    UnitPrice DECIMAL(10,2),
    UnitsInStock INT,
    UnitsOnOrder INT,
    ReorderLevel INT,
    Discontinued BIT
);
GO

---------------------------------------------------
-- STAGING RAW: Region
---------------------------------------------------
CREATE TABLE staging_region_raw (
    staging_raw_id_sk INT IDENTITY(1,1) PRIMARY KEY,

    RegionID INT,
    RegionDescription NVARCHAR(255)
);
GO

---------------------------------------------------
-- STAGING RAW: Shippers
---------------------------------------------------
CREATE TABLE staging_shippers_raw (
    staging_raw_id_sk INT IDENTITY(1,1) PRIMARY KEY,

    ShipperID INT,
    CompanyName NVARCHAR(255),
    Phone NVARCHAR(50)
);
GO

---------------------------------------------------
-- STAGING RAW: Suppliers
---------------------------------------------------
CREATE TABLE staging_suppliers_raw (
    staging_raw_id_sk INT IDENTITY(1,1) PRIMARY KEY,

    SupplierID INT,
    CompanyName NVARCHAR(255),
    ContactName NVARCHAR(255),
    ContactTitle NVARCHAR(255),
    Address NVARCHAR(255),
    City NVARCHAR(100),
    Region NVARCHAR(100),
    PostalCode NVARCHAR(50),
    Country NVARCHAR(100),
    Phone NVARCHAR(50),
    Fax NVARCHAR(50),
    HomePage NVARCHAR(MAX)
);
GO

---------------------------------------------------
-- STAGING RAW: Territories
---------------------------------------------------
CREATE TABLE staging_territories_raw (
    staging_raw_id_sk INT IDENTITY(1,1) PRIMARY KEY,

    TerritoryID NVARCHAR(50),
    TerritoryDescription NVARCHAR(255),
    RegionID INT
);
GO
