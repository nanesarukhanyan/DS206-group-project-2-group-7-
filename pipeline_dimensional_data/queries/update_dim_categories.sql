USE ORDER_DDS;
GO

MERGE dim_categories AS target

USING (

    SELECT
        s.staging_raw_id_sk AS staging_categories_raw_nk,
        sor.sor_sk,

        s.CategoryID,
        s.CategoryName,
        s.Description

    FROM staging_categories_raw s

    JOIN dim_sor sor
        ON sor.staging_raw_table_name = 'staging_categories_raw'

) AS source

ON target.category_id = source.CategoryID

WHEN MATCHED THEN

    UPDATE SET
        target.category_name = source.CategoryName,
        target.description = source.Description

WHEN NOT MATCHED THEN

    INSERT (
        sor_sk,
        staging_categories_raw_nk,
        category_id,
        category_name,
        description
    )

    VALUES (
        source.sor_sk,
        source.staging_categories_raw_nk,
        source.CategoryID,
        source.CategoryName,
        source.Description
    );

GO