
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- To generate README.md for GitHub homepage: copy this file to the package root directory, set for_github parameter to TRUE, then knit. Delete the README.Rmd file from the root directory after completion -->

# Consistent annotations for all fly motif database from MEME Suite

## Problem

[MEME Suite](https://meme-suite.org/meme/doc/download.html) provided 5
motif database for drosophila, but each database has it’s unique motif
id naming, which makes it hard to related it to the gene name and make a
comparision between database.

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

## Results

all ids from motif database has been related to it’s latest FBgn and
Symbol in Flybase. see
`Consistent-annotation-for-all-fly-motif-database.csv`

- source： database

- raw： raw motif entry

- FBgn: latest FBgn ID

- Symbol: latest gene symbol

And total 334 TFs with motifs are stored in all database. Is all these
334 genes are TFs?

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
sort(table(df$Symbol),decreasing = TRUE)
#> 
#>             lola               br              bcd              ovo 
#>               31               28               18               18 
#>              Ubx             Antp              ttk              lbl 
#>               18               16               15               14 
#>            Abd-B              Hsf          Eip74EF               ap 
#>               13               13               12               11 
#>              ara              Cf2               ey              grh 
#>               11               11               11               11 
#>              hth              Med              prd              shn 
#>               11               11               11               11 
#>            abd-A              eve               gt               hb 
#>               10               10               10               10 
#>               Kr              cad              ems               en 
#>               10                9                9                9 
#>              nub              sna              srp              tgo 
#>                9                9                9                9 
#>              tin              Trl              twi              vnd 
#>                9                9                9                9 
#>              bin              Dfd               dl              ftz 
#>                8                8                8                8 
#>            HLH4C              Hr3              kni              pan 
#>                8                8                8                8 
#>               sd              ato             bab1              brk 
#>                8                7                7                7 
#>     E(spl)m5-HLH              exd              lbe              Oli 
#>                7                7                7                7 
#>              tll              zen               ab             Adf1 
#>                7                7                6                6 
#>             Aef1              C15           CG4328               ct 
#>                6                6                6                6 
#>             Dref              dsx              fkh           ftz-f1 
#>                6                6                6                6 
#>               gl             Lim3              lms               pb 
#>                6                6                6                6 
#>              pho             Ptx1             slbo              tup 
#>                6                6                6                6 
#>              vvl                z              bsh              byn 
#>                6                6                5                5 
#>          CG12236              Clk            Deaf1              Dll 
#>                5                5                5                5 
#>     E(spl)m8-HLH              Gsc             HGTX              hkb 
#>                5                5                5                5 
#>              Mad              nau            NK7.1               oc 
#>                5                5                5                5 
#>              odd           onecut              otp             PHDP 
#>                5                5                5                5 
#>            Pph13             slp1            SREBP              tap 
#>                5                5                5                5 
#>             Vsx2             zen2              Awh          BEAF-32 
#>                5                5                4                4 
#>          Blimp-1              btn             cato          CG15696 
#>                4                4                4                4 
#>          CG18599           CG3065           CG9876               da 
#>                4                4                4                4 
#>              Dbx             Fer1              fru              hbn 
#>                4                4                4                4 
#>             HHEX              Hmx              hry              ind 
#>                4                4                4                4 
#>              inv              lab             Lim1             mirr 
#>                4                4                4                4 
#>             OdsH              opa            Optix              peb 
#>                4                4                4                4 
#>             repo             scrt             Six4               so 
#>                4                4                4                4 
#>              tai              toy              vis             Vsx1 
#>                4                4                4                4 
#>               ac             achi               al             amos 
#>                3                3                3                3 
#>              ase             B-H1             B-H2              bap 
#>                3                3                3                3 
#>             bowl              btd             caup          CG11085 
#>                3                3                3                3 
#>          CG11294          CG11617          CG32532          CG34031 
#>                3                3                3                3 
#>           CG3407          CG42741           CG4854           CG7368 
#>                3                3                3                3 
#>           CG8319               ci          CR43669             crol 
#>                3                3                3                3 
#>              cyc                D             D19A             D19B 
#>                3                3                3                3 
#>             dar1             dati             dimm            disco 
#>                3                3                3                3 
#>          disco-r               Dr E(spl)mgamma-HLH               E5 
#>                3                3                3                3 
#>              erm              esg             exex             Fer2 
#>                3                3                3                3 
#>             Fer3              gsb             H2.0             Hand 
#>                3                3                3                3 
#>              her           HLH54F             Hnf4             hng1 
#>                3                3                3                3 
#>           Irbp18              jim              Kah              ken 
#>                3                3                3                3 
#>              klu           l(1)sc        l(3)neo38              lmd 
#>                3                3                3                3 
#>            Lmx1a             luna             mamo              Max 
#>                3                3                3                3 
#>              Met              net              pad             phol 
#>                3                3                3                3 
#>              pnt               rn               ro               Rx 
#>                3                3                3                3 
#>             Sag1             sage               sc          schlank 
#>                3                3                3                3 
#>              Scr           scrape             sens           sens-2 
#>                3                3                3                3 
#>             slou            Sox14              Sp1             Spps 
#>                3                3                3                3 
#>              sqz               ss            Su(H)           su(Hw) 
#>                3                3                3                3 
#>              sug            unc-4             unpg              usp 
#>                3                3                3                3 
#>              wor              Zif            ZIPIC              zld 
#>                3                3                3                3 
#>              aop            Asciz             Atf6           bigmax 
#>                2                2                2                2 
#>             brwl           BtbVII          CG15812           CG3919 
#>                2                2                2                2 
#>           CG4404           CG5953           CG6276           CG8765 
#>                2                2                2                2 
#>              cic             Coop              crc            CrebA 
#>                2                2                2                2 
#>              crp              cwo            Dlip3             Doc2 
#>                2                2                2                2 
#>              dpn              dsf             dysf     E(spl)m3-HLH 
#>                2                2                2                2 
#>     E(spl)m7-HLH  E(spl)mbeta-HLH E(spl)mdelta-HLH              EcR 
#>                2                2                2                2 
#>               eg           Eip75B           Eip78C           Eip93F 
#>                2                2                2                2 
#>              ERR           Ets21C           Ets65A           Ets96B 
#>                2                2                2                2 
#>           Ets97D           Ets98B            FoxL1             foxo 
#>                2                2                2                2 
#>             FoxP            GATAd            GATAe            gsb-n 
#>                2                2                2                2 
#>             Hesr              Hey             hng3              Hr4 
#>                2                2                2                2 
#>             Hr51             Hr78             Hr83              Jra 
#>                2                2                2                2 
#>              kay            Klf15             knrl              lov 
#>                2                2                2                2 
#>             Mitf            Mondo              Myc             NFAT 
#>                2                2                2                2 
#>              pnr              Rel             retn              rib 
#>                2                2                2                2 
#>              run            Sidpn             sima             slp2 
#>                2                2                2                2 
#>              sob             soul            Sox15               sr 
#>                2                2                2                2 
#>              svp               tj               tx              Usf 
#>                2                2                2                2 
#>              vri             Xrp1             acj6            Atf-2 
#>                2                2                1                1 
#>              Bgb          CG10904          CG12155          CG12768 
#>                1                1                1                1 
#>          CG15601          CG44247           CG5180           CG7386 
#>                1                1                1                1 
#>           CG7745           CG8281           chinmo             croc 
#>                1                1                1                1 
#>              gce            His2B             Hr39            jigr1 
#>                1                1                1                1 
#>             Mes2           mip120              Mnt          p120ctn 
#>                1                1                1                1 
#>             pdm2             pdm3             Poxm             Poxn 
#>                1                1                1                1 
#>             salr              sim               sv             Top2 
#>                1                1                1                1 
#>              trh           Vostok 
#>                1                1
```

## codes and files used

**files:**

`fb_synonym_fb_2026_01.tsv.gz` downloaded from flybase which stores the
latest FBgn and Symbol.

**codes:**

- 0_extract-motif-names.sh

- 1_Standardize-gene-names.R: update genes info for each database

- 2_merge-all.R: merge all results

## Thanks

Thanks to Claude code for generating the web crawler scripts.
