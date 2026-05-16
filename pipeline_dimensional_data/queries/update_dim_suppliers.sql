USE ORDER_DDS;
GO

MERGE dim_suppliers AS target

USING (

    SELECT
        s.staging_raw_id_sk AS staging_suppliers_raw_nk,
        sor.sor_sk,

        s.SupplierID,
        s.CompanyName,
        s.ContactName,
        s.ContactTitle,
        s.Address,
        s.City,
        s.Region,
        s.PostalCode,
        s.Country,
        s.Phone,
        s.Fax,
        s.HomePage

    FROM staging_suppliers_raw s

    JOIN dim_sor sor
        ON sor.staging_raw_table_name = 'staging_suppliers_raw'

) AS source

ON target.supplier_id = source.SupplierID

WHEN MATCHED THEN

    UPDATE SET

        target.previous_region = target.current_region,
        target.current_region = source.Region,

        target.company_name = source.CompanyName,
        target.contact_name = source.ContactName,
        target.contact_title = source.ContactTitle,
        target.address = source.Address,
        target.city = source.City,
        target.postal_code = source.PostalCode,
        target.country = source.Country,
        target.phone = source.Phone,
        target.fax = source.Fax,
        target.homepage = source.HomePage

WHEN NOT MATCHED THEN

    INSERT (

        sor_sk,
        staging_suppliers_raw_nk,

        supplier_id,
        company_name,
        contact_name,
        contact_title,
        address,
        city,

        current_region,
        previous_region,

        postal_code,
        country,
        phone,
        fax,
        homepage

    )

    VALUES (

        source.sor_sk,
        source.staging_suppliers_raw_nk,

        source.SupplierID,
        source.CompanyName,
        source.ContactName,
        source.ContactTitle,
        source.Address,
        source.City,

        source.Region,
        NULL,

        source.PostalCode,
        source.Country,
        source.Phone,
        source.Fax,
        source.HomePage
    );

GO