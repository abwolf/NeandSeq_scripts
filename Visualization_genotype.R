#segment pick
which(propinfo$prop==0
[1]  35  92 113 114 126 151 197 199 310 315 337 338 374 403 422 423 479 502 512 553 574 577 589 657 664 668 722 724
> propinfo[35,]
chr     start       end seg_num prop het_der_ind derived_N
35   1 100340252 100375209      35    0           0        14
> propinfo[403,]
chr    start      end seg_num prop het_der_ind derived_N
403   7 43569703 43717088      13    0           0        63
> propinfo[577,]
chr     start       end seg_num prop het_der_ind derived_N
577  11 116506412 116574064      32    0           0        40
> propinfo[724,]
chr    start      end seg_num prop het_der_ind derived_N
724  18 73484095 73523543      22    0           0        46

which(propinfo$prop==0.00917431192660551)
[1] 575
> propinfo[575,]
chr     start       end seg_num        prop het_der_ind derived_N
575  11 102503926 102609332      30 0.009174312           1       109

> which(propinfo$prop==0.0714285714285714)
[1] 407
> propinfo[407,]
chr    start      end seg_num       prop het_der_ind derived_N
407   7 46936529 46975314      17 0.07142857           2        28

> which(propinfo$prop==0.111111111111111)
[1] 248 570
> propinfo[248,]
chr     start       end seg_num      prop het_der_ind derived_N
248   4 130452370 130482448      41 0.1111111           3        27


> which(propinfo$prop==0.25)
[1]  28  33  37 228 286 534 566 750
> propinfo[37,]
chr     start       end seg_num prop het_der_ind derived_N
37   1 102229261 102272312      37 0.25           6        24
> propinfo[286,]
chr    start      end seg_num prop het_der_ind derived_N
286   5 89997539 90028405      20 0.25           3        12

> which(propinfo$prop==0.4)
[1]  45  96 108 171 271 558 686 689
> propinfo[96,]
chr    start      end seg_num prop het_der_ind derived_N
96   2 66912954 66958581      19  0.4           2         5
> propinfo[171,]
chr    start      end seg_num prop het_der_ind derived_N
171   3 29336908 29414861      22  0.4          28        70
> propinfo[686,]
chr    start      end seg_num prop het_der_ind derived_N
686  16 56668558 56716797       4  0.4           4        10

> which(propinfo$prop==0.5)
[1]  26 119 229 325 417 466 471 510 520 541 543 548 576 629 636 703 711 713 728 733
> propinfo[119,]
chr     start       end seg_num prop het_der_ind derived_N
119   2 140002866 140165231      43  0.5          42        84
> propinfo[466,]
chr     start       end seg_num prop het_der_ind derived_N
466   8 133235848 133293797      36  0.5          24        48
> propinfo[520,]
chr    start      end seg_num prop het_der_ind derived_N
520  10 63637318 63695170      20  0.5          11        22
> propinfo[711,]
chr    start      end seg_num prop het_der_ind derived_N
711  18 45735596 45819148       9  0.5          20        40


#derived allele converting
chr_num <- 18
seg_num <- 9
AAfile <- read.table(file=paste("seg", seg_num, ".chr", chr_num, ".AA.txt", sep=""), header=F, sep="\t",stringsAsFactors = F,col.names = c("chr","pos","ref","alt","AncestralAllele"))

A.Allele <- as.character(sapply(1:nrow(AAfile), function(x){
  A.Allele <-unlist(strsplit(AAfile$AncestralAllele[x],""))[1] 
  return(A.Allele)
}))
AAfile <- cbind(AAfile, A.Allele)
genoprev <- read.table(file=paste("seg", seg_num, ".chr", chr_num, ".genoprev", sep=""), header=F, sep="\t", stringsAsFactors = F, col.names=c("chr", "pos", "ref","alt","altai","ind"))
toreplace <- which(genoprev$pos %in% AAfile$pos)

recoded.geno <- as.data.frame(t(sapply(toreplace, function(x){
  oldline <- unlist(genoprev[x,])
  newline <- oldline
  A.Allele <- AAfile[AAfile$pos==oldline["pos"],"A.Allele"]
  #AncestralAllele <- unlist(strsplit(as.character(Ancinfo.30peak[Ancinfo.30peak$pos==oldline[["pos"]],"AncestralAllele"]),""))[1]
  if(A.Allele==oldline["ref"]) {
    return(newline)
  } else if(A.Allele==oldline["alt"]) {
    if(length(which(oldline==0))!=0) {
      newline[which(oldline==0)] <- 2
    } 
    if(length(which(oldline==2))!=0) {
      newline[which(oldline==2)] <- 0
    }
    return(newline)
  }
  else {
    outlier<-rep(NA,6)
    names(outlier)<-c("chr","pos","ref","alt","altai","ind")
    return(outlier)
  }
})))

recoded.geno <- na.omit(recoded.geno)
recoded.geno$altai <- as.numeric(levels(recoded.geno$altai))[recoded.geno$altai]
recoded.geno$ind <- as.numeric(levels(recoded.geno$ind))[recoded.geno$ind]
recoded.geno$pos <- as.numeric(levels(recoded.geno$pos))[recoded.geno$pos]
recoded.geno$chr <- as.numeric(levels(recoded.geno$chr))[recoded.geno$chr]
#recoded.geno$ref <- as.numeric(levels(recoded.geno$ref))[recoded.geno$ref]
#recoded.geno$alt <- as.numeric(levels(recoded.geno$alt))[recoded.geno$alt]

#genotype visualizing
colorvec <- c("white", "green4", "blue2")
plot(NA, xlim=c(45735596,45819148), ylim=c(0,3), xlab="", ylab="")
title("prop5_count20_chr18_20_40")
invisible(sapply(1:nrow(recoded.geno), function(x) { points(rep(recoded.geno[x,2],2),1:2, col=colorvec[unlist(recoded.geno[x,5:6])+1], pch=15, cex=2) }))