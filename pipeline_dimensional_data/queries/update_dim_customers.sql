USE ORDER_DDS;
GO

MERGE dim_customers AS target

USING (

    SELECT
        s.staging_raw_id_sk AS staging_customers_raw_nk,
        sor.sor_sk,

        s.CustomerID,
        s.CompanyName,
        s.ContactName,
        s.ContactTitle,
        s.Address,
        s.City,
        s.Region,
        s.PostalCode,
        s.Country,
        s.Phone,
        s.Fax

    FROM staging_customers_raw s

    JOIN dim_sor sor
        ON sor.staging_raw_table_name = 'staging_customers_raw'

) AS source

ON target.customer_id = source.CustomerID
AND target.is_current = 1

WHEN MATCHED
AND (
    target.company_name <> source.CompanyName
    OR target.contact_name <> source.ContactName
    OR target.city <> source.City
    OR target.country <> source.Country
)

THEN

    UPDATE SET
        target.is_current = 0,
        target.effective_end_date = GETDATE()

WHEN NOT MATCHED THEN

    INSERT (
        sor_sk,
        staging_customers_raw_nk,
        customer_id,
        company_name,
        contact_name,
        contact_title,
        address,
        city,
        region,
        postal_code,
        country,
        phone,
        fax,
        effective_start_date,
        effective_end_date,
        is_current
    )

    VALUES (
        source.sor_sk,
        source.staging_customers_raw_nk,
        source.CustomerID,
        source.CompanyName,
        source.ContactName,
        source.ContactTitle,
        source.Address,
        source.City,
        source.Region,
        source.PostalCode,
        source.Country,
        source.Phone,
        source.Fax,
        GETDATE(),
        NULL,
        1
    );

GO
