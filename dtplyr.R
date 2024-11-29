library(data.table)
library(dtplyr)
library(dplyr, warn.conflicts = FALSE)
library(arrow)
library(tictoc)

ds_m <- read_parquet("data-processed/ucjed_mist.parquet")
ds_l <- lazy_dt(ds_m)

names(ds_l)

tic()
ds_l |>
  count(vtab) |>
  as_tibble()
toc()

tic()
ds_m |>
  count(vtab)
toc()

tic()
ds_l |>
  filter(kraj == "CZ020", vtab == "000100") |>
  group_by(ucjed, vtab, polozka, kraj) |>
  filter(budget_spending > 0, budget_amended > 0) |>
  summarise(naplneni = mean(log(abs(budget_spending / budget_amended)))) |>
  arrange(desc(naplneni)) |>
  as_tibble()
toc()

# s nevhodným řazením operací

tic()
ds_l |>
  group_by(ucjed, vtab, polozka, kraj) |>
  filter(budget_spending > 0, budget_amended > 0) |>
  summarise(naplneni = mean(log(abs(budget_spending / budget_amended)))) |>
  arrange(desc(naplneni)) |>
  filter(kraj == "CZ020", vtab == "000100") |>
  as_tibble()
toc()
