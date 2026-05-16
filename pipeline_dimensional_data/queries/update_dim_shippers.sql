USE ORDER_DDS;
GO

MERGE dim_shippers AS target

USING (

    SELECT
        s.staging_raw_id_sk AS staging_shippers_raw_nk,
        sor.sor_sk,

        s.ShipperID,
        s.CompanyName,
        s.Phone

    FROM staging_shippers_raw s

    JOIN dim_sor sor
        ON sor.staging_raw_table_name = 'staging_shippers_raw'

) AS source

ON target.shipper_id = source.ShipperID

WHEN MATCHED THEN

    UPDATE SET
        target.company_name = source.CompanyName,
        target.phone = source.Phone,
        target.is_deleted = 0

WHEN NOT MATCHED THEN

    INSERT (
        sor_sk,
        staging_shippers_raw_nk,
        shipper_id,
        company_name,
        phone,
        is_deleted
    )

    VALUES (
        source.sor_sk,
        source.staging_shippers_raw_nk,
        source.ShipperID,
        source.CompanyName,
        source.Phone,
        0
    );

GO
