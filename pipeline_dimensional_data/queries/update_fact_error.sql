DECLARE @start_date DATE = '2024-01-01';
DECLARE @end_date DATE = '2024-12-31';

INSERT INTO fact_error (

    staging_raw_id_sk,
    order_id,
    customer_id,
    employee_id,
    ship_via,
    order_date,
    error_reason

)

SELECT

    sr.staging_raw_id_sk,
    sr.OrderID,
    sr.CustomerID,
    sr.EmployeeID,
    sr.ShipVia,
    sr.OrderDate,

    CASE
        WHEN dc.customer_sk IS NULL THEN 'Missing Customer'
        WHEN de.employee_sk IS NULL THEN 'Missing Employee'
        WHEN dsh.shipper_sk IS NULL THEN 'Missing Shipper'
        ELSE 'Unknown Error'
    END AS error_reason

FROM staging_orders_raw sr

LEFT JOIN dim_customers dc
    ON sr.CustomerID = dc.customer_id

LEFT JOIN dim_employees de
    ON sr.EmployeeID = de.employee_id

LEFT JOIN dim_shippers dsh
    ON sr.ShipVia = dsh.shipper_id

WHERE (

    dc.customer_sk IS NULL
    OR de.employee_sk IS NULL
    OR dsh.shipper_sk IS NULL

)

AND sr.OrderDate BETWEEN @start_date AND @end_date;