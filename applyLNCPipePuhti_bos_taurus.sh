#run snakemake on the cluster
#
#$1 is target file

module load bioconda/3
source activate /projappl/project_2001289/FAANGlncRNA

snakemake -s applyLNCPipe.smk \
          -j 500 \
          --latency-wait 60 \
          --configfile /scratch/project_2001289/FAANG_lncRNA/pipeline/applyLNCPipe_config_puhti_bos_taurus.yaml \
          --cluster-config applyLNCPipe_puhti.yaml \
          --cluster "sbatch -t {cluster.time} --account={cluster.account} --job-name={cluster.job-name} --tasks-per-node={cluster.ntasks} --cpus-per-task={cluster.cpus-per-task} --mem-per-cpu={cluster.mem-per-cpu} -p {cluster.partition} -D {cluster.working-directory}" $1 
