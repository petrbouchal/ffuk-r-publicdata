library(dplyr)
library(duckdb)
library(arrow)
library(tictoc)

# Načtení dat -------------------------------------------------------------

# Arrow dataset

tic()
ds_a <- arrow::open_dataset("data-processed/rozp_mist")
toc()

# Duckdb jako prostředník do Arrow datasetu

ds_ad <- to_duckdb(ds_a)

# DuckDB jako prostředník do parquet souboru

tic()
con <- dbConnect(duckdb::duckdb())
duckdb::duckdb_register_arrow(con, "rozp_mist_arrow", ds_a)
toc()

# Parquet soubor bez načtení do paměti

tic()
ds_p <- read_parquet("data-processed/ucjed_mist.parquet",
                     as_data_frame = FALSE)
toc()

tic()
ds_p |>
  count(vykaz_year) |>
  collect()
toc()

# DuckDB jako prostředník do Parquet souboru
ds_pd <- to_duckdb(ds_p)

# Načtení do paměti

tic()
ds_m <- read_parquet("data-processed/ucjed_mist.parquet")
toc()

# Jednoduché operace ------------------------------------------------------

tic()
ds_m |>
  count(vykaz_year)
toc()

tic()
ds_a |>
  count(vtab, kraj) |>
  collect()
toc()

tic()
ds_p |>
  count(vtab, kraj) |>
  collect()
toc()

tic()
tbl(con, "rozp_mist_arrow") |>
  count(vtab, kraj) |>
  collect()
toc()

tic()
ds_ad |>
  count(vtab, kraj) |>
  collect()
toc()

tic()
ds_pd |>
  count(vtab, kraj)
toc()


# O něco složitější -------------------------------------------------------

tic()
ds_m |>
  filter(kraj == "CZ020", vtab == "000100") |>
  count(vtab, polozka, wt = budget_spending)
toc()

tic()
ds_p |>
  filter(kraj == "CZ020", vtab == "000100") |>
  count(vtab, polozka, wt = budget_spending) |>
  collect()
toc()

tic()
ds_m |>
  filter(kraj == "CZ020") |>
  count(vtab, polozka, wt = budget_spending) |>
  filter(vtab == "000100") |>
toc()

ds_p |>
  count(vykaz_year, kraj) |>
  collect() |>
  pivot_wider(names_from = kraj, values_from = n) |>
  arrange(vykaz_year)

tic()
ds_a |>
  filter(kraj == "CZ020", vtab == 100) |>
  count(vtab, polozka, wt = budget_spending) |>
  collect() |>
toc()

tic()
ds_a |>
  filter(kraj == "CZ020") |>
  count(vtab, polozka, wt = budget_spending) |>
  filter(vtab == 100) |>
  collect()
toc()


tic()
ds_p |>
  filter(kraj == "CZ020", vtab == "000100") |>
  count(vtab, polozka, wt = budget_spending) |>
  collect()
toc()

tic()
ds_p |>
  filter(kraj == "CZ020") |>
  count(vtab, polozka, wt = budget_spending) |>
  filter(vtab == "000100") |>
  collect()
toc()


# Složité operace, mnoho skupin -------------------------------------------

tic()
ds_p |>
  filter(kraj == "CZ020", vtab == "000100") |>
  group_by(ucjed, vtab, polozka, vtab, kraj) |>
  filter(budget_spending > 0, budget_amended > 0) |>
  mutate(naplneni = log(abs(budget_spending / budget_amended))) |>
  arrange(desc(naplneni)) |>
  collect()
toc()

tic()
ds_a |>
  filter(kraj == "CZ020", vtab == 100) |>
  group_by(ucjed, vtab, polozka, vtab, kraj) |>
  filter(budget_spending > 0, budget_amended > 0) |>
  mutate(naplneni = log(abs(budget_spending / budget_amended))) |>
  arrange(desc(naplneni)) |>
  collect()
toc()

tic()
ds_ad |>
  filter(kraj == "CZ020", vtab == 100) |>
  group_by(ucjed, vtab, polozka, kraj) |>
  filter(budget_spending > 0, budget_amended > 0) |>
  mutate(naplneni = log(abs(budget_spending / budget_amended))) |>
  arrange(desc(naplneni)) |>
  collect()
toc()

tic()
ds_ad |>
  group_by(ucjed, vtab, polozka, kraj) |>
  filter(budget_spending > 0, budget_amended > 0) |>
  mutate(naplneni = log(abs(budget_spending / budget_amended))) |>
  arrange(desc(naplneni)) |>
  filter(kraj == "CZ020", vtab == 100) |>
  collect()
toc()

# s logickým řazením operací

tic()
ds_m |>
  filter(kraj == "CZ020", vtab == 100) |>
  group_by(ucjed, vtab, polozka, kraj) |>
  filter(budget_spending > 0, budget_amended > 0) |>
  summarise(naplneni = mean(log(abs(budget_spending / budget_amended)))) |>
  arrange(desc(naplneni))
toc()

# s nevhodným řazením operací

tic()
ds_m |>
  group_by(ucjed, vtab, polozka, kraj) |>
  filter(budget_spending > 0, budget_amended > 0) |>
  summarise(naplneni = mean(log(abs(budget_spending / budget_amended)))) |>
  arrange(desc(naplneni)) |>
  filter(kraj == "CZ020", vtab == 100)
toc()

tic()
ds_pd |>
  filter(kraj == "CZ020", vtab == 100) |>
  group_by(ucjed, vtab, polozka, kraj) |>
  filter(budget_spending > 0, budget_amended > 0) |>
  summarise(naplneni = mean(log(abs(budget_spending / budget_amended)))) |>
  arrange(desc(naplneni)) |>
  collect()
toc()

tic()
ds_pd |>
  group_by(ucjed, vtab, polozka, kraj) |>
  filter(budget_spending > 0, budget_amended > 0) |>
  summarise(naplneni = mean(log(abs(budget_spending / budget_amended)))) |>
  arrange(desc(naplneni)) |>
  filter(kraj == "CZ020", vtab == 100) |>
  collect()
toc()

tic()
tbl(con, "rozp_mist_arrow") |>
  filter(kraj == "CZ020", vtab == 100) |>
  group_by(ucjed, vtab, polozka, kraj) |>
  filter(budget_spending > 0, budget_amended > 0) |>
  mutate(naplneni = log(abs(budget_spending / budget_amended))) |>
  arrange(desc(naplneni)) |>
  collect()
toc()

tic()
tbl(con, "rozp_mist_arrow") |>
  group_by(ucjed, vtab, polozka, kraj) |>
  filter(budget_spending > 0, budget_amended > 0) |>
  mutate(naplneni = log(abs(budget_spending / budget_amended))) |>
  arrange(desc(naplneni)) |>
  filter(kraj == "CZ020", vtab == 100) |>
  collect()
toc()



