import json
import logging
import os
import re
import sys
from typing import Iterable

import pandas as pd
import pyarrow.feather as feather


def main() -> None:

    LOGLEVEL = logging.getLevelName(os.getenv("LOGLEVEL", "INFO"))
    logging.basicConfig(
        format="%(asctime)s: %(message)s",
        datefmt="%Y-%m-%dT%H:%M:%S%z",
        level=LOGLEVEL,
    )

    all_tasks = []

    for file in get_report_files("bam2fastqbenchmarks/"):
        with open(file, "r") as report_file:
            report_file_contents = report_file.read()
            report_data = re.search(
                r"window.data\s*=\s*({.*}\s*);", report_file_contents, re.DOTALL
            )

            if not report_data:
                logging.critical("No report data found")
                sys.exit()

            report_data_parsed: dict[str, list] = json.loads(report_data.group(1))

            for task in report_data_parsed["trace"]:
                task["run"] = report_file.name[36:-5]
                task["native_id"] = int(task["native_id"])
                all_tasks.append(task)

    df = pd.DataFrame(all_tasks)
    df = df.convert_dtypes()
    df["run"] = df["run"].astype("category")
    df["type"] = (df["run"].apply(lambda run: run.split("_")[0])).astype("category")
    df["type/process"] = (df["type"].astype(str) + "/" + df["process"]).astype(
        "category"
    )
    df["duration"] = (
        pd.to_timedelta(df["duration"].astype(int), "ms").dt.total_seconds() / 60
    )
    for column in df.columns:
        if df[column].dtype == "string":
            check_df = df[column].apply(lambda x: x.isdigit())
            if len(check_df.unique()) == 1 and check_df.iloc[0]:
                df[column] = pd.to_numeric(df[column])
    feather.write_feather(df, "bam2fastqbenchmarks/results.df")


def get_report_files(path: str) -> Iterable[str]:
    for file in os.listdir(path):
        if (
            os.path.isfile(os.path.join(path, file))
            and "nextflow_report" in str(file)
            and ".html" in str(file)
        ):
            yield os.path.join(path, file)


if __name__ == "__main__":
    main()
