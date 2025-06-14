library(stringr)
library(clusterProfiler)

plot_total <- function (all_input, tandem_list_file, enricher_result){

go_anno<-read.table(all_input,sep="\t",header=T, quote = "")
names(go_anno)
go2gene <- go_anno[, c(1, 2)]
go2name <- go_anno[, c(1, 3)]

data <- read.table(tandem_list_file,header=F)
genes <- as.character(data$V1)

ego <- enricher(genes, TERM2GENE = go2gene, TERM2NAME = go2name, pAdjustMethod = "BH",pvalueCutoff  = 0.05, qvalueCutoff  = 0.2)
write.table(as.data.frame(ego),enricher_result,sep="\t",row.names =F,quote=F)
ego_df <- as.data.frame(ego)
print(ego_df$Description)
}
args <- commandArgs(trailingOnly = TRUE)

all_input <- args[1]

tandem_list_file <- args[2]

enricher_result <- args[3]
plot_total(all_input, tandem_list_file, enricher_result)

# ## Processed interproscan results as input
# 
# library(stringr)
# library(clusterProfiler)
# 
# plot_total <- function (all_input, out_anno_file, tandem_list_file, enricher_result){
#     iprscan_go<-read.table(all_input,sep="\t",header=F)
#     all_go_list=str_split(iprscan_go$V2,",") 
#     ip_gene2go <- data.frame(GID = rep(iprscan_go$V1, times = sapply(all_go_list, length)), GO = unlist(all_go_list), EVIDENCE = "IEA")
#     write.table(ip_gene2go,file=out_anno_file,sep="\t",row.names=F,quote=F)
#     head(ip_gene2go) 
#     
#     data <- read.table(tandem_list_file,header=F)
#     genes <- as.character(data$V1)
#     genes
#     go_anno <- read.table(out_anno_file,header = T,sep = "\t")
#     go2gene <- go_anno[, c(2, 1)] 
#     go2name <- go_anno[, c(2, 3)]
#     go2gene
#     go2name
#     ego <- enricher(genes, TERM2GENE = go2gene, TERM2NAME = go2name, pAdjustMethod = "BH",pvalueCutoff  = 0.05, qvalueCutoff  = 0.2)
#     write.table(as.data.frame(ego),enricher_result,sep="\t",row.names =F,quote=F)
# }
# 
# 
# args <- commandArgs(trailingOnly = TRUE)
# 
# all_input <- args[1]
# 
# out_anno_file <- args[2]
# 
# tandem_list_file <- args[3]
# 
# enricher_result <- args[4]
# plot_total(all_input, out_anno_file, tandem_list_file, enricher_result)







# BiocManager::install("AnnotationHub")
# BiocManager::install("AnnotationDbi")
# BiocManager::install("rtracklayer")
# 
# # get mazie db
# library(AnnotationHub)
# hub <- AnnotationHub()
# unique(hub$species) 
# unique(hub$rdataclass)
# query(hub[hub$rdataclass == "OrgDb"] , "Zea mays")
# library(rtracklayer)
# maize <- hub[["AH117408"]]
# maize
# library(AnnotationDbi)
# saveDb(maize,file="/media/dell/E/Suppmentary_data/09tandem27/Zea.mays_class/maize.OrgDb") 
# 
# # load maize db
# library(clusterProfiler)
# maize_db<-loadDb(file="/media/dell/E/Suppmentary_data/09tandem27/Zea.mays_class/maize.OrgDb")
# length(keys(maize_db))
# columns(maize_db)
# keytypes(maize_db)
# head(keys(maize_db, keytype = "ENTREZID"))
# 
# # 
# library(biomaRt)
# listMarts( host="https://plants.ensembl.org" )
# EPgenes = useEnsembl(biomart="plants_mart",  host="https://plants.ensembl.org")
# dsets = listDatasets(EPgenes)
# tail(dsets)
# dsets[grep("Zea mays", dsets$description),]
# 
# mart <- biomaRt::useMart(biomart = "plants_mart",
#                          dataset = "zmays_eg_gene",
#                          host = "https://plants.ensembl.org")
# str(listFilters(mart))
# str(listAttributes(mart))
# 
# gene = read.table("/media/dell/E/Suppmentary_data/09tandem27/Zea.mays_class/Zea.mays.go.txt", header = F, sep = "\t")
# gn_vector <- gene$V1
# gn_vector <- sub("^gene:", "", gn_vector)
# gn_vector
# length(gn_vector)
# head(gn_vector)
# 
# genes <- getBM(filters = "ensembl_gene_id",
#                attributes = c("ensembl_gene_id","entrezgene_id"),
#                values = gn_vector, 
#                mart = mart)
# genes$entrezgene_id
# non_na_count <- sum(!is.na(genes$entrezgene_id))
# genes
# non_na_count
# genes
# na_rows <- !apply(is.na(genes), 1, any)
# na_rows
# genes_rm_na <- genes[na_rows, ]
# genes_rm_na
# str(genes_rm_na)
# entrezgene_vector <- genes_rm_na$entrezgene_id
# length(keys(maize_db))
# columns(maize_db)
# keytypes(maize_db)
# head(keys(maize_db, keytype = "ACCNUM"))
# 
# entrezgene_vector
# # ids <- bitr(gn_vector, fromType="ENSEMBL", toType=c("ENTREZID"), OrgDb=maize_db)
# maize_ego <- enrichGO(gene          = entrezgene_vector,
#                       OrgDb         = maize_db,
#                       ont           = "All",
#                       keyType       = "ENTREZID",
#                       pAdjustMethod = "BH",
#                       pvalueCutoff  = 0.01,
#                       qvalueCutoff  = 0.05,
#                       readable      = TRUE)
# maize_ego[0:10,"Description"]
# maize_ego
# entrezgene_vector <- as.character(entrezgene_vector)
# ggo <- groupGO(gene     = entrezgene_vector,
#                OrgDb    = maize_db,
#                keyType       = "ENTREZID",
#                ont      = "MF",
#                level    = 5,
#                readable = TRUE)
# ggo
# head(ggo)
# ggo_sorted <- ggo[order(ggo$Count, decreasing = TRUE),]
# ggo_sorted[0:10,"Description"]







