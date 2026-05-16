import pytest
from unittest.mock import mock_open, patch
from pathlib import Path

from utils import (
    generate_execution_id,
    read_sql_file,
    parse_database_config,
    format_sql_script
)


def test_generate_execution_id_returns_string():
    execution_id = generate_execution_id()

    assert isinstance(execution_id, str)
    assert len(execution_id) > 0


@patch("pathlib.Path.exists", return_value=True)
def test_read_sql_file_success(mock_exists):
    fake_sql = "SELECT * FROM dbo.Customers;"

    with patch("builtins.open", mock_open(read_data=fake_sql)):
        result = read_sql_file("fake.sql")

    assert result == fake_sql


@patch("pathlib.Path.exists", return_value=False)
def test_read_sql_file_not_found(mock_exists):
    with pytest.raises(FileNotFoundError):
        read_sql_file("missing.sql")


def test_format_sql_script_success():
    sql = "SELECT * FROM {database_name}.{schema_name}.{table_name};"

    result = format_sql_script(
        sql,
        database_name="ORDER_DDS",
        schema_name="dbo",
        table_name="DimCustomers"
    )

    assert result == "SELECT * FROM ORDER_DDS.dbo.DimCustomers;"


def test_format_sql_script_empty():
    with pytest.raises(ValueError):
        format_sql_script("")


def test_parse_database_config_success():
    fake_config = """
[SQL_SERVER]
server=localhost
database=ORDER_DDS
username=test_user
password=test_password
driver=ODBC Driver 17 for SQL Server
"""

    path = Path("temp_test_config.cfg")
    path.write_text(fake_config)

    result = parse_database_config(path)

    assert result["server"] == "localhost"
    assert result["database"] == "ORDER_DDS"
    assert result["username"] == "test_user"
    assert result["password"] == "test_password"
    assert result["driver"] == "ODBC Driver 17 for SQL Server"

    path.unlink()


def test_parse_database_config_missing_file():
    with pytest.raises(FileNotFoundError):
        parse_database_config("missing_config.cfg")
