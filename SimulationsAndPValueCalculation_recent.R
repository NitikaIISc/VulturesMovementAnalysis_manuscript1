##First run this so you have Degree_coFlight etc. and the observed values to caluculate p-values of reference distribution against###########
library(data.table)
library(tidyr)
library(igraph)
####################    Breeding Layer  ###################
##################    Centrality Per Layer #############
#setwd("C:/XXXXX")
dat<-read.csv("BreedingCentralitySimplified2021.csv", header = T)
LayerIDs<-as.data.frame(cbind(c(1:3, "Aggr"), c("CoFlight","NocturnalGroundInteractions","DiurnalGroundInteractions","Aggregate")))
names(LayerIDs) = c("Layer", "LayerName")
####
dat1<-dplyr::left_join(dat, LayerIDs, by = "Layer")
dat_wide<-as.data.frame(dat1[,-c(1,2)] %>%
                          pivot_wider(names_from = c(LayerName), 
                                      values_from = c(Degree, Strength, PageRank, StrengthPerDegree)))
Obs_Degrees<-dat_wide[,c("Label","Degree_CoFlight",
                         "Degree_NocturnalGroundInteractions","Degree_DiurnalGroundInteractions","Degree_Aggregate")]
Obs_Strengths<-dat_wide[,c("Label","Strength_CoFlight",
                           "Strength_NocturnalGroundInteractions","Strength_DiurnalGroundInteractions","Strength_Aggregate")]
Obs_PageRanks<-dat_wide[,c("Label","PageRank_CoFlight",
                           "PageRank_NocturnalGroundInteractions","PageRank_DiurnalGroundInteractions","PageRank_Aggregate")]

##################### For degree coflight, NocturnalGroundInteractions, DiurnalGroundInteractions correlation with Aggregate Degree ###########
Degree_CoFlight <- cor.test(Obs_Degrees$Degree_CoFlight, Obs_Degrees$Degree_Aggregate, 
                            method = "spearman")
Degree_NocturnalGroundInteractions <- cor.test( Obs_Degrees$Degree_Aggregate, Obs_Degrees$Degree_NocturnalGroundInteractions,
                                               method = "spearman")

Degree_DiurnalGroundInteractions <- cor.test(Obs_Degrees$Degree_DiurnalGroundInteractions, Obs_Degrees$Degree_Aggregate, 
                                             method = "spearman")


### Strength

Strength_CoFlight <- cor.test(Obs_Strengths$Strength_CoFlight , Obs_Strengths$Strength_Aggregate, 
                            method = "spearman")


Strength_NocturnalGroundInteractions <- cor.test( Obs_Strengths$Strength_Aggregate, Obs_Strengths$Strength_NocturnalGroundInteractions,
                                                method = "spearman")


Strength_DiurnalGroundInteractions <- cor.test(Obs_Strengths$Strength_DiurnalGroundInteractions, Obs_Strengths$Strength_Aggregate, 
                                             method = "spearman")



# page rank
PageRank_CoFlight <- cor.test(Obs_PageRanks$PageRank_CoFlight ,Obs_PageRanks$PageRank_Aggregate, 
                              method = "spearman")


PageRank_NocturnalGroundInteractions <- cor.test(Obs_PageRanks$PageRank_NocturnalGroundInteractions, Obs_PageRanks$PageRank_Aggregate,
                                                  method = "spearman")


PageRank_DiurnalGroundInteractions <- cor.test(Obs_PageRanks$PageRank_DiurnalGroundInteractions, Obs_PageRanks$PageRank_Aggregate, 
                                               method = "spearman")




########## For iterating networks by shuffling ID2 repeatedly by layer (group) ##########
#setwd("C:/Users/nitik/Box Sync/Manuscript4_Vulture Data/VulturesCodes-master/MyOutputs/FiguresForVultureManuscript1/FiguresForVultureManuscript2021/IgraphNetworksRandomCoods")
BreedingEdgelist<-read.csv("SimplifiedBreedingEdgelist2021.csv")
shuffle1<-setDT(BreedingEdgelist)[, ID2:= sample(ID2) , by = lyr1]
iter<-10000
RandDeg_CoFlight<-as.numeric()
RandDeg_NocturnalGroundInteractions<-as.numeric()
RandDeg_DiurnalGroundInteractions<-as.numeric()
RandStr_CoFlight<-as.numeric()
RandStr_NocturnalGroundInteractions<-as.numeric()
RandStr_DiurnalGroundInteractions<-as.numeric()
RandPgR_CoFlight<-as.numeric()
RandPgR_NocturnalGroundInteractions<-as.numeric()
RandPgR_DiurnalGroundInteractions<-as.numeric()
RandSbyD_CoFlight<-as.numeric()
RandSbyD_NocturnalGroundInteractions<-as.numeric()
RandSbyD_DiurnalGroundInteractions<-as.numeric()
RandDeg_Agg<-as.numeric()
RandStr_Agg<-as.numeric()
RandPgR_Agg<-as.numeric()
RandSbyD_Agg<-as.numeric()
RandCorrDegree_CoFlight<-data.frame()
RandCorrDegree_NocturnalGroundInteractions<-data.frame()
RandCorrDegree_DiurnalGroundInteractions<-data.frame()
RandCorrStrength_CoFlight<-data.frame()
RandCorrStrength_NocturnalGroundInteractions<-data.frame()
RandCorrStrength_DiurnalGroundInteractions<-data.frame()
RandCorrPageRank_CoFlight<-data.frame()
RandCorrPageRank_NocturnalGroundInteractions<-data.frame()
RandCorrPageRank_DiurnalGroundInteractions<-data.frame()
RandCorrSbyD_CoFlight<-data.frame()
RandCorrSbyD_NocturnalGroundInteractions<-data.frame()
RandCorrSbyD_DiurnalGroundInteractions<-data.frame()

for(i in 1:iter){
  ##only shuffle within layers 
  df1<-subset(BreedingEdgelist, lyr1 == 1) # subset for that layer #
  length(unique(levels(as.factor(df1[,3])))) 
  #creating an igraph object 
  el1=as.matrix(df1[,c(1,3,5)]) 
  g1=graph.edgelist(el1[,c(1,2)], directed=FALSE) #We first create
  #a network from the first two columns, which has the list of vertices 
  E(g1)$weight=as.numeric(el1[,3]) 
  g_1=g1 
  V(g_1)$name=sample(V(g1)$name) ## sampled/shuffled the vertices
  RandDeg1_CoFlight<-as.data.frame(degree(simplify(g_1)))
  RandDeg1_CoFlight$ID<-rownames(RandDeg1_CoFlight)
  colnames(RandDeg1_CoFlight)[1]<-"CoFl_deg"
  RandStr1_CoFlight<-as.data.frame(strength(simplify(g_1)))
  RandStr1_CoFlight$ID<-rownames(RandStr1_CoFlight)
  colnames(RandStr1_CoFlight)[1]<-"CoFl_str"
  RandPgR1_CoFlight<-as.data.frame(page.rank(simplify(g_1))$vector)
  RandPgR1_CoFlight$ID<-rownames(RandPgR1_CoFlight)
  colnames(RandPgR1_CoFlight)[1]<-"CoFl_PgR"
  RandSbyD1_CoFlight<-as.data.frame(strength(simplify(g_1))/degree(simplify(g_1)))
  RandSbyD1_CoFlight$ID<-rownames(RandSbyD1_CoFlight)
  colnames(RandSbyD1_CoFlight)[1]<-"CoFl_SbyD"
  RandDeg_CoFlight<-c(RandDeg_CoFlight, degree(simplify(g_1)))  
  RandStr_CoFlight<-c(RandStr_CoFlight, strength(simplify(g_1)))  
  RandPgR_CoFlight<-c(RandPgR_CoFlight, page.rank(simplify(g_1))$vector)
  RandSbyD_CoFlight<-c(RandSbyD_CoFlight,as.data.frame(strength(simplify(g_1))/degree(simplify(g_1))))
  alt_el1<-as_edgelist(simplify(g_1), names = TRUE)
  Rand1_el<-as.data.frame(get.edgelist(simplify(g_1)))
  Rand1_el$wt<-E(simplify(g_1))$weight
  colnames(Rand1_el)<-c("shuffID1","shuffID2","wt")
  
  df2<-subset(BreedingEdgelist, lyr1 == 2) # subset for that layer #
  length(unique(levels(as.factor(df2[,3])))) 
  #creating an igraph object 
  el2=as.matrix(df2[,c(1,3,5)]) 
  g2=graph.edgelist(el2[,c(1,2)], directed=FALSE) #We first create
  #a network from the first two columns, which has the list of vertices 
  E(g2)$weight=as.numeric(el2[,3]) 
  g_2=g2 
  V(g_2)$name=sample(V(g2)$name) ## sampled/shuffled the vertices
  RandDeg_NocturnalGroundInteractions<-c(RandDeg_NocturnalGroundInteractions, degree(simplify(g_2)))  
  RandStr_NocturnalGroundInteractions<-c(RandStr_NocturnalGroundInteractions, strength(simplify(g_2))) 
  RandDeg1_NocturnalGroundInteractions<-as.data.frame(degree(simplify(g_2)))
  RandDeg1_NocturnalGroundInteractions$ID<-rownames(RandDeg1_NocturnalGroundInteractions)
  colnames(RandDeg1_NocturnalGroundInteractions)[1]<-"CoRo_deg"
  RandStr1_NocturnalGroundInteractions<-as.data.frame(strength(simplify(g_2)))
  RandStr1_NocturnalGroundInteractions$ID<-rownames(RandStr1_NocturnalGroundInteractions)
  colnames(RandStr1_NocturnalGroundInteractions)[1]<-"CoRo_str"
  RandPgR1_NocturnalGroundInteractions<-as.data.frame(page.rank(simplify(g_2))$vector)
  RandPgR1_NocturnalGroundInteractions$ID<-rownames(RandPgR1_NocturnalGroundInteractions)
  colnames(RandPgR1_NocturnalGroundInteractions)[1]<-"CoRo_PgR"
  RandSbyD1_NocturnalGroundInteractions<-as.data.frame(strength(simplify(g_2))/degree(simplify(g_2)))
  RandSbyD1_NocturnalGroundInteractions$ID<-rownames(RandSbyD1_NocturnalGroundInteractions)
  colnames(RandSbyD1_NocturnalGroundInteractions)[1]<-"CoRo_SbyD"
  RandSbyD_NocturnalGroundInteractions<-c(RandSbyD_NocturnalGroundInteractions,as.data.frame(strength(simplify(g_2))/degree(simplify(g_2))))
  RandDeg_NocturnalGroundInteractions<-c(RandDeg_NocturnalGroundInteractions, degree(simplify(g_2)))  
  RandStr_NocturnalGroundInteractions<-c(RandStr_NocturnalGroundInteractions, strength(simplify(g_2)))  
  RandPgR_NocturnalGroundInteractions<-c(RandPgR_NocturnalGroundInteractions, page.rank(simplify(g_2))$vector)
  alt_el2<-as_edgelist(simplify(g_2), names = TRUE)
  Rand2_el<-as.data.frame(get.edgelist(simplify(g_2)))
  Rand2_el$wt<-E(simplify(g_2))$weight
  colnames(Rand2_el)<-c("shuffID1","shuffID2","wt")
  
  df3<-subset(BreedingEdgelist, lyr1 == 3) # subset for that layer #
  length(unique(levels(as.factor(df3[,3])))) 
  #creating an igraph object 
  el3=as.matrix(df3[,c(1,3,5)]) 
  g3=graph.edgelist(el3[,c(1,2)], directed=FALSE) #We first create
  #a network from the first two columns, which has the list of vertices 
  E(g3)$weight=as.numeric(el3[,3]) 
  g_3=g3 
  V(g_3)$name=sample(V(g3)$name) ## sampled/shuffled the vertices
  
  RandDeg1_DiurnalGroundInteractions<-as.data.frame(degree(simplify(g_3)))
  RandDeg1_DiurnalGroundInteractions$ID<-rownames(RandDeg1_DiurnalGroundInteractions)
  colnames(RandDeg1_DiurnalGroundInteractions)[1]<-"CoFe_deg"
  RandStr1_DiurnalGroundInteractions<-as.data.frame(strength(simplify(g_3)))
  RandStr1_DiurnalGroundInteractions$ID<-rownames(RandStr1_DiurnalGroundInteractions)
  colnames(RandStr1_DiurnalGroundInteractions)[1]<-"CoFe_str"
  RandPgR1_DiurnalGroundInteractions<-as.data.frame(page.rank(simplify(g_3))$vector)
  RandPgR1_DiurnalGroundInteractions$ID<-rownames(RandPgR1_DiurnalGroundInteractions)
  colnames(RandPgR1_DiurnalGroundInteractions)[1]<-"CoFe_PgR"
  RandSbyD1_DiurnalGroundInteractions<-as.data.frame(strength(simplify(g_3))/degree(simplify(g_3)))
  RandSbyD1_DiurnalGroundInteractions$ID<-rownames(RandSbyD1_DiurnalGroundInteractions)
  colnames(RandSbyD1_DiurnalGroundInteractions)[1]<-"CoFe_SbyD"
  RandDeg_DiurnalGroundInteractions<-c(RandDeg_DiurnalGroundInteractions, degree(simplify(g_3))) 
  RandStr_DiurnalGroundInteractions<-c(RandStr_DiurnalGroundInteractions, strength(simplify(g_3)))  
  RandPgR_DiurnalGroundInteractions<-c(RandPgR_DiurnalGroundInteractions, page.rank(simplify(g_3))$vector)
  RandSbyD_DiurnalGroundInteractions<-c(RandSbyD_DiurnalGroundInteractions,strength(simplify(g_3))/degree(simplify(g_3)))
  alt_el3<-as_edgelist(simplify(g_3), names = TRUE)
  Rand3_el<-as.data.frame(get.edgelist(simplify(g_3)))
  Rand3_el$wt<-E(simplify(g_3))$weight
  colnames(Rand3_el)<-c("shuffID1","shuffID2","wt")
  
  ######## Creating a new network for random AGGREGATE #########
  
  RandAgg<-rbind(Rand1_el, Rand2_el, Rand3_el)
  elAgg=as.matrix(RandAgg) #igraph needs the edgelist to be in matrix format 
  gAgg=graph.edgelist(elAgg[,c(1,2)], directed=FALSE) #We first create
  #a network from the first two columns, which has the list of vertices
  E(gAgg)$weight=as.numeric(elAgg[,3]) 
  
  RandDeg_Agg<-c(RandDeg_Agg, degree(simplify(gAgg))) 
  RandStr_Agg<-c(RandStr_Agg, strength(simplify(gAgg)))  
  RandPgR_Agg<-c(RandPgR_Agg,  page.rank(simplify(gAgg))$vector)  
  RandSbyD_Agg<-c(RandSbyD_Agg, strength(simplify(gAgg))/degree(simplify(gAgg)))
  RandDeg1_Agg<-as.data.frame(degree(simplify(gAgg)))
  RandDeg1_Agg$ID<-rownames(RandDeg1_Agg)
  colnames(RandDeg1_Agg)[1]<-"Aggr_deg"
  RandStr1_Agg<-as.data.frame(strength(simplify(gAgg)))
  RandStr1_Agg$ID<-rownames(RandStr1_Agg)
  colnames(RandStr1_Agg)[1]<-"Aggr_str"
  RandPgR1_Agg<-as.data.frame(page.rank(simplify(gAgg))$vector)
  RandPgR1_Agg$ID<-rownames(RandPgR1_Agg)
  colnames(RandPgR1_Agg)[1]<-"Aggr_PgR"
  RandSbyD1_Agg<-as.data.frame(strength(simplify(gAgg))/degree(simplify(gAgg)))
  RandSbyD1_Agg$ID<-rownames(RandSbyD1_Agg)
  colnames(RandSbyD1_Agg)[1]<-"Aggr_SbyD"
  
  ######    Combine all layers and aggregate to sort and join ###
  
  RandDeg_CoFlCoRo<-dplyr::left_join(RandDeg1_CoFlight, RandDeg1_NocturnalGroundInteractions,by ="ID")
  RandDeg_CoFlRoFe<-dplyr::left_join(RandDeg_CoFlCoRo, RandDeg1_DiurnalGroundInteractions, by="ID")
  RandDeg_AggCoFlRoFe<-dplyr::left_join(RandDeg_CoFlRoFe, RandDeg1_Agg,by="ID")
  RandStr_CoFlCoRo<-dplyr::left_join(RandStr1_CoFlight, RandStr1_NocturnalGroundInteractions,by ="ID")
  RandStr_CoFlRoFe<-dplyr::left_join(RandStr_CoFlCoRo, RandStr1_DiurnalGroundInteractions, by="ID")
  RandStr_AggCoFlRoFe<-dplyr::left_join(RandStr_CoFlRoFe, RandStr1_Agg,by="ID")
  RandPgR_CoFlCoRo<-dplyr::left_join(RandPgR1_CoFlight, RandPgR1_NocturnalGroundInteractions,by ="ID")
  RandPgR_CoFlRoFe<-dplyr::left_join(RandPgR_CoFlCoRo, RandPgR1_DiurnalGroundInteractions, by="ID")
  RandPgR_AggCoFlRoFe<-dplyr::left_join(RandPgR_CoFlRoFe, RandPgR1_Agg,by="ID")
  RandSbyD_CoFlCoRo<-dplyr::left_join(RandSbyD1_CoFlight, RandSbyD1_NocturnalGroundInteractions,by ="ID")
  RandSbyD_CoFlRoFe<-dplyr::left_join(RandSbyD_CoFlCoRo, RandSbyD1_DiurnalGroundInteractions, by="ID")
  RandSbyD_AggCoFlRoFe<-dplyr::left_join(RandSbyD_CoFlRoFe, RandSbyD1_Agg,by="ID")
  
  ###### Test statistic: Spearman's rank corrlation ########
  RandCorrDegree_CoFlight <-as.data.frame(rbind(RandCorrDegree_CoFlight,as.data.frame(cbind(
    rho = as.vector(round(as.numeric(as.character(cor.test(RandDeg_AggCoFlRoFe$CoFl_deg,
                                                           RandDeg_AggCoFlRoFe$Aggr_deg, 
                                                           method = "spearman")$estimate)),2)),pValue = cor.test(RandDeg_AggCoFlRoFe$CoFl_deg,
                                                                                                                 RandDeg_AggCoFlRoFe$Aggr_deg, 
                                                                                                                 method = "spearman")$p.value))))
  
  RandCorrDegree_NocturnalGroundInteractions <-as.data.frame(rbind(RandCorrDegree_NocturnalGroundInteractions,as.data.frame(cbind(
    rho = as.vector(round(as.numeric(as.character(cor.test(RandDeg_AggCoFlRoFe$CoRo_deg,
                                                           RandDeg_AggCoFlRoFe$Aggr_deg, 
                                                           method = "spearman")$estimate)),2)),pValue = cor.test(RandDeg_AggCoFlRoFe$CoRo_deg,
                                                                                                                 RandDeg_AggCoFlRoFe$Aggr_deg, 
                                                                                                                 method = "spearman")$p.value))))
  RandCorrDegree_DiurnalGroundInteractions <-as.data.frame(rbind(RandCorrDegree_DiurnalGroundInteractions,as.data.frame(cbind(
    rho = as.vector(round(as.numeric(as.character(cor.test(RandDeg_AggCoFlRoFe$CoFe_deg,
                                                           RandDeg_AggCoFlRoFe$Aggr_deg, 
                                                           method = "spearman")$estimate)),2)),pValue = cor.test(RandDeg_AggCoFlRoFe$CoFe_deg,
                                                                                                                 RandDeg_AggCoFlRoFe$Aggr_deg, 
                                                                                                                 method = "spearman")$p.value))))
  
  ###### For Strength: Test statistic: Spearman's rank corrlation ########
  RandCorrStrength_CoFlight <-as.data.frame(rbind(RandCorrStrength_CoFlight,as.data.frame(cbind(
    rho = as.vector(round(as.numeric(as.character(cor.test(RandStr_AggCoFlRoFe$CoFl_str,
                                                           RandStr_AggCoFlRoFe$Aggr_str, 
                                                           method = "spearman")$estimate)),2)),pValue = cor.test(RandStr_AggCoFlRoFe$CoFl_str,
                                                                                                                 RandStr_AggCoFlRoFe$Aggr_str, 
                                                                                                                 method = "spearman")$p.value))))
  
  RandCorrStrength_NocturnalGroundInteractions <-as.data.frame(rbind(RandCorrStrength_NocturnalGroundInteractions,as.data.frame(cbind(
    rho = as.vector(round(as.numeric(as.character(cor.test(RandStr_AggCoFlRoFe$CoRo_str,
                                                           RandStr_AggCoFlRoFe$Aggr_str, 
                                                           method = "spearman")$estimate)),2)),pValue = cor.test(RandStr_AggCoFlRoFe$CoRo_str,
                                                                                                                 RandStr_AggCoFlRoFe$Aggr_str, 
                                                                                                                 method = "spearman")$p.value))))
  RandCorrStrength_DiurnalGroundInteractions <-as.data.frame(rbind(RandCorrStrength_DiurnalGroundInteractions,as.data.frame(cbind(
    rho = as.vector(round(as.numeric(as.character(cor.test(RandStr_AggCoFlRoFe$CoFe_str,
                                                           RandStr_AggCoFlRoFe$Aggr_str, 
                                                           method = "spearman")$estimate)),2)),pValue = cor.test(RandStr_AggCoFlRoFe$CoFe_str,
                                                                                                                 RandStr_AggCoFlRoFe$Aggr_str, 
                                                                                                                 method = "spearman")$p.value))))
  
  
  ###### For PageRank: Test statistic: Spearman's rank corrlation ########
  
  
  RandCorrPageRank_CoFlight <-as.data.frame(rbind(RandCorrPageRank_CoFlight,as.data.frame(cbind(
    rho = as.vector(round(as.numeric(as.character(cor.test(RandPgR_AggCoFlRoFe$CoFl_PgR,
                                                           RandPgR_AggCoFlRoFe$Aggr_PgR, 
                                                           method = "spearman")$estimate)),2)),pValue = cor.test(RandPgR_AggCoFlRoFe$CoFl_PgR,
                                                                                                                 RandPgR_AggCoFlRoFe$Aggr_PgR, 
                                                                                                                 method = "spearman")$p.value))))
  
  RandCorrPageRank_NocturnalGroundInteractions <-as.data.frame(rbind(RandCorrPageRank_NocturnalGroundInteractions,as.data.frame(cbind(
    rho = as.vector(round(as.numeric(as.character(cor.test(RandPgR_AggCoFlRoFe$CoRo_PgR,
                                                           RandPgR_AggCoFlRoFe$Aggr_PgR, 
                                                           method = "spearman")$estimate)),2)),pValue = cor.test(RandPgR_AggCoFlRoFe$CoRo_PgR,
                                                                                                                 RandPgR_AggCoFlRoFe$Aggr_PgR, 
                                                                                                                 method = "spearman")$p.value))))
  RandCorrPageRank_DiurnalGroundInteractions <-as.data.frame(rbind(RandCorrPageRank_DiurnalGroundInteractions,as.data.frame(cbind(
    rho = as.vector(round(as.numeric(as.character(cor.test(RandPgR_AggCoFlRoFe$CoFe_PgR,
                                                           RandPgR_AggCoFlRoFe$Aggr_PgR, 
                                                           method = "spearman")$estimate)),2)),pValue = cor.test(RandPgR_AggCoFlRoFe$CoFe_PgR,
                                                                                                                 RandPgR_AggCoFlRoFe$Aggr_PgR, 
                                                                                                                 method = "spearman")$p.value))))
  ###### For SbyD: Test statistic: Spearman's rank corrlation ########
  
  
  RandCorrSbyD_CoFlight <-as.data.frame(rbind(RandCorrSbyD_CoFlight,as.data.frame(cbind(
    rho = as.vector(round(as.numeric(as.character(cor.test(RandSbyD_AggCoFlRoFe$CoFl_SbyD,
                                                           RandSbyD_AggCoFlRoFe$Aggr_SbyD, 
                                                           method = "spearman")$estimate)),2)),pValue = cor.test(RandSbyD_AggCoFlRoFe$CoFl_SbyD,
                                                                                                                 RandSbyD_AggCoFlRoFe$Aggr_SbyD, 
                                                                                                                 method = "spearman")$p.value))))
  
  RandCorrSbyD_NocturnalGroundInteractions <-as.data.frame(rbind(RandCorrSbyD_NocturnalGroundInteractions,as.data.frame(cbind(
    rho = as.vector(round(as.numeric(as.character(cor.test(RandSbyD_AggCoFlRoFe$CoRo_SbyD,
                                                           RandSbyD_AggCoFlRoFe$Aggr_SbyD, 
                                                           method = "spearman")$estimate)),2)),pValue = cor.test(RandSbyD_AggCoFlRoFe$CoRo_SbyD,
                                                                                                                 RandSbyD_AggCoFlRoFe$Aggr_SbyD, 
                                                                                                                 method = "spearman")$p.value))))
  RandCorrSbyD_DiurnalGroundInteractions <-as.data.frame(rbind(RandCorrSbyD_DiurnalGroundInteractions,as.data.frame(cbind(
    rho = as.vector(round(as.numeric(as.character(cor.test(RandSbyD_AggCoFlRoFe$CoFe_SbyD,
                                                           RandSbyD_AggCoFlRoFe$Aggr_SbyD, 
                                                           method = "spearman")$estimate)),2)),pValue = cor.test(RandSbyD_AggCoFlRoFe$CoFe_SbyD,
                                                                                                                 RandSbyD_AggCoFlRoFe$Aggr_SbyD, 
                                                                                                                 method = "spearman")$p.value))))
  
  
  
}


##p-value degree co-flight and aggregate correlation rho: positive
# two tailed:

obs_D_F = Degree_CoFlight$estimate
exp_D_F = RandCorrDegree_CoFlight$rho

rank_obs_D_F <- sum(exp_D_F <= obs_D_F)

# Calculate the quantile based on the rank
quantile_value_D_F <- rank_obs_D_F / length(exp_D_F)
p_deg_coFly<- min(c(quantile_value_D_F,(1-quantile_value_D_F)))*2

# degree nocturnal:
obs_D_N = Degree_NocturnalGroundInteractions$estimate
exp_D_N = RandCorrDegree_NocturnalGroundInteractions$rho

rank_obs_D_N <- sum(exp_D_N <= obs_D_N) 

# Calculate the quantile based on the rank
quantile_value_D_N <- rank_obs_D_N / length(exp_D_N)
p_deg_coRoost<- min(c(quantile_value_D_N,(1-quantile_value_D_N)))*2
  
# degree diurnal
obs_D_D = Degree_DiurnalGroundInteractions$estimate
exp_D_D = RandCorrDegree_DiurnalGroundInteractions$rho

rank_obs_D_D <- sum(exp_D_D <= obs_D_D) 

# Calculate the quantile based on the rank
quantile_value_D_D <- rank_obs_D_D / length(exp_D_D)
p_deg_coFeed<- min(c(quantile_value_D_D,(1-quantile_value_D_D)))*2


####################  Strength ###########################
# strength flight:
obs_S_F = Strength_CoFlight$estimate
exp_S_F = RandCorrStrength_CoFlight$rho

rank_obs_S_F <- sum(exp_S_F <= obs_S_F)

# Calculate the quantile based on the rank
quantile_value_S_F <- rank_obs_S_F / length(exp_S_F)
p_str_coFly<- min(c(quantile_value_S_F,(1-quantile_value_S_F)))*2


# strength nocturnal:
obs_S_N = Strength_NocturnalGroundInteractions$estimate
exp_S_N = RandCorrStrength_NocturnalGroundInteractions$rho

rank_obs_S_N <- sum(exp_S_N <= obs_S_N)

# Calculate the quantile based on the rank
quantile_value_S_N <- rank_obs_S_N / length(exp_S_N)
p_str_coRoost<- min(c(quantile_value_S_N,(1-quantile_value_S_N)))*2


# strength diurnal:
obs_S_D = Strength_DiurnalGroundInteractions$estimate
exp_S_D = RandCorrStrength_DiurnalGroundInteractions$rho

rank_obs_S_D <- sum(exp_S_D <= obs_S_D)

# Calculate the quantile based on the rank
quantile_value_S_D <- rank_obs_S_D / length(exp_S_D)
p_str_coFeed<- min(c(quantile_value_S_D,(1-quantile_value_S_D)))*2


########## PageRanks #####################
## PR flight
obs_PR_F = PageRank_CoFlight$estimate
exp_PR_F = RandCorrPageRank_CoFlight$rho

rank_obs_PR_F <- sum(exp_PR_F <= obs_PR_F)

# Calculate the quantile based on the rank
quantile_value_PR_F <- rank_obs_PR_F / length(exp_PR_F)
p_PR_coFly<- min(c(quantile_value_PR_F,(1-quantile_value_PR_F)))*2


# PR nocturnal
obs_PR_N = PageRank_NocturnalGroundInteractions$estimate
exp_PR_N = RandCorrPageRank_NocturnalGroundInteractions$rho

rank_obs_PR_N <- sum(exp_PR_N <= obs_PR_N)

# Calculate the quantile based on the rank
quantile_value_PR_N <- rank_obs_PR_N / length(exp_PR_N)
p_PR_coRoost<- min(c(quantile_value_PR_N,(1-quantile_value_PR_N)))*2

# PR diurnal
obs_PR_D = PageRank_DiurnalGroundInteractions$estimate
exp_PR_D = RandCorrPageRank_DiurnalGroundInteractions$rho

rank_obs_PR_D <- sum(exp_PR_D <= obs_PR_D)

# Calculate the quantile based on the rank
quantile_value_PR_D <- rank_obs_PR_D / length(exp_PR_D)
p_PR_coFeed<- min(c(quantile_value_PR_D,(1-quantile_value_PR_D)))*2

