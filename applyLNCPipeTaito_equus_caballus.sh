#run snakemake on the cluster
#
#$1 is target file

module load bioconda/3
source activate FAANGlncRNA

snakemake -s applyLNCPipe.smk \
          -j 500 \
          --latency-wait 60 \
          --configfile /scratch/project_2001289/FAANG_lncRNA/pipeline/applyLNCPipe_config_taito_equus_caballus.yaml \
          --cluster-config applyLNCPipe_taito.yaml \
          --cluster "sbatch -t {cluster.time} --acount={cluster.account} --job-name={cluster.job-name} --tasks-per-node={cluster.ntasks} --cpus-per-task={cluster.cpus-per-task} --mem-per-cpu={cluster.mem-per-cpu} -p {cluster.partition} -D {cluster.working-directory}" $1 
