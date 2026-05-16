import argparse

from pipeline_dimensional_data.flow import DimensionalDataFlow


def main():
    parser = argparse.ArgumentParser(description="Run dimensional data pipeline")

    parser.add_argument(
        "--start_date",
        required=True,
        help="Start date in YYYY-MM-DD format"
    )

    parser.add_argument(
        "--end_date",
        required=True,
        help="End date in YYYY-MM-DD format"
    )

    args = parser.parse_args()

    flow = DimensionalDataFlow(config_path="sql_server_config.cfg")

    result = flow.exec(
        start_date=args.start_date,
        end_date=args.end_date
    )

    print(result)


if __name__ == "__main__":
    main()
