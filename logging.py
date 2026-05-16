import logging
from pathlib import Path


def setup_logger(execution_id):
    Path("logs").mkdir(exist_ok=True)

    logger = logging.getLogger(f"DimensionalDataFlow_{execution_id}")
    logger.setLevel(logging.INFO)

    if logger.handlers:
        return logger

    file_handler = logging.FileHandler(
        "logs/logs_dimensional_data_pipeline.txt",
        mode="a",
        encoding="utf-8"
    )

    formatter = logging.Formatter(
        f"%(asctime)s | execution_id={execution_id} | %(levelname)s | %(message)s"
    )

    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)

    return logger
