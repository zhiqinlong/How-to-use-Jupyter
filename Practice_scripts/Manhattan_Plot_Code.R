
setwd("/Users/zhiqinlong/Downloads")  # Set this to where you saved your xxx.ps file
#Set dir
#Load packages
suppressMessages(library(data.table))
suppressMessages(library(tidyverse))
suppressMessages(library(ggplot2))
#####################
# Part 2 : Load EMMAX (GWAS) results
#####################

a <- fread("EMMAX_output_SNP_20251017.ps", header =F)
colnames(a)[1] <- "SNP"
colnames(a)[4] <- "P"
dim(a)

a2 <- a[ ,c(1,4)]

#SNP use this
a3 <- a2 %>% separate(SNP,into = c("CHR","BP"), sep = ":" , remove = F)
a3[,3] <- as.numeric(unlist(a3[,3])) #use UNLIST!!

rm(a2)

#####################
# Part 3 : Set thershold
#####################
#I used 9249 SNPs, threshold is even bigger!
ben_threshold <- -log10(0.1/9249); ben_threshold
ben_threshold.5 <- -log10(0.05/9249); ben_threshold.5

#####################
# Part 4 : Calculate cumulated genomic position (for X axis)
#####################

gwasResults <- a3

#Position of the Chr
don <- gwasResults %>%
  
  # Compute chromosome size
  group_by(CHR) %>%
  summarise(chr_len=max(BP)) %>%
  
  # Calculate cumulative position of each chromosome
  mutate(tot=cumsum(chr_len)-chr_len) %>%
  select(-chr_len) %>%
  
  # Add this info to the initial dataset
  left_join(gwasResults, ., by=c("CHR"="CHR")) %>%
  
  # Add a cumulative position of each SNP
  arrange(CHR, BP) %>%
  mutate( BPcum=BP+tot)

#####################
# Part 5 : Define X axis
#####################

axisdf = don %>% group_by(CHR) %>% summarize(center=( max(BPcum) + min(BPcum) ) / 2 )
X_axis <- gsub("Ha412HOChr","", axisdf$CHR)

#####################
# Part 6 : P -> Log10(P)
#####################

don$logP <- (-log10(don$P))
#####################
# Part 7 : Plotting!
#####################

ggplot(don,aes(x=BPcum, y=-log10(P))) +
  geom_point(aes(color=as.factor(CHR)), alpha=0.8, size= 1) +
  scale_color_manual(values = rep(c("grey", "black"), 22 )) +
  geom_hline(yintercept=as.numeric(ben_threshold.5), linetype="dashed",color = "red", size=0.8) +
  geom_hline(yintercept=as.numeric(ben_threshold), linetype="dashed",color = "blue", size=0.8) +
  # custom X axis:
  scale_x_continuous( label = X_axis, breaks= axisdf$center ) +
  
  # Custom the theme:
  theme_bw() +
  theme(
    legend.position="none",
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    strip.background = element_blank()
  )+
  labs(
    y = "-log10 P-Value",
    x = "SNP_Position")


#####################
# Part 8 : Extract top 10 above the thershold -> SAVE
#####################

don2 <- don[order(don$logP,decreasing = T),]
don_top10 <- don2[1:10,]
