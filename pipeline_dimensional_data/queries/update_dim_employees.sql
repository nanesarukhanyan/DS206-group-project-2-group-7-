USE ORDER_DDS;
GO

MERGE dim_employees AS target

USING (

    SELECT
        s.staging_raw_id_sk AS staging_employees_raw_nk,
        sor.sor_sk,

        s.EmployeeID,
        s.LastName,
        s.FirstName,
        s.Title,
        s.TitleOfCourtesy,
        CAST(s.BirthDate AS DATE) AS BirthDate,
        CAST(s.HireDate AS DATE) AS HireDate,
        s.Address,
        s.City,
        s.Region,
        s.PostalCode,
        s.Country,
        s.HomePhone,
        s.Extension

    FROM staging_employees_raw s

    JOIN dim_sor sor
        ON sor.staging_raw_table_name = 'staging_employees_raw'

) AS source

ON target.employee_id = source.EmployeeID

WHEN MATCHED THEN

    UPDATE SET
        target.last_name = source.LastName,
        target.first_name = source.FirstName,
        target.title = source.Title,
        target.title_of_courtesy = source.TitleOfCourtesy,
        target.birth_date = source.BirthDate,
        target.hire_date = source.HireDate,
        target.address = source.Address,
        target.city = source.City,
        target.region = source.Region,
        target.postal_code = source.PostalCode,
        target.country = source.Country,
        target.home_phone = source.HomePhone,
        target.extension = source.Extension,
        target.is_deleted = 0

WHEN NOT MATCHED THEN

    INSERT (
        sor_sk,
        staging_employees_raw_nk,
        employee_id,
        last_name,
        first_name,
        title,
        title_of_courtesy,
        birth_date,
        hire_date,
        address,
        city,
        region,
        postal_code,
        country,
        home_phone,
        extension,
        is_deleted
    )

    VALUES (
        source.sor_sk,
        source.staging_employees_raw_nk,
        source.EmployeeID,
        source.LastName,
        source.FirstName,
        source.Title,
        source.TitleOfCourtesy,
        source.BirthDate,
        source.HireDate,
        source.Address,
        source.City,
        source.Region,
        source.PostalCode,
        source.Country,
        source.HomePhone,
        source.Extension,
        0
    );

GO
