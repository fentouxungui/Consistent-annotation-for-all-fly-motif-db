library(tidyverse)
dir.create('results',showWarnings = FALSE)

# ==============================================================================
# 1. 读入并解析 FlyBase 官方全量字典 (fb_synonyms.tsv)
# ==============================================================================
cat("正在加载 FlyBase 官方全量标识符字典...\n")
# 官方表前几行是注释，真实数据以制表符分隔
fb_raw <- read_tsv("../fb_synonym_fb_2026_01.tsv.gz", comment = "##", col_names = FALSE, show_col_types = FALSE)
# fb_synonym_fb_2026_01.tsv.gz 文件有一个问题，第二列有的是基因名，有的是物种Dmel，然后第三列才是基因名
fb_raw$X2[fb_raw$X2 == 'Dmel'] <- fb_raw$X3[fb_raw$X2 == 'Dmel']


# 建立 [FBgn 编号 -> 官方标准 Symbol] 的映射字典
fb_dict <- fb_raw %>%
  select(FB = X1, Symbol = X2) %>%
  distinct() %>%
  as.data.frame() # 转换为 R 快速查询向量

fbgn_dict <- fb_dict[grepl("FBgn", fb_dict$FB),]
fbgn_symbol_dup <- unique(fbgn_dict$Symbol[duplicated(fbgn_dict$Symbol)])


########### 1. flyreg.v2.names.txt
df <- read.delim('./0_names/flyreg.v2.names.txt', stringsAsFactors = FALSE, header = FALSE)
colnames(df)[1] <- 'raw'
df$gene_raw <- trimws(gsub('MOTIF ', '', df$raw))
df_yes <- df[df$gene_raw %in% fb_dict$Symbol,]
df_not <- df[!df$gene_raw %in% fb_dict$Symbol,]
names_dict <- c('BEAF-32B' = 'BEAF-32',
                   "br-Z1" = 'br',
                   "br-Z2" = 'br',
                   "br-Z3" = 'br',
                   "br-Z4" = 'br',
                   "Cf2-II" = 'Cf2',
                   "dsx-F" = 'dsx',
                   "dsx-M" = 'dsx',
                   "Espl" = 'E(spl)m8-HLH', # by Google AI 
                   "HLHm5" = 'E(spl)m5-HLH',# by Google AI 
                   "Hr46" = 'Hr3',
                   "p120" = 'p120ctn',
                   "SuH" = 'Su(H)',
                   "suHw" = 'su(Hw)')
df_not$Symbol <- names_dict[df_not$gene_raw] 
df_yes$Symbol <- df_yes$gene_raw
df <- rbind(df_yes, df_not)
table(df$Symbol %in% fbgn_dict$Symbol)
table(df$Symbol %in% fbgn_symbol_dup)
df$FBgn <- fbgn_dict$FB[match(df$Symbol, fbgn_dict$Symbol)]
df$source <- 'flyreg.v2.meme'
write.table(as.data.frame(df), file = 'results/flyreg.v2.names.latest.txt', row.names = FALSE)



########### 2. idmmpmm2009.names.txt
df <- read.delim('./0_names/idmmpmm2009.names.txt', stringsAsFactors = FALSE, header = FALSE)
colnames(df)[1] <- 'raw'
df$gene_raw <- trimws(gsub('MOTIF ', '', df$raw))
df_yes <- df[df$gene_raw %in% fb_dict$Symbol,]
df_not <- df[!df$gene_raw %in% fb_dict$Symbol,]
names_dict <- c('h' = 'hry' # by Google AI 
                )
df_not$Symbol <- names_dict[df_not$gene_raw] 
df_yes$Symbol <- df_yes$gene_raw
df <- rbind(df_yes, df_not)
table(df$Symbol %in% fbgn_dict$Symbol)
table(df$Symbol %in% fbgn_symbol_dup)
df$FBgn <- fbgn_dict$FB[match(df$Symbol, fbgn_dict$Symbol)]
df$source <- 'idmmpmm2009.meme'
write.table(as.data.frame(df), file = 'results/idmmpmm2009.names.latest.txt', row.names = FALSE)



########### 3. dmmpmm2009.names.txt
df <- read.delim('./0_names/dmmpmm2009.names.txt', stringsAsFactors = FALSE, header = FALSE)
colnames(df)[1] <- 'raw'
df$gene_raw <- trimws(gsub('MOTIF ', '', df$raw))
df_yes <- df[df$gene_raw %in% fb_dict$Symbol,]
df_not <- df[!df$gene_raw %in% fb_dict$Symbol,]
names_dict <- c("br-Z1" = 'br',
                "br-Z2" = 'br',
                "br-Z3" = 'br',
                "br-Z4" = 'br')
df_not$Symbol <- names_dict[df_not$gene_raw] 
df_yes$Symbol <- df_yes$gene_raw
df <- rbind(df_yes, df_not)
table(df$Symbol %in% fbgn_dict$Symbol)
table(df$Symbol %in% fbgn_symbol_dup)
df$FBgn <- fbgn_dict$FB[match(df$Symbol, fbgn_dict$Symbol)]
df$source <- 'dmmpmm2009.meme'
write.table(as.data.frame(df), file = 'results/dmmpmm2009.names.latest.txt', row.names = FALSE)


########### 4. fly_factor_survey.names.txt
df <- read.delim('./0_names/fly_factor_survey.names.txt', stringsAsFactors = FALSE, header = FALSE)
colnames(df)[1] <- 'raw'
df$gene_raw <- trimws(gsub('MOTIF ', '', df$raw))
df$FBgn_raw <- unlist(lapply(strsplit(df$gene_raw, split = ' '), '[', 1))
df$FBgn_raw <- gsub('_\\d+', '', df$FBgn_raw)
df$symbol_raw <-  unlist(lapply(strsplit(df$gene_raw, split = ' '), '[', 2))
df$symbol_raw <- gsub("(_SOLEXA|_SANGER|_NAR|_FlyReg|_FlyFactorSurvey|_v[0-9]|_[0-9]|-[0-9]).*", "", df$symbol_raw, ignore.case = TRUE)
df$symbol_raw <- gsub("_cell", "", df$symbol_raw, ignore.case = TRUE)
df$symbol_raw <- gsub("br-.*", "br", df$symbol_raw)
df$symbol_raw <- gsub("lola-.*", "lola", df$symbol_raw)
df$symbol_raw <- gsub("_da*", "", df$symbol_raw)

df_yes <- df[df$FBgn_raw %in% fbgn_dict$FB,]
df_yes$FBgn <- df_yes$FBgn_raw
df_yes$Symbol <- fbgn_dict$Symbol[match(df_yes$FBgn, fbgn_dict$FB)]

df_not <- df[!df$FBgn_raw %in% fbgn_dict$FB,]
df_not_yes <- df_not[df_not$symbol_raw %in% fbgn_dict$Symbol,]
df_not_yes$Symbol <- df_not_yes$symbol_raw
df_not_yes$FBgn <- fbgn_dict$FB[match(df_not_yes$Symbol, fbgn_dict$Symbol)]

df_not_not <- df_not[!df_not$symbol_raw %in% fbgn_dict$Symbol,]
write.csv(unique(df_not_not$FBgn_raw), file = 'fly_factor_survey-for-flybase-batchdownload.csv')
# https://flybase.org/convert/id 可以识别旧的FBgn ID
ref_df <- read.delim('./id_validation_table_4139278.txt',stringsAsFactors = FALSE)
ref_df <- ref_df[ref_df$current_symbol != '-',]
ref_df <- ref_df[!ref_df$X.submitted_item %in% ref_df$X.submitted_item[duplicated(ref_df$X.submitted_item)],]
df_not_not$FBgn <- ref_df$validated_id[match(df_not_not$FBgn_raw, ref_df$X.submitted_item)]
df_not_not$FBgn[df_not_not$symbol_raw == 'lola_PK'] <- 'FBgn0283521'
df_not_not$FBgn[df_not_not$symbol_raw == 'Atf'] <- 'FBgn0265193'
df_not_not$FBgn[df_not_not$symbol_raw == 'CG31782_F9'] <- 'FBgn0263744' # 假基因，不是转录因子！！！
df_not_not$FBgn[df_not_not$symbol_raw == 'CG31782-F9'] <- 'FBgn0263744' # 假基因，不是转录因子！！！
df_not_not$Symbol <- fbgn_dict$Symbol[match(df_not_not$FBgn, fbgn_dict$FB)]

df <- rbind(rbind(df_yes, df_not_yes), df_not_not)
df$source <- 'fly_factor_survey.meme'
write.table(as.data.frame(df), file = 'results/fly_factor_survey.names.latest.txt', row.names = FALSE)



########### 5. OnTheFly_2014_Drosophila.meme
df <- read.delim('./0_names/OnTheFly_2014_Drosophila.names.txt', stringsAsFactors = FALSE, header = FALSE)
colnames(df)[1] <- 'raw'
df$gene_raw <- trimws(gsub('MOTIF ', '', df$raw))
df$OTF <- gsub('\\.\\d+', '', unlist(lapply(strsplit(df$gene_raw, split = ' '),'[',1)))
df$Temp <- gsub('(_DROME_B1H)|(_DROME_DNaseI)|(_DROME_SELEX)|()', '', unlist(lapply(strsplit(df$gene_raw, split = ' '),'[',2)))
df$Temp <- gsub('(_B1H)|(_DNaseI)|(_SELEX)', '', df$Temp)
write.csv(df$Temp, file = 'OnTheFly_2014_Drosophila-for-flybase-batchdownload.csv')
# 使用爬虫脚本./web-spider-by-claude-code-by-keyword/onthefly_spider.py 以Temp列作为关键词进行信息爬取
# https://bhapp.c2b2.columbia.edu/OnTheFly/cgi-bin/TF_search.php


library(readxl)
ref <- read_excel('./web-spider-by-claude-code-by-keyword/OnTheFly_search_results.xlsx', sheet = 1)
df$Uniprot_Name <- gsub('OTF\\d+\\.\\d+ ', '', gsub('(_B1H)|(_DNaseI)|(_SELEX)', '', df$gene_raw))
table(df$Uniprot_Name %in% ref$Uniprot_Name)
df$FBgn_db <- ref$Gene[match(df$Uniprot_Name, ref$Uniprot_Name)]
df$Symbol_db <- ref$Symbol[match(df$Uniprot_Name, ref$Uniprot_Name)]

df_exist <- df[!is.na(df$FBgn_db),]
df_lost <- df[is.na(df$FBgn_db),] # AI search or use the url in meme file to get annotation
write.csv(df_lost, file = 'OnTheFly_gene_lost.csv')
# 使用web-spider-by-claude-code-by-OTF/scrape_onthefly.py打开每个motif的url提取名字
df_lost <- read.csv('./web-spider-by-claude-code-by-OTF/OnTheFly_gene_lost_with_name.csv',stringsAsFactors = FALSE)
df_lost$X <- NULL
df_lost$ID <- df_lost$OTF_Name
df_lost$Temp <- gsub('(_DROME_B1H)|(_DROME_DNaseI)|(_DROME_SELEX)|()', '', df_lost$ID)
df_lost$Temp <- gsub('(_B1H)|(_DNaseI)|(_SELEX)', '', df_lost$Temp)
df_lost$OTF_Name <- NULL
# 再用一样的爬虫脚本提取FBgn等信息
write.csv(df_lost$Temp, file = 'OnTheFly_2014_Drosophila-for-flybase-batchdownload-2.csv')
ref_2 <- read_excel('./web-spider-by-claude-code-by-keyword/OnTheFly_search_results-2.xlsx', sheet = 1)
ref_2 <- ref_2[-7,]
df_lost$Uniprot_Name <- gsub('OTF\\d+\\.\\d+ ', '', gsub('(_B1H)|(_DNaseI)|(_SELEX)', '', df_lost$ID))
table(df_lost$Uniprot_Name %in% ref_2$Uniprot_Name)
df_lost$FBgn_db <- ref_2$Gene[match(df_lost$Uniprot_Name, ref_2$Uniprot_Name)]
df_lost$Symbol_db <- ref_2$Symbol[match(df_lost$Uniprot_Name, ref_2$Uniprot_Name)]
# 注意逻辑上，应该先做url爬虫，提取NAME，再用keyword爬虫，这样会少一次keyword爬虫

df <- rbind(df_exist, df_lost)
table(df$Symbol_db %in% fbgn_dict$Symbol)
table(df$FBgn_db %in% fbgn_dict$FB)
df_yes <- df[df$FBgn_db %in% fbgn_dict$FB,]
df_yes$FBgn <- df_yes$FBgn_db

df_no <- df[!df$FBgn_db %in% fbgn_dict$FB,]
write.csv(df_no,file = 'OnTheFly_2014_Drosophila-old-FBgn.csv')
# https://flybase.org/convert/id 在线工具update FBgn
ref <- read.delim('./id_validation_table_424148.txt',stringsAsFactors = FALSE)
df_no$FBgn <- ref$validated_id[match(df_no$FBgn_db, ref$X.submitted_item)]
df <- rbind(df_yes, df_no)
table(df$FBgn %in% fbgn_dict$FB)

df$Symbol <- fbgn_dict$Symbol[match(df$FBgn, fbgn_dict$FB)]
df$source <- 'OnTheFly_2014_Drosophila.meme'
write.table(as.data.frame(df), file = 'results/OnTheFly_2014_Drosophila.names.latest.txt', row.names = FALSE)



