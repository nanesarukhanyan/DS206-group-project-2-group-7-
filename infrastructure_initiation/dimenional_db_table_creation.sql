/*
task4
The dimensional database structure was derived using the primary key and foreign key relationships provided in Table 1 and Table 2.

The business process identified for the warehouse is order and sales analysis. The central fact table is FactOrders, which stores transactional order metrics and references all related dimensions.

The following dimension tables were identified:
- DimCategories
- DimCustomers
- DimEmployees
- DimProducts
- DimRegion
- DimShippers
- DimSuppliers
- DimTerritories
- DimDates

The dimensional model follows a star schema architecture where FactOrders is connected to all dimensions through surrogate foreign keys.

Based on Group 7 requirements from Table 3:
- DimCustomers and DimProducts use SCD Type 2
- DimRegion and DimTerritories use SCD Type 4
- DimSuppliers uses SCD Type 3
- DimEmployees and DimShippers use SCD1 with delete
- FactOrders follows a SNAPSHOT loading strategy
*/

USE ORDER_DDS;
GO

DROP TABLE IF EXISTS fact_orders;
GO

DROP TABLE IF EXISTS fact_error;
GO

DROP TABLE IF EXISTS fact_sales;
GO

DROP TABLE IF EXISTS dim_region_history;
GO

DROP TABLE IF EXISTS dim_territories_history;
GO

DROP TABLE IF EXISTS dim_sor;
GO

DROP TABLE IF EXISTS dim_dates;
GO

DROP TABLE IF EXISTS dim_territories;
GO

DROP TABLE IF EXISTS dim_region;
GO

DROP TABLE IF EXISTS dim_shippers;
GO

DROP TABLE IF EXISTS dim_products;
GO

DROP TABLE IF EXISTS dim_suppliers;
GO

DROP TABLE IF EXISTS dim_categories;
GO

DROP TABLE IF EXISTS dim_employees;
GO

DROP TABLE IF EXISTS dim_customers;
GO

CREATE TABLE dim_customers (

    customer_sk INT IDENTITY(1,1) PRIMARY KEY,

    customer_id NVARCHAR(10),
    company_name NVARCHAR(255),
    contact_name NVARCHAR(255),
    contact_title NVARCHAR(100),
    address NVARCHAR(255),
    city NVARCHAR(100),
    region NVARCHAR(100),
    postal_code NVARCHAR(20),
    country NVARCHAR(100),
    phone NVARCHAR(50),
    fax NVARCHAR(50),

    effective_start_date DATE,
    effective_end_date DATE,
    is_current BIT DEFAULT 1


);
GO


CREATE TABLE dim_employees (

    employee_sk INT IDENTITY(1,1) PRIMARY KEY,

    employee_id INT,
    last_name NVARCHAR(100),
    first_name NVARCHAR(100),
    title NVARCHAR(100),
    title_of_courtesy NVARCHAR(50),
    birth_date DATE,
    hire_date DATE,
    address NVARCHAR(255),
    city NVARCHAR(100),
    region NVARCHAR(100),
    postal_code NVARCHAR(20),
    country NVARCHAR(100),
    home_phone NVARCHAR(50),
    extension NVARCHAR(20),

    is_deleted BIT DEFAULT 0

);
GO

CREATE TABLE dim_categories (

    category_sk INT IDENTITY(1,1) PRIMARY KEY,

    category_id INT,
    category_name NVARCHAR(100),
    description NVARCHAR(MAX)

);
GO


CREATE TABLE dim_suppliers (

    supplier_sk INT IDENTITY(1,1) PRIMARY KEY,

    supplier_id INT,
    company_name NVARCHAR(255),
    contact_name NVARCHAR(255),
    contact_title NVARCHAR(100),
    address NVARCHAR(255),
    city NVARCHAR(100),
    current_region NVARCHAR(100),
    previous_region NVARCHAR(100),
    postal_code NVARCHAR(20),
    country NVARCHAR(100),
    phone NVARCHAR(50),
    fax NVARCHAR(50),
    homepage NVARCHAR(MAX)

);
GO


CREATE TABLE dim_products (

    product_sk INT IDENTITY(1,1) PRIMARY KEY,

    product_id INT,
    product_name NVARCHAR(255),
    supplier_id INT,
    category_id INT,
    quantity_per_unit NVARCHAR(100),
    unit_price DECIMAL(10,2),
    units_in_stock INT,
    units_on_order INT,
    reorder_level INT,
    discontinued BIT,

    effective_start_date DATE,
    effective_end_date DATE,
    is_current BIT DEFAULT 1,
    is_deleted BIT DEFAULT 0

);
GO


CREATE TABLE dim_shippers (

    shipper_sk INT IDENTITY(1,1) PRIMARY KEY,

    shipper_id INT,
    company_name NVARCHAR(255),
    phone NVARCHAR(50),

    is_deleted BIT DEFAULT 0

);
GO


CREATE TABLE dim_region (

    region_sk INT IDENTITY(1,1) PRIMARY KEY,

    region_id INT,
    region_description NVARCHAR(255)

);
GO

CREATE TABLE dim_region_history (

    region_history_sk INT IDENTITY(1,1) PRIMARY KEY,

    region_id INT,
    region_description NVARCHAR(255),

    effective_start_date DATE,
    effective_end_date DATE

);
GO

CREATE TABLE dim_territories (

    territory_sk INT IDENTITY(1,1) PRIMARY KEY,

    territory_id NVARCHAR(50),
    territory_description NVARCHAR(255),
    region_id INT

);
GO

CREATE TABLE dim_territories_history (

    territory_history_sk INT IDENTITY(1,1) PRIMARY KEY,

    territory_id NVARCHAR(50),
    territory_description NVARCHAR(255),
    region_id INT,

    effective_start_date DATE,
    effective_end_date DATE

);
GO



/* =========================
   DIM_DATES
========================= */
CREATE TABLE dim_dates (

    date_sk INT IDENTITY(1,1) PRIMARY KEY,

    full_date DATE,
    day_number INT,
    month_number INT,
    month_name NVARCHAR(20),
    quarter_number INT,
    year_number INT

);
GO



CREATE TABLE fact_orders (

    fact_order_sk INT IDENTITY(1,1) PRIMARY KEY,

    customer_sk INT,
    employee_sk INT,
    product_sk INT,
    supplier_sk INT,
    category_sk INT,
    shipper_sk INT,
    territory_sk INT,
    order_date_sk INT,

    order_id INT,

    quantity INT,
    unit_price DECIMAL(10,2),
    discount DECIMAL(10,2),
    freight DECIMAL(10,2),
    sales_amount DECIMAL(12,2),

    CONSTRAINT fk_fact_customer
        FOREIGN KEY (customer_sk)
        REFERENCES dim_customers(customer_sk),

    CONSTRAINT fk_fact_employee
        FOREIGN KEY (employee_sk)
        REFERENCES dim_employees(employee_sk),

    CONSTRAINT fk_fact_product
        FOREIGN KEY (product_sk)
        REFERENCES dim_products(product_sk),

    CONSTRAINT fk_fact_supplier
        FOREIGN KEY (supplier_sk)
        REFERENCES dim_suppliers(supplier_sk),

    CONSTRAINT fk_fact_category
        FOREIGN KEY (category_sk)
        REFERENCES dim_categories(category_sk),

    CONSTRAINT fk_fact_shipper
        FOREIGN KEY (shipper_sk)
        REFERENCES dim_shippers(shipper_sk),

    CONSTRAINT fk_fact_territory
        FOREIGN KEY (territory_sk)
        REFERENCES dim_territories(territory_sk),

    CONSTRAINT fk_fact_date
        FOREIGN KEY (order_date_sk)
        REFERENCES dim_dates(date_sk)

);
GO

USE ORDER_DDS;
GO


CREATE TABLE dim_sor (

    sor_sk INT IDENTITY(1,1) PRIMARY KEY,

    staging_raw_table_name NVARCHAR(255)

);
GO


CREATE TABLE fact_error (

    fact_error_sk INT IDENTITY(1,1) PRIMARY KEY,

    staging_raw_id_sk INT,

    order_id INT,
    customer_id NVARCHAR(10),
    employee_id INT,
    ship_via INT,
    order_date DATETIME,

    error_reason NVARCHAR(255),

    error_date DATETIME DEFAULT GETDATE()

);
GO