install.packages(c("czso", "statnipokladna", "dplyr", "tidyr", "forcats",
                   "ggiraph", "tmap", "arrow", "tictoc",
                   "lubridate", "RCzechia", "ggplot2", "readr", "nanoparquet"))

library(statnipokladna)
library(readr)
library(nanoparquet)
library(dplyr)

options(statnipokladna.dest_dir = "data-input/sp")
options(czso.dest_dir = "data-input/czso")

# Stáhnout a načíst data --------------------------------------------------

rozp_pqt_url <- "https://github.com/petrbouchal/ffuk-r-publicdata/releases/download/data/ucjed_mist.parquet"
rozp_pqt_path <- "data-processed/ucjed_mist.parquet"
download.file(rozp_pqt_url, rozp_pqt_path, mode = "wb")

rozp_mist <- read_parquet(rozp_pqt_path)

# Převést do arrow datasetu -----------------------------------------------

rozp_mist <- read_parquet("data-processed/ucjed_mist.parquet")
arrow::write_dataset(rozp_mist,
                     path = "data-processed/rozp_mist",
                     partitioning = c("vykaz_year", "vykaz_month", "kraj", "vtab"))

