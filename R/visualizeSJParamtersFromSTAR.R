library(data.table)
sjFiles <- list.files("/media/ejo138/Fantec6/Projects/FAANG-lncRNA/bos_taurus/BAM/",
                      recursive = TRUE, pattern="*.out.tab", full.names=TRUE)

sampleIDs <- gsub("_SJ.out.tab","",sapply(strsplit(sjFiles, ".*/"),"[",2))

plotSJ <- function(name, filenames){
  curSample <- grep(name, filenames)
  
  data <- fread(filenames[curSample])
  
  sj <- c(data$V7[data$V7<20])
  oldnew <- c(data$V6[data$V7<20])
  
  par(mfrow=c(2,1), mar=c(1,2,1,0))
  barplot(cumsum(table(sj[oldnew==0])), main=name)
  barplot(cumsum(table(sj[oldnew==1])))
  
}

polyAsmall <- c("SRR4408944",
                "SRR4408924",
                "SRR4408916",
                "SRR4408973")

plotSJ(polyAsmall[1], sjFiles)

PolyA, big lib size

SRR4409006   15519978
SRR3081200  140612484

Total

SRR2226646   8124355
SRR3176235   56428451

plotSJ(sampleIDs[2], sjFiles)

# pdf(file="/home/ejo138/ownCloud/sjHists.pdf", width=8, height=8)
# for(i in sampleIDs){
#   plotSJ(i, sjFiles)  
# }
# dev.off()
# 
# 
# 
sj <- list()

sj[[1]] <- fread(sjFiles[1])
overlap <- c(sj[[1]]$V7[sj[[1]]$V7<100])
oldnew <- c(sj[[1]]$V6[sj[[1]]$V7<100])

for(i in 2:length(sjFiles)){
  sj[[i]] <- fread(sjFiles[i])
  overlap <- c(overlap, sj[[i]]$V7[sj[[i]]$V7<100])
  oldnew <- c(oldnew, sj[[i]]$V6[sj[[i]]$V7<100])
}
pdf(file="/home/ejo138/ownCloud/sjHists-combined.pdf", width=8, height=8)
barplot(cumsum(table(overlap)))
dev.off()
# 
# par(mfrow=c(2,1))
# #barplot(table(overlap), main="All")
 barplot(cumsum(table(overlap[oldnew==0])), main="class=0 (novel")
 barplot(cumsum(table(overlap[oldnew==1])), main="class=1 (annot)")
