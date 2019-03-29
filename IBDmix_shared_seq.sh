#for i in 0.001 0.01 0.05 0.1 0.2; do
i=0.001

for Altai in Altai.2013.p_SingleArchaic Altai.2016.p_SingleArchaic Vindija.2016.p_SingleArchaic ; do
    echo $Altai
	echo 'fraction-map  NR ct ct/NR tot_afr sum_bp diff_bp sum_bp/tot_bp, diff_bp/tot_bp'

    bedmap --ec --delim '\t' --echo --bases --fraction-map $i --indicator $Altai/YRIcall.50kb.bed.merged $Altai/EUR_EAS_SAS_AMR_call.50kb.bed.merged \
	| awk 'BEGIN {OFS="\t"} { if($NF==1) { sum_bp+=($3-$2) ;  ct+=1 ;  diff_bp+=$(NF-1) } ; tot_afr+=($3-$2)}
		END {print "'$i' AFR.merged|nonAfr.merged: " NR, ct, ct/NR, tot_afr, sum_bp, diff_bp, sum_bp/tot_afr, diff_bp/tot_afr}'
	bedmap --ec --delim '\t' --echo --bases --fraction-map $i --indicator $Altai/YRIcall.50kb.bed $Altai/EUR_EAS_SAS_AMR_call.50kb.bed.merged \
	| awk 'BEGIN {OFS="\t"} { if($NF==1) { sum_bp+=($3-$2) ;  ct+=1 ;  diff_bp+=$(NF-1) } ; tot_afr+=($3-$2)}
		END {print "'$i' AFR.unmerged|nonAfr.merged: " NR, ct, ct/NR, tot_afr, sum_bp, diff_bp, sum_bp/tot_afr, diff_bp/tot_afr}'

    bedmap --ec --delim '\t' --echo --bases-uniq --fraction-map $i --indicator $Altai/YRIcall.50kb.bed.merged $Altai/EUR_EAS_SAS_AMR_call.50kb.bed \
        | awk 'BEGIN {OFS="\t"} { if($NF==1) { sum_bp+=($3-$2) ;  ct+=1 ;  diff_bp+=$(NF-1) } ; tot_afr+=($3-$2)}
                END {print "'$i' AFR.merged|nonAfr.unmerged: " NR, ct, ct/NR, tot_afr, sum_bp, diff_bp, sum_bp/tot_afr, diff_bp/tot_afr}'
    bedmap --ec --delim '\t' --echo --bases-uniq --fraction-map $i --indicator $Altai/YRIcall.50kb.bed $Altai/EUR_EAS_SAS_AMR_call.50kb.bed \
        | awk 'BEGIN {OFS="\t"} { if($NF==1) { sum_bp+=($3-$2) ;  ct+=1 ;  diff_bp+=$(NF-1) } ; tot_afr+=($3-$2)}
                END {print "'$i' AFR.unmerged|nonAfr.unmerged: " NR, ct, ct/NR, tot_afr, sum_bp, diff_bp, sum_bp/tot_afr, diff_bp/tot_afr}'

        # bedmap --ec --delim '\t' --echo --bases --fraction-map $i --indicator ./YRIcall.bed.merged ./EURcall.bed.merged \
        # | awk 'BEGIN {OFS="\t"} { if($NF==1) { sum_bp+=($3-$2) ;  ct+=1 ;  diff_bp+=$(NF-1) } ; tot_afr+=($3-$2)}
        #         END {print "'$i' AFR.merged|EUR.merged: " NR, ct, ct/NR, tot_afr, sum_bp, diff_bp, sum_bp/tot_afr, diff_bp/tot_afr}'
        # bedmap --ec --delim '\t' --echo --bases --fraction-map $i --indicator ./YRIcall.bed ./EURcall.bed.merged \
        # | awk 'BEGIN {OFS="\t"} { if($NF==1) { sum_bp+=($3-$2) ;  ct+=1 ;  diff_bp+=$(NF-1) } ; tot_afr+=($3-$2)}
        #         END {print "'$i' AFR.unmerged|EUR.merged: " NR, ct, ct/NR, tot_afr, sum_bp, diff_bp, sum_bp/tot_afr, diff_bp/tot_afr}'
        #
        # bedmap --ec --delim '\t' --echo --bases --fraction-map $i --indicator ./YRIcall.bed.merged ./EAScall.bed.merged \
        # | awk 'BEGIN {OFS="\t"} { if($NF==1) { sum_bp+=($3-$2) ;  ct+=1 ;  diff_bp+=$(NF-1) } ; tot_afr+=($3-$2)}
        #         END {print "'$i' AFR.merged|EAS.merged: " NR, ct, ct/NR, tot_afr, sum_bp, diff_bp, sum_bp/tot_afr, diff_bp/tot_afr}'
        # bedmap --ec --delim '\t' --echo --bases --fraction-map $i --indicator ./YRIcall.bed ./EAScall.bed.merged \
        # | awk 'BEGIN {OFS="\t"} { if($NF==1) { sum_bp+=($3-$2) ;  ct+=1 ;  diff_bp+=$(NF-1) } ; tot_afr+=($3-$2)}
        #         END {print "'$i' AFR.unmerged|EAS.merged: " NR, ct, ct/NR, tot_afr, sum_bp, diff_bp, sum_bp/tot_afr, diff_bp/tot_afr}'
        #
        # bedmap --ec --delim '\t' --echo --bases --fraction-map $i --indicator ./YRIcall.bed.merged ./EUR_EAScall.bed.merged \
        # | awk 'BEGIN {OFS="\t"} { if($NF==1) { sum_bp+=($3-$2) ;  ct+=1 ;  diff_bp+=$(NF-1) } ; tot_afr+=($3-$2)}
        #         END {print "'$i' AFR.merged|EUR_EAS.merged: " NR, ct, ct/NR, tot_afr, sum_bp, diff_bp, sum_bp/tot_afr, diff_bp/tot_afr}'
        # bedmap --ec --delim '\t' --echo --bases --fraction-map $i --indicator ./YRIcall.bed ./EUR_EAScall.bed.merged \
        # | awk 'BEGIN {OFS="\t"} { if($NF==1) { sum_bp+=($3-$2) ;  ct+=1 ;  diff_bp+=$(NF-1) } ; tot_afr+=($3-$2)}
        #         END {print "'$i' AFR.unmerged|EUR_EAS.merged: " NR, ct, ct/NR, tot_afr, sum_bp, diff_bp, sum_bp/tot_afr, diff_bp/tot_afr}'

        bedmap --ec --delim '\t' --echo --bases --fraction-map $i --indicator $Altai/EURcall.50kb.bed.merged $Altai/EAScall.50kb.bed.merged \
        | awk 'BEGIN {OFS="\t"} { if($NF==1) { sum_bp+=($3-$2) ;  ct+=1 ;  diff_bp+=$(NF-1) } ; tot_afr+=($3-$2)}
                END {print "'$i' EUR.merged|EAS.merged: " NR, ct, ct/NR, tot_afr, sum_bp, diff_bp, sum_bp/tot_afr, diff_bp/tot_afr}'
        bedmap --ec --delim '\t' --echo --bases --fraction-map $i --indicator $Altai/EURcall.50kb.bed $Altai/EAScall.50kb.bed.merged \
        | awk 'BEGIN {OFS="\t"} { if($NF==1) { sum_bp+=($3-$2) ;  ct+=1 ;  diff_bp+=$(NF-1) } ; tot_afr+=($3-$2)}
                END {print "'$i' EUR.unmerged|EAS.merged: " NR, ct, ct/NR, tot_afr, sum_bp, diff_bp, sum_bp/tot_afr, diff_bp/tot_afr}'

        bedmap --ec --delim '\t' --echo --bases --fraction-map $i --indicator $Altai/EAScall.50kb.bed.merged $Altai/EURcall.50kb.bed.merged \
        | awk 'BEGIN {OFS="\t"} { if($NF==1) { sum_bp+=($3-$2) ;  ct+=1 ;  diff_bp+=$(NF-1) } ; tot_afr+=($3-$2)}
                END {print "'$i' EAS.merged|EUR.merged: " NR, ct, ct/NR, tot_afr, sum_bp, diff_bp, sum_bp/tot_afr, diff_bp/tot_afr}'
        bedmap --ec --delim '\t' --echo --bases --fraction-map $i --indicator $Altai/EAScall.50kb.bed $Altai/EURcall.50kb.bed.merged \
        | awk 'BEGIN {OFS="\t"} { if($NF==1) { sum_bp+=($3-$2) ;  ct+=1 ;  diff_bp+=$(NF-1) } ; tot_afr+=($3-$2)}
                END {print "'$i' EAS.unmerged|EUR.merged: " NR, ct, ct/NR, tot_afr, sum_bp, diff_bp, sum_bp/tot_afr, diff_bp/tot_afr}'

	echo ''
done
