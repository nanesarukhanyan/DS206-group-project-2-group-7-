USE ORDER_DDS;
GO


ALTER TABLE dim_customers
ADD
    sor_sk INT,
    staging_customers_raw_nk INT;
GO


ALTER TABLE dim_employees
ADD
    sor_sk INT,
    staging_employees_raw_nk INT;
GO


ALTER TABLE dim_categories
ADD
    sor_sk INT,
    staging_categories_raw_nk INT;
GO



ALTER TABLE dim_suppliers
ADD
    sor_sk INT,
    staging_suppliers_raw_nk INT;
GO



ALTER TABLE dim_products
ADD
    sor_sk INT,
    staging_products_raw_nk INT;
GO



ALTER TABLE dim_shippers
ADD
    sor_sk INT,
    staging_shippers_raw_nk INT;
GO



ALTER TABLE dim_region
ADD
    sor_sk INT,
    staging_region_raw_nk INT;
GO



ALTER TABLE dim_territories
ADD
    sor_sk INT,
    staging_territories_raw_nk INT;
GO
