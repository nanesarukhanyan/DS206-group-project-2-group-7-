USE ORDER_DDS;
GO

MERGE dim_products AS target

USING (

    SELECT
        s.staging_raw_id_sk AS staging_products_raw_nk,
        sor.sor_sk,

        s.ProductID,
        s.ProductName,
        s.SupplierID,
        s.CategoryID,
        s.QuantityPerUnit,
        s.UnitPrice,
        s.UnitsInStock,
        s.UnitsOnOrder,
        s.ReorderLevel,
        s.Discontinued

    FROM staging_products_raw s

    JOIN dim_sor sor
        ON sor.staging_raw_table_name = 'staging_products_raw'

) AS source

ON target.product_id = source.ProductID
AND target.is_current = 1

WHEN MATCHED
AND (

    target.product_name <> source.ProductName
    OR target.unit_price <> source.UnitPrice
    OR target.units_in_stock <> source.UnitsInStock
    OR target.discontinued <> source.Discontinued

)

THEN

    UPDATE SET
        target.is_current = 0,
        target.effective_end_date = GETDATE()

WHEN NOT MATCHED THEN

    INSERT (

        sor_sk,
        staging_products_raw_nk,

        product_id,
        product_name,
        supplier_id,
        category_id,
        quantity_per_unit,
        unit_price,
        units_in_stock,
        units_on_order,
        reorder_level,
        discontinued,

        effective_start_date,
        effective_end_date,
        is_current,
        is_deleted

    )

    VALUES (

        source.sor_sk,
        source.staging_products_raw_nk,

        source.ProductID,
        source.ProductName,
        source.SupplierID,
        source.CategoryID,
        source.QuantityPerUnit,
        source.UnitPrice,
        source.UnitsInStock,
        source.UnitsOnOrder,
        source.ReorderLevel,
        source.Discontinued,

        GETDATE(),
        NULL,
        1,
        0
    );

GO
