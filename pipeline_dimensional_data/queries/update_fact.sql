USE ORDER_DDS;
GO

DECLARE @start_date DATE = '1996-01-01';
DECLARE @end_date DATE = '1998-12-31';

MERGE fact_orders AS target

USING (

    SELECT

        dc.customer_sk,
        de.employee_sk,
        dp.product_sk,
        ds.supplier_sk,
        dcat.category_sk,
        dship.shipper_sk,
        dt.territory_sk,
        dd.date_sk AS order_date_sk,

        o.OrderID,

        od.Quantity,
        od.UnitPrice,
        od.Discount,

        o.Freight,

        (od.Quantity * od.UnitPrice)
            * (1 - od.Discount) AS sales_amount

    FROM staging_orders_raw o

    JOIN staging_order_details_raw od
        ON o.OrderID = od.OrderID

    JOIN dim_customers dc
        ON o.CustomerID = dc.customer_id
        AND dc.is_current = 1

    JOIN dim_employees de
        ON o.EmployeeID = de.employee_id

    JOIN dim_products dp
        ON od.ProductID = dp.product_id
        AND dp.is_current = 1

    JOIN dim_suppliers ds
        ON dp.supplier_id = ds.supplier_id

    JOIN dim_categories dcat
        ON dp.category_id = dcat.category_id

    JOIN dim_shippers dship
        ON o.ShipVia = dship.shipper_id

    JOIN dim_territories dt
        ON o.TerritoryID = dt.territory_id

    JOIN dim_dates dd
        ON CAST(o.OrderDate AS DATE) = dd.full_date

    WHERE CAST(o.OrderDate AS DATE)
        BETWEEN @start_date AND @end_date

) AS source

ON target.order_id = source.OrderID
AND target.product_sk = source.product_sk

WHEN MATCHED THEN

    UPDATE SET
        target.quantity = source.Quantity,
        target.unit_price = source.UnitPrice,
        target.discount = source.Discount,
        target.freight = source.Freight,
        target.sales_amount = source.sales_amount

WHEN NOT MATCHED THEN

    INSERT (

        customer_sk,
        employee_sk,
        product_sk,
        supplier_sk,
        category_sk,
        shipper_sk,
        territory_sk,
        order_date_sk,

        order_id,

        quantity,
        unit_price,
        discount,
        freight,
        sales_amount

    )

    VALUES (

        source.customer_sk,
        source.employee_sk,
        source.product_sk,
        source.supplier_sk,
        source.category_sk,
        source.shipper_sk,
        source.territory_sk,
        source.order_date_sk,

        source.OrderID,

        source.Quantity,
        source.UnitPrice,
        source.Discount,
        source.Freight,
        source.sales_amount
    );

GO
