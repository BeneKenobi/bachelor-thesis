import datetime

import numpy as np
import pandas as pd
from numpy.polynomial import Polynomial

# read csv from sql result
df_whole_genomes = pd.read_csv(
    "./whole-genome-sequencings.csv",
    parse_dates=["Date"],
)

# group by week and count rows
df_whole_genomes = (
    df_whole_genomes.groupby(pd.Grouper(freq="W-MON", key="Date"))
    .size()
    .reset_index(level=0)
)
df_whole_genomes = df_whole_genomes.rename(columns={0: "Count"})

# convert dates to numpy float for polynomal fit
whole_genome_numeric_dates = np.array(
    df_whole_genomes["Date"].dt.isocalendar().week.values, dtype="float64"
)

# do polynomal fitting for current data
whole_genomes_polyfit = Polynomial.fit(
    whole_genome_numeric_dates, df_whole_genomes["Count"], 1
)

# add extrapolated data for missing weeks to project deadline
currentdate = df_whole_genomes["Date"].max() + datetime.timedelta(days=7)
while currentdate < datetime.datetime(2023, 3, 31):
    currentweek = currentdate.isocalendar().week
    additional_row = pd.DataFrame(
        [[currentdate, whole_genomes_polyfit(currentweek)]],
        columns=["Date", "Count"],
        index=[currentweek - 1],
    )
    df_whole_genomes = pd.concat([df_whole_genomes, additional_row])
    currentdate += datetime.timedelta(days=7)

# get sum of all weekly data
print(df_whole_genomes["Count"].sum())
