# Kde vzít otevřená data a jak s nimi pracovat efektivně

> Materiály pro workshop na FF UK 31. 10. 2024 v rámci série [Vybraná témata analýzy dat](https://sociology-fa-cu.github.io/vybranatemataanalyzy/). Záznam [na Youtube](https://www.youtube.com/watch?v=ATUrm_wjjW0).

Tento repozitář obsahuje podklady pro workshop o veřejných datech v R:

- kód pro práci - ke stažení na <https://github.com/petrbouchal/ffuk-r-publicdata/archive/refs/heads/main.zip> resp. <https://github.com/petrbouchal/ffuk-r-publicdata/>
- část předpřipravených vstupních dat
- slidy - quarto zdroj a HTML výstup, který se ukazuje na <https://petrbouchal.xyz/ffuk-r-publicdata/>
- v separátním souboru vyvěšeném v release s tagem `data` je předpřipravený datový soubor <https://github.com/petrbouchal/ffuk-r-publicdata/releases/download/data/ucjed_mist.parquet> - využivá se ve scriptu 0_setup.R.

Co dělají které soubory:

- 00_preprocess.R: předpřipravuje podmnožinu dat, která by trvala příliš dlouho (číselník organizací) při workshopu. Není třeba pouštět.
- data-processed/orgs_proc.parquet: předpřipravený číselník organizací
- 0_setup.R: instalace potřebných balíků, stažení, načtení a přeuložení dat
- 1_explorace.R: kód na zkoušení hledání v katalogu a načtení dat ČSÚ
- 2_ukol.R: skript i s komentáři pro řešení ukázkového úkolu
- 2_ukol.qmd: totéž ve formě Quarto dokumentu - [vygenerovaná verze online](https://petrbouchal.xyz/ffuk-r-publicdata/2_ukol.html)
- 3_ukol-usporne.R: úkol bez komentářů a náhledů dat
- 4_eurostat.R: řešení úkolu k mezinárodnímu srovnání
- 5_out-of-memory.R: možnosti, jak s daty pracovat s využitím Arrow a parquet.
- index.qmd: zdrojový soubor slides

Dependencies jsou zachyceny v `renv.lock`, ale systém renv je vypnutý. Lze zapnout pomocí `renv::activate()` a následně `renv::restore()`.
