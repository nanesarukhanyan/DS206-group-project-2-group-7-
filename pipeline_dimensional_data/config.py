DATABASE_NAME = "ORDER_DDS"

SCHEMA_NAME = "dbo"

DIMENSION_TABLES = [
    "DimCategories",
    "DimCustomers",
    "DimEmployees",
    "DimProducts",
    "DimRegion",
    "DimShippers",
    "DimSuppliers",
    "DimTerritories"
]

FACT_TABLE = "FactOrders"

FACT_ERROR_TABLE = "FactOrders_Error"
