import pyodbc

from utils import read_sql_file, format_sql_script


def create_connection(db_config):
    """
    Creates a connection to SQL Server.
    """

    connection_string = (
        f"DRIVER={{{db_config['driver']}}};"
        f"SERVER={db_config['server']};"
        f"DATABASE={db_config['database']};"
        f"UID={db_config['username']};"
        f"PWD={db_config['password']};"
        f"TrustServerCertificate=yes;"
    )

    return pyodbc.connect(connection_string)


def execute_sql_script(connection, sql_script):
    """
    Executes a SQL script inside a transaction.
    """

    cursor = connection.cursor()

    try:
        cursor.execute(sql_script)
        connection.commit()

        return {"success": True}

    except Exception as error:
        connection.rollback()

        return {
            "success": False,
            "error": str(error)
        }

    finally:
        cursor.close()


def create_dimensional_tables(connection, sql_file_path):
    """
    Executes dimensional table creation script.
    """

    sql_script = read_sql_file(sql_file_path)

    return execute_sql_script(connection, sql_script)


def update_dimension_table(
    connection,
    sql_file_path,
    database_name,
    schema_name,
    table_name
):
    """
    Executes parametrized dimension table update query.
    """

    sql_script = read_sql_file(sql_file_path)

    formatted_sql = format_sql_script(
        sql_script,
        database_name=database_name,
        schema_name=schema_name,
        table_name=table_name
    )

    return execute_sql_script(connection, formatted_sql)


def update_fact_table(
    connection,
    sql_file_path,
    database_name,
    schema_name,
    table_name,
    start_date,
    end_date
):
    """
    Executes parametrized fact table update query.
    """

    sql_script = read_sql_file(sql_file_path)

    formatted_sql = format_sql_script(
        sql_script,
        database_name=database_name,
        schema_name=schema_name,
        table_name=table_name,
        start_date=start_date,
        end_date=end_date
    )

    return execute_sql_script(connection, formatted_sql)


def update_fact_error_table(
    connection,
    sql_file_path,
    database_name,
    schema_name,
    table_name,
    start_date,
    end_date
):
    """
    Executes parametrized fact error table update query.
    """

    sql_script = read_sql_file(sql_file_path)

    formatted_sql = format_sql_script(
        sql_script,
        database_name=database_name,
        schema_name=schema_name,
        table_name=table_name,
        start_date=start_date,
        end_date=end_date
    )

    return execute_sql_script(connection, formatted_sql)
