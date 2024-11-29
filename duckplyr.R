library(arrow)
library(dplyr)
library(tictoc)
library(duckplyr)

ds_m <- read_parquet("data-processed/ucjed_mist.parquet")
ds_p <- read_parquet("data-processed/ucjed_mist.parquet", as_data_frame = FALSE)

ds_fl <- duckplyr_df_from_parquet("data-processed/ucjed_mist.parquet")

ds_dpt <- as_duckplyr_tibble(ds_m)
class(ds_dpt)

tic()
duckplyr_df_from_parquet("data-processed/ucjed_mist.parquet") |>
  count(vtab)
toc()

tic()
ds_fl |>
  count(vtab)
toc()

methods_restore()
tic()
xx <- ds_m |>
  count(vtab)
xx
toc()

methods_overwrite()
tic()
xx <- ds_m |>
  count(vtab)
xx
toc()

methods_overwrite()
tic()
xx <- ds_dpt |>
  count(vtab)
xx
toc()

explain(xx)
class(xx)
xx

methods_overwrite()
tic()
duckplyr_res1 <- duckplyr_df_from_parquet("data-processed/ucjed_mist.parquet") |>
  filter(budget_spending > 0, budget_amended > 0) |>
  mutate(naplneni = log(abs(budget_spending / budget_amended)),
         .by = c(ucjed, vtab, polozka)) |>
  arrange(desc(naplneni)) |>
  filter(kraj == "CZ020", vtab == "000100")
duckplyr_res1
toc()

qs::

tic()
duckplyr_res2 <- duckplyr_df_from_parquet("data-processed/ucjed_mist.parquet") |>
  filter(kraj == "CZ020", vtab == "000100") |>
  filter(budget_spending > 0, budget_amended > 0) |>
  mutate(naplneni = log(abs(budget_spending / budget_amended)),
         .by = c(ucjed, vtab, polozka)) |>
  arrange(desc(naplneni))
duckplyr_res2
toc()

tic()
duckplyr_res2 <- ds_fl |>
  filter(kraj == "CZ020", vtab == "000100") |>
  filter(budget_spending > 0, budget_amended > 0) |>
  mutate(naplneni = log(abs(budget_spending / budget_amended)),
         .by = c(ucjed, vtab, polozka)) |>
  arrange(desc(naplneni))
duckplyr_res2
toc()

methods_restore()
tic()
ds_res1 <- ds_m |>
  group_by(ucjed, vtab, polozka) |>
  filter(budget_spending > 0, budget_amended > 0) |>
  mutate(naplneni = log(abs(budget_spending / budget_amended))) |>
  arrange(desc(naplneni)) |>
  filter(kraj == "CZ020", vtab == "000100")
ds_res1
toc()

tic()
ds_res2 <- ds_m |>
  filter(kraj == "CZ020", vtab == "000100") |>
  group_by(ucjed, vtab, polozka) |>
  filter(budget_spending > 0, budget_amended > 0) |>
  mutate(naplneni = log(abs(budget_spending / budget_amended))) |>
  arrange(desc(naplneni))
toc()

methods_overwrite()
tic()
dkplr_res1 <- ds_m |>
  filter(budget_spending > 0, budget_amended > 0) |>
  mutate(naplneni = log(abs(budget_spending / budget_amended)),
         .by = c(ucjed, vtab, polozka)) |>
  arrange(desc(naplneni)) |>
  filter(kraj == "CZ020", vtab == "000100")
dkplr_res1
toc()

tic()
dkplr_res2 <- ds_m |>
  filter(kraj == "CZ020", vtab == "000100") |>
  filter(budget_spending > 0, budget_amended > 0) |>
  mutate(naplneni = log(abs(budget_spending / budget_amended)),
         .by = c(ucjed, vtab, polozka)) |>
  arrange(desc(naplneni))
dkplr_res2
toc()

methods_overwrite()
tic()
dkplr_res2 <- ds_p |>
  filter(kraj == "CZ020", vtab == "000100") |>
  filter(budget_spending > 0, budget_amended > 0) |>
  mutate(naplneni = log(abs(budget_spending / budget_amended)),
         .by = c(ucjed, vtab, polozka)) |>
  arrange(desc(naplneni)) |>
  collect()
dkplr_res2
toc()

methods_restore()
tic()
dkplr_res2 <- ds_p |>
  as_duckplyr_tibble() |>
  filter(kraj == "CZ020", vtab == "000100") |>
  filter(budget_spending > 0, budget_amended > 0) |>
  mutate(naplneni = log(abs(budget_spending / budget_amended)),
         .by = c(ucjed, vtab, polozka)) |>
  arrange(desc(naplneni)) |>
  collect()
dkplr_res2
toc()

class(duckplyr_res1)
names(duckplyr_res1)
class(duckplyr_res2)
names(duckplyr_res2)

duckplyr_res1 |> explain()
duckplyr_res2 |> explain()

duckplyr_res1$naplneni

duckplyr::methods_restore()
