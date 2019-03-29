
Altai_v1=$1
Altai_v2=$2

echo $Altai_v1      $Altai_v2

for pop in YRIcall YRIcall.30kb YRIcall.50kb EURcall EURcall.30kb EURcall.50kb ; do
	echo $pop
	echo 'fraction-map  NR ct ct/NR tot_afr sum_bp diff_bp sum_bp/tot_bp, diff_bp/tot_bp'

    bedmap --ec --delim '\t' --echo --bases --fraction-map 0.001 --indicator "$Altai_v1"/"$pop".bed.merged "$Altai_v2"/"$pop".bed.merged \
	| awk 'BEGIN {OFS="\t"} { if($NF==1) { sum_bp+=($3-$2) ;  ct+=1 ;  diff_bp+=$(NF-1) } ; tot_afr+=($3-$2)}
		END {print "'$pop' '$Altai_v1'|'$Altai_v2': " \
            NR, ct, ct/NR, tot_afr, sum_bp, diff_bp, sum_bp/tot_afr, diff_bp/tot_afr}'

    bedmap --ec --delim '\t' --echo --bases --fraction-map 0.001 --indicator "$Altai_v1"/"$pop".bed "$Altai_v2"/"$pop".bed.merged \
	| awk 'BEGIN {OFS="\t"} { if($NF==1) { sum_bp+=($3-$2) ;  ct+=1 ;  diff_bp+=$(NF-1) } ; tot_afr+=($3-$2)}
		END {print "'$pop' '$Altai_v1'|'$Altai_v2': " \
            NR, ct, ct/NR, tot_afr, sum_bp, diff_bp, sum_bp/tot_afr, diff_bp/tot_afr}'
#####
#####
    bedmap --ec --delim '\t' --echo --bases --fraction-map 0.001 --indicator "$Altai_v2"/"$pop".bed.merged "$Altai_v1"/"$pop".bed.merged \
	| awk 'BEGIN {OFS="\t"} { if($NF==1) { sum_bp+=($3-$2) ;  ct+=1 ;  diff_bp+=$(NF-1) } ; tot_afr+=($3-$2)}
		END {print "'$pop' '$Altai_v2'|'$Altai_v1': " \
            NR, ct, ct/NR, tot_afr, sum_bp, diff_bp, sum_bp/tot_afr, diff_bp/tot_afr}'

    bedmap --ec --delim '\t' --echo --bases --fraction-map 0.001 --indicator "$Altai_v2"/"$pop".bed "$Altai_v1"/"$pop".bed.merged \
	| awk 'BEGIN {OFS="\t"} { if($NF==1) { sum_bp+=($3-$2) ;  ct+=1 ;  diff_bp+=$(NF-1) } ; tot_afr+=($3-$2)}
		END {print "'$pop' '$Altai_v2'|'$Altai_v1': " \
            NR, ct, ct/NR, tot_afr, sum_bp, diff_bp, sum_bp/tot_afr, diff_bp/tot_afr}'
#####
#####





	echo ''
done
