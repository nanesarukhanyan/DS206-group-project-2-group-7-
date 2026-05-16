from logging import setup_logger
from utils import generate_execution_id, parse_database_config

from pipeline_dimensional_data.tasks import (
    create_connection,
    create_dimensional_tables,
    update_dimension_table,
    update_fact_table,
    update_fact_error_table
)


class DimensionalDataFlow:

    def __init__(self, config_path):

        self.execution_id = generate_execution_id()
       
        self.logger = setup_logger(self.execution_id)
        self.logger.info("Dimensional data flow initialized")

        self.config_path = config_path

        self.db_config = parse_database_config(config_path)

    def exec(self, start_date, end_date):
        self.logger.info("Dimensional data flow started")

        connection = create_connection(self.db_config)

        try:

            result = create_dimensional_tables(
                connection,
                "infrastructure_initiation/dimensional_db_table_creation.sql"
            )

            if not result["success"]:
                self.logger.error(f"Task failed: {result}")
                return result

            dimension_scripts = {
                "DimCategories": "pipeline_dimensional_data/queries/update_dim_categories.sql",
                "DimCustomers": "pipeline_dimensional_data/queries/update_dim_customers.sql",
                "DimEmployees": "pipeline_dimensional_data/queries/update_dim_employees.sql",
                "DimProducts": "pipeline_dimensional_data/queries/update_dim_products.sql",
                "DimRegion": "pipeline_dimensional_data/queries/update_dim_region.sql",
                "DimShippers": "pipeline_dimensional_data/queries/update_dim_shippers.sql",
                "DimSuppliers": "pipeline_dimensional_data/queries/update_dim_suppliers.sql",
                "DimTerritories": "pipeline_dimensional_data/queries/update_dim_territories.sql"
            }

            for table_name, sql_path in dimension_scripts.items():

                result = update_dimension_table(
                    connection=connection,
                    sql_file_path=sql_path,
                    database_name="ORDER_DDS",
                    schema_name="dbo",
                    table_name=table_name
                )

                if not result["success"]:
                    self.logger.error(f"Task failed: {result}")
                    return result

            result = update_fact_table(
                connection=connection,
                sql_file_path="pipeline_dimensional_data/queries/update_fact.sql",
                database_name="ORDER_DDS",
                schema_name="dbo",
                table_name="FactOrders",
                start_date=start_date,
                end_date=end_date
            )

            if not result["success"]:
                self.logger.error(f"Task failed: {result}")
                return result

            result = update_fact_error_table(
                connection=connection,
                sql_file_path="pipeline_dimensional_data/queries/update_fact_error.sql",
                database_name="ORDER_DDS",
                schema_name="dbo",
                table_name="FactOrders_Error",
                start_date=start_date,
                end_date=end_date
            )

            if not result["success"]:
                self.logger.error(f"Task failed: {result}")
                return result
            
            self.logger.info("Dimensional data flow finished successfully")
            
            return {
                "success": True,
                "execution_id": self.execution_id
            }

        finally:
            connection.close()
