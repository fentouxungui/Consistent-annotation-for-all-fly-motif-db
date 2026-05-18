
<!-- README.md is generated from README.Rmd. Please edit that file. -->

<!-- To generate README.md for GitHub homepage: copy this file to the package root directory, set for_github parameter to TRUE, then knit. Delete the README.Rmd file from the root directory after completion. -->

# Consistent annotations for all fly motif databases from MEME Suite

## Problem

The [MEME Suite](https://meme-suite.org/meme/doc/download.html) provides
5 motif databases for Drosophila, but each database has its own unique
motif ID naming convention. This makes it difficult to relate motifs to
gene names and to make comparisons between databases.

    $ tree
    |-- OnTheFly_2014_Drosophila.meme
    |-- dmmpmm2009.meme
    |-- fly_factor_survey.meme
    |-- flyreg.v2.meme
    `-- idmmpmm2009.meme

    $ ls *meme | while read id; do echo $id; grep 'MOTIF' $id | head -n 5; done

    OnTheFly_2014_Drosophila.meme
    MOTIF OTF0001.1 7UP1_DROME_B1H
    MOTIF OTF0002.1 A0AQF9_DROME_B1H
    MOTIF OTF0003.1 A0JQ60_DROME_SELEX
    MOTIF OTF0003.2 A0JQ60_DROME_DNaseI
    MOTIF OTF0004.1 A1A6R5_DROME_B1H

    dmmpmm2009.meme
    MOTIF abd-A
    MOTIF Antp
    MOTIF ap
    MOTIF bcd
    MOTIF brk

    fly_factor_survey.meme
    MOTIF FBgn0000014 AbdA_Cell
    MOTIF FBgn0000014_2 Abd-A_FlyReg
    MOTIF FBgn0000014_3 AbdA_SOLEXA
    MOTIF FBgn0000015 AbdB_Cell
    MOTIF FBgn0000015_2 Abd-B_FlyReg

    flyreg.v2.meme
    MOTIF abd-A
    MOTIF Abd-B
    MOTIF Adf1
    MOTIF Aef1
    MOTIF Antp

    idmmpmm2009.meme
    MOTIF abd-A
    MOTIF Abd-B
    MOTIF Antp
    MOTIF bab1
    MOTIF bcd

## Why This Matters

Cross-database motif analysis is essential for understanding
transcriptional regulation in *Drosophila*, but has been hindered by
inconsistent naming conventions. This project addresses three critical
challenges:

**1. Data Integration** Different databases use completely different
identification systems: - `OnTheFly` uses internal OTF IDs with UniProt
names and experimental methods (e.g., `OTF0001.1 7UP1_DROME_B1H`) -
`dmmpmm2009` and `flyreg.v2` use gene symbols directly (e.g., `abd-A`,
`br-Z1`) - `fly_factor_survey` combines FlyBase IDs with experimental
metadata (e.g., `FBgn0000014_2 Abd-A_FlyReg`)

**2. Annotation Consistency** The pipeline standardizes all motif
entries using: - Official FlyBase synonym mappings
(`fb_synonym_fb_2026_01.tsv.gz`) - Automated resolution of isoform
variants (e.g., `br-Z1/Z2/Z3/Z4` → `br`) - Updates to deprecated FBgn
IDs via FlyBase conversion API - Manual curation for ambiguous cases

**3. Cross-Database Analysis** The unified annotation enables
researchers to: - Compare motif characteristics across multiple
experimental datasets - Identify overlapping and unique transcription
factors across databases - Conduct meta-analyses combining data from
different sources - Build comprehensive transcription factor regulatory
networks

## Results

### Motif IDs maping file

All motif IDs from the databases have been linked to their latest FBgn
and Symbol in FlyBase. See
`Consistent-annotation-for-all-fly-motif-database.csv`.

- `source`: database name

- `raw`: raw motif entry

- `FBgn`: latest FBgn ID

- `Symbol`: latest gene symbol

A total of 334 TFs with motifs are stored across all databases. Are all
these 334 genes truly TFs?

``` r
df <- read.csv('./Consistent-annotation-for-all-fly-motif-database.csv',stringsAsFactors = FALSE,row.names = 1)
for (i in unique(df$source)) {
    print(head(df[df$source == i,]))
}
#>            source         raw        FBgn Symbol
#> 1 dmmpmm2009.meme MOTIF abd-A FBgn0000014  abd-A
#> 2 dmmpmm2009.meme  MOTIF Antp FBgn0260642   Antp
#> 3 dmmpmm2009.meme    MOTIF ap FBgn0267978     ap
#> 4 dmmpmm2009.meme   MOTIF bcd FBgn0000166    bcd
#> 5 dmmpmm2009.meme   MOTIF brk FBgn0024250    brk
#> 6 dmmpmm2009.meme   MOTIF byn FBgn0011723    byn
#>                    source                              raw        FBgn Symbol
#> 42 fly_factor_survey.meme      MOTIF FBgn0000014 AbdA_Cell FBgn0000014  abd-A
#> 43 fly_factor_survey.meme MOTIF FBgn0000014_2 Abd-A_FlyReg FBgn0000014  abd-A
#> 44 fly_factor_survey.meme  MOTIF FBgn0000014_3 AbdA_SOLEXA FBgn0000014  abd-A
#> 45 fly_factor_survey.meme      MOTIF FBgn0000015 AbdB_Cell FBgn0000015  Abd-B
#> 46 fly_factor_survey.meme MOTIF FBgn0000015_2 Abd-B_FlyReg FBgn0000015  Abd-B
#> 47 fly_factor_survey.meme  MOTIF FBgn0000015_3 AbdB_SOLEXA FBgn0000015  Abd-B
#>             source          raw        FBgn Symbol
#> 698 flyreg.v2.meme MOTIF abd-A  FBgn0000014  abd-A
#> 699 flyreg.v2.meme MOTIF Abd-B  FBgn0000015  Abd-B
#> 700 flyreg.v2.meme  MOTIF Adf1  FBgn0284249   Adf1
#> 701 flyreg.v2.meme  MOTIF Aef1  FBgn0005694   Aef1
#> 702 flyreg.v2.meme  MOTIF Antp  FBgn0260642   Antp
#> 703 flyreg.v2.meme    MOTIF ap  FBgn0267978     ap
#>               source         raw        FBgn Symbol
#> 773 idmmpmm2009.meme MOTIF abd-A FBgn0000014  abd-A
#> 774 idmmpmm2009.meme MOTIF Abd-B FBgn0000015  Abd-B
#> 775 idmmpmm2009.meme  MOTIF Antp FBgn0260642   Antp
#> 776 idmmpmm2009.meme  MOTIF bab1 FBgn0004870   bab1
#> 777 idmmpmm2009.meme   MOTIF bcd FBgn0000166    bcd
#> 778 idmmpmm2009.meme   MOTIF brk FBgn0024250    brk
#>                            source                                 raw
#> 812 OnTheFly_2014_Drosophila.meme      MOTIF OTF0001.1 7UP1_DROME_B1H
#> 813 OnTheFly_2014_Drosophila.meme    MOTIF OTF0002.1 A0AQF9_DROME_B1H
#> 814 OnTheFly_2014_Drosophila.meme  MOTIF OTF0003.1 A0JQ60_DROME_SELEX
#> 815 OnTheFly_2014_Drosophila.meme MOTIF OTF0003.2 A0JQ60_DROME_DNaseI
#> 816 OnTheFly_2014_Drosophila.meme    MOTIF OTF0004.1 A1A6R5_DROME_B1H
#> 817 OnTheFly_2014_Drosophila.meme MOTIF OTF0005.1 A1Z858_DROME_DNaseI
#>            FBgn  Symbol
#> 812 FBgn0003651     svp
#> 813 FBgn0034599    hng1
#> 814 FBgn0000567 Eip74EF
#> 815 FBgn0000567 Eip74EF
#> 816 FBgn0004914    Hnf4
#> 817 FBgn0000448     Hr3
```

``` r
table(df$source)
#> 
#>               dmmpmm2009.meme        fly_factor_survey.meme 
#>                            41                           656 
#>                flyreg.v2.meme              idmmpmm2009.meme 
#>                            75                            39 
#> OnTheFly_2014_Drosophila.meme 
#>                           608
length(unique(df$FBgn))
#> [1] 334
head(sort(table(df$Symbol),decreasing = TRUE),30)
#> 
#>    lola      br     bcd     ovo     Ubx    Antp     ttk     lbl   Abd-B     Hsf 
#>      31      28      18      18      18      16      15      14      13      13 
#> Eip74EF      ap     ara     Cf2      ey     grh     hth     Med     prd     shn 
#>      12      11      11      11      11      11      11      11      11      11 
#>   abd-A     eve      gt      hb      Kr     cad     ems      en     nub     sna 
#>      10      10      10      10      10       9       9       9       9       9
```

### Updated meme files with new MOTIF name

new MOTIF name: `database name` + `FBgn ID` + `Gene Symbol` +
`Row number`, separated by underscore.

Row number: the row number in
`Consistent-annotation-for-all-fly-motif-database.csv` file, included to
avoid duplicated motif names.

    $ grep 'MOTIF' dmmpmm2009.meme |head -n 10
    MOTIF idmmpmm2009.meme_FBgn0000014_abd-A_773
    MOTIF idmmpmm2009.meme_FBgn0260642_Antp_775
    MOTIF flyreg.v2.meme_FBgn0267978_ap_703
    MOTIF idmmpmm2009.meme_FBgn0000166_bcd_777
    MOTIF idmmpmm2009.meme_FBgn0024250_brk_778
    MOTIF flyreg.v2.meme_FBgn0283451_br_760
    MOTIF flyreg.v2.meme_FBgn0283451_br_761
    MOTIF flyreg.v2.meme_FBgn0283451_br_762
    MOTIF flyreg.v2.meme_FBgn0283451_br_763
    MOTIF flyreg.v2.meme_FBgn0011723_byn_710

## Code and Files Used

**Files:**

`fb_synonym_fb_2026_01.tsv.gz` — downloaded from FlyBase, containing the
latest FBgn and Symbol mappings.

**Code:**

- `0_extract-motif-names.sh` — extracts motif names from databases

- `1_Standardize-gene-names.R` — updates gene information for each
  database

- `2_merge-all.R` — merges all results

- `3_update-motif-names-in-meme-files.py` - update motif names in meme
  files

## Acknowledgments

Thanks to Claude Code for generating the web crawler scripts.
