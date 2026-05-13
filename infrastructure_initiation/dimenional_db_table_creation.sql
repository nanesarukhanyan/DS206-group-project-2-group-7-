USE ORDER_DDS;
GO

/* =========================================================
   DIMENSION TABLES
========================================================= */

/* =========================
   DIM_CUSTOMERS
========================= */
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
    fax NVARCHAR(50)

);
GO


/* =========================
   DIM_EMPLOYEES
========================= */
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
    extension NVARCHAR(20)

);
GO


/* =========================
   DIM_CATEGORIES
========================= */
CREATE TABLE dim_categories (

    category_sk INT IDENTITY(1,1) PRIMARY KEY,

    category_id INT,
    category_name NVARCHAR(100),
    description NVARCHAR(MAX)

);
GO


/* =========================
   DIM_SUPPLIERS
========================= */
CREATE TABLE dim_suppliers (

    supplier_sk INT IDENTITY(1,1) PRIMARY KEY,

    supplier_id INT,
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
    homepage NVARCHAR(MAX)

);
GO


/* =========================
   DIM_PRODUCTS
========================= */
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
    discontinued BIT

);
GO


/* =========================
   DIM_SHIPPERS
========================= */
CREATE TABLE dim_shippers (

    shipper_sk INT IDENTITY(1,1) PRIMARY KEY,

    shipper_id INT,
    company_name NVARCHAR(255),
    phone NVARCHAR(50)

);
GO


/* =========================
   DIM_REGION
========================= */
CREATE TABLE dim_region (

    region_sk INT IDENTITY(1,1) PRIMARY KEY,

    region_id INT,
    region_description NVARCHAR(255)

);
GO


/* =========================
   DIM_TERRITORIES
========================= */
CREATE TABLE dim_territories (

    territory_sk INT IDENTITY(1,1) PRIMARY KEY,

    territory_id NVARCHAR(50),
    territory_description NVARCHAR(255),
    region_id INT

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



/* =========================================================
   FACT TABLE
========================================================= */

/* =========================
   FACT_SALES
========================= */
CREATE TABLE fact_sales (

    sales_sk INT IDENTITY(1,1) PRIMARY KEY,

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
