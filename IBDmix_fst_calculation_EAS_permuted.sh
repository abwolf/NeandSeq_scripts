#!/bin/bash
#SBATCH --get-user-env
#SBATCH --mem=2G
#SBATCH --qos=1wk
#SBATCH --time=5-00:00:00
source ~/.bashrc

dir=/Genomics/akeylab/abwolf/NeanderthalSeq/IBDmix/FSTtest/

while read coord; do
    # Set True Haplotype Coordinates
    chr=$(echo $coord | cut -f 1 -d ' ')
    st=$(echo $coord | cut -f 2 -d ' ')
    ed=$(echo $coord | cut -f 3 -d ' ')

    # Pick out AFR_N and EAS_N samples
    AFR_N_count=$( cat /Genomics/akeylab/abwolf/NeanderthalSeq/IBDmix/Altai.2013.p_SingleArchaic.final_callset/Altai2013pub.1KGP3.LOD4.50K.filterAFRDeni.txt \
    | awk 'BEGIN {OFS="\t"} {if($1=='$chr' && $2>='$st' && $3<='$ed' && $8=="AFR") print $NF}' \
    | sort - | uniq - \
    | wc -l )

    EAS_N_count=$( cat /Genomics/akeylab/abwolf/NeanderthalSeq/IBDmix/Altai.2013.p_SingleArchaic.final_callset/Altai2013pub.1KGP3.LOD4.50K.filterAFRDeni.txt \
    | awk 'BEGIN {OFS="\t"} {if($1=='$chr' && $2>='$st' && $3<='$ed' && $8=="EAS") print $NF}' \
    | sort - | uniq - \
    | wc -l )

    # Randomly pick out the appropriate number of EAS/AFR samples to be reassigned as carrier/non-carrier
    shuf -n $AFR_N_count ALL_AFR.inds | sort - \
    > $dir/AFR_N.inds.${SLURM_ARRAY_TASK_ID}

    shuf -n $EAS_N_count ALL_EAS.inds | sort - \
    > $dir/EAS_N.inds.${SLURM_ARRAY_TASK_ID}

    # Pick out AFR_0 and EAS_0 samples
    comm ALL_AFR.inds AFR_N.inds.${SLURM_ARRAY_TASK_ID} \
    | cut -f 1 \
    | sort - | uniq - \
    | awk 'BEGIN {OFS="\t"} NR!=1 {print $0}' \
    > $dir/AFR_0.inds.${SLURM_ARRAY_TASK_ID}

    comm ALL_EAS.inds EAS_N.inds.${SLURM_ARRAY_TASK_ID} \
    | cut -f 1 \
    | sort - | uniq - \
    | awk 'BEGIN {OFS="\t"} NR!=1 {print $0}' \
    > $dir/EAS_0.inds.${SLURM_ARRAY_TASK_ID}

    # Set fst window coordinates
    winst=$(echo $coord | cut -f 4 -d ' ')
    wined=$(echo $coord | cut -f 5 -d ' ')


    # # Add additional space to the window for NULL data
    # if [ $winst -lt $st ]; then
    #     echo $winst $wined
    #     winst=$(($winst - 50000))
    #     wined=$(($winst + 10000))
    #     echo $winst $wined "SUBTRACTED 40K"
    # elif [ $winst -gt $st ]; then
    #     echo $winst $wined
    #     winst=$(($winst + 50000))
    #     wined=$(($winst + 10000))
    #     echo $winst $wined "ADDED 40K"
    # fi



    if [ $winst -lt $wined ]; then
        echo $chr $winst $wined

        for i in N 0; do
            echo -n $chr $st $ed $winst $wined' ' >> $dir/AFR_"$i".EAS_"$i".results.perm.${SLURM_ARRAY_TASK_ID}
            vcftools \
            --gzvcf /Genomics/grid/users/limingli/data/1kg-phase3/ALL.chr"$chr".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz \
            --chr $chr \
            --from-bp $winst \
            --to-bp $wined \
            --maf 0.05 \
            --out ${SLURM_ARRAY_TASK_ID} \
            --weir-fst-pop AFR_"$i".inds.${SLURM_ARRAY_TASK_ID} \
            --weir-fst-pop EAS_"$i".inds.${SLURM_ARRAY_TASK_ID} \
            2>&1 >/dev/null \
            | grep mean | cut -f 7 -d ' ' >> $dir/AFR_"$i".EAS_"$i".results.perm.${SLURM_ARRAY_TASK_ID}
        done
    else
        echo "WINST NOT LESS THAN WINED"
    fi


done < $dir/EAS_AFR.test.coord

echo FIN
