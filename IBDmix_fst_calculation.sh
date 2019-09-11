#!/bin/bash
#SBATCH --get-user-env
#SBATCH --mem=5G
#SBATCH --qos=1wk
#SBATCH --time=5-00:00:00
source ~/.bashrc

dir=/Genomics/akeylab/abwolf/NeanderthalSeq/IBDmix/FSTtest/

while read coord; do
    # Set True Haplotype Coordinates
    chr=$(echo $coord | cut -f 1 -d ' ')
    st=$(echo $coord | cut -f 2 -d ' ')
    ed=$(echo $coord | cut -f 3 -d ' ')

    # Pick out AFR_N and EUR_N samples
    cat /Genomics/akeylab/abwolf/NeanderthalSeq/IBDmix/Altai.2013.p_SingleArchaic.final_callset/Altai2013pub.1KGP3.LOD4.50K.filterAFRDeni.txt \
    | awk 'BEGIN {OFS="\t"} {if($1=='$chr' && $2>='$st' && $3<='$ed' && $8=="AFR") print $NF}' \
    | sort - | uniq - \
    > $dir/AFR_N.inds

    cat /Genomics/akeylab/abwolf/NeanderthalSeq/IBDmix/Altai.2013.p_SingleArchaic.final_callset/Altai2013pub.1KGP3.LOD4.50K.filterAFRDeni.txt \
    | awk 'BEGIN {OFS="\t"} {if($1=='$chr' && $2>='$st' && $3<='$ed' && $8=="EUR") print $NF}' \
    | sort - | uniq - \
    > $dir/EUR_N.inds

    # Pick out AFR_0 and EUR_0 samples
    comm ALL_AFR.inds AFR_N.inds \
    | cut -f 1 \
    | sort - | uniq - \
    | awk 'BEGIN {OFS="\t"} NR!=1 {print $0}' \
    > $dir/AFR_0.inds

    comm ALL_EUR.inds EUR_N.inds \
    | cut -f 1 \
    | sort - | uniq - \
    | awk 'BEGIN {OFS="\t"} NR!=1 {print $0}' \
    > $dir/EUR_0.inds

    # Set fst window coordinates
    winst=$(echo $coord | cut -f 4 -d ' ')
    wined=$(echo $coord | cut -f 5 -d ' ')

    if [ $winst -lt $wined ]; then
        echo $chr $winst $wined
        # wc -l $dir/AFR_N.inds
        # wc -l $dir/EUR_N.inds
        # vcftools --version
        # echo ''
        for i in N 0; do
            echo -n $chr $st $ed $winst $wined' ' >> AFR_"$i".EUR_"$i".results
            vcftools \
            --gzvcf /Genomics/grid/users/limingli/data/1kg-phase3/ALL.chr"$chr".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz \
            --chr $chr \
            --from-bp $winst \
            --to-bp $wined \
            --maf 0.05 \
            --weir-fst-pop AFR_"$i".inds \
            --weir-fst-pop EUR_"$i".inds \
            2>&1 >/dev/null \
            | grep mean | cut -f 7 -d ' ' >> $dir/AFR_"$i".EUR_"$i".results
        done
    else
        echo "WINST NOT LESS THAN WINED"
    fi

done < $dir/test.coord

echo FIN
