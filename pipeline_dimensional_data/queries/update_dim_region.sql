
USE ORDER_DDS;
GO

MERGE dim_region AS target

USING (

    SELECT
        s.staging_raw_id_sk AS staging_region_raw_nk,
        sor.sor_sk,

        s.RegionID,
        s.RegionDescription

    FROM staging_region_raw s

    JOIN dim_sor sor
        ON sor.staging_raw_table_name = 'staging_region_raw'

) AS source

ON target.region_id = source.RegionID

WHEN MATCHED
AND target.region_description <> source.RegionDescription

THEN

    UPDATE SET
        target.region_description = source.RegionDescription

WHEN NOT MATCHED THEN

    INSERT (
        sor_sk,
        staging_region_raw_nk,
        region_id,
        region_description
    )

    VALUES (
        source.sor_sk,
        source.staging_region_raw_nk,
        source.RegionID,
        source.RegionDescription
    );

GO