USE ORDER_DDS;
GO

MERGE dim_territories AS target

USING (

    SELECT
        s.staging_raw_id_sk AS staging_territories_raw_nk,
        sor.sor_sk,

        s.TerritoryID,
        s.TerritoryDescription,
        s.RegionID

    FROM staging_territories_raw s

    JOIN dim_sor sor
        ON sor.staging_raw_table_name = 'staging_territories_raw'

) AS source

ON target.territory_id = source.TerritoryID

WHEN MATCHED
AND (
    target.territory_description <> source.TerritoryDescription
    OR target.region_id <> source.RegionID
)

THEN

    UPDATE SET
        target.territory_description = source.TerritoryDescription,
        target.region_id = source.RegionID

WHEN NOT MATCHED THEN

    INSERT (
        sor_sk,
        staging_territories_raw_nk,
        territory_id,
        territory_description,
        region_id
    )

    VALUES (
        source.sor_sk,
        source.staging_territories_raw_nk,
        source.TerritoryID,
        source.TerritoryDescription,
        source.RegionID
    );

GO
