d1 <- read.table('./results/dmmpmm2009.names.latest.txt',stringsAsFactors = FALSE, header = 1)
d2 <- read.table('./results/fly_factor_survey.names.latest.txt',stringsAsFactors = FALSE, header = 1)
d3 <- read.table('./results/flyreg.v2.names.latest.txt',stringsAsFactors = FALSE, header = 1)
d4 <- read.table('./results/idmmpmm2009.names.latest.txt',stringsAsFactors = FALSE, header = 1)
d5 <- read.table('./results/OnTheFly_2014_Drosophila.names.latest.txt',stringsAsFactors = FALSE, header = 1)
columns_kept <- c('source', 'raw','FBgn','Symbol')
res <- rbind(d1[,columns_kept], d2[,columns_kept],  d3[,columns_kept],  d4[,columns_kept],  d5[,columns_kept])
table(res$source)
length(unique(res$FBgn))
sort(table(res$Symbol),decreasing = TRUE)


write.csv(res,file = 'Consistent-annotations-for-all-fly-motif-database.csv')
