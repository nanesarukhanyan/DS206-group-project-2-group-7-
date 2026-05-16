import configparser
import uuid
from pathlib import Path


def generate_execution_id():
    return str(uuid.uuid4())


def read_sql_file(file_path):
    path = Path(file_path)

    if not path.exists():
        raise FileNotFoundError(f"SQL file not found: {file_path}")

    with open(path, "r", encoding="utf-8") as file:
        return file.read()


def parse_database_config(config_path):
    path = Path(config_path)

    if not path.exists():
        raise FileNotFoundError(f"Config file not found: {config_path}")

    config = configparser.ConfigParser()
    config.read(path)

    if "SQL_SERVER" not in config:
        raise ValueError("Missing SQL_SERVER section in config file")

    return {
        "server": config["SQL_SERVER"]["server"],
        "database": config["SQL_SERVER"]["database"],
        "username": config["SQL_SERVER"]["username"],
        "password": config["SQL_SERVER"]["password"],
        "driver": config["SQL_SERVER"]["driver"],
    }


def format_sql_script(sql_script, **params):
    return sql_script.format(**params)
