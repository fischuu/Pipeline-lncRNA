#run snakemake on the cluster
#
#$1 is target file

module use $HOME/modulefiles
module load anaconda3

module load bioconda/3
source activate FAANGlncRNA

snakemake -s applyLNCPipe.smk \
          -j 500 \
          --latency-wait 60 \
          --configfile /proj/project_2000968/FAANG_lncRNA/pipeline/applyLNCPipe_config_taito_ovis_aries.yaml \
          --cluster-config applyLNCPipe_taito.yaml \
          --cluster "sbatch -t {cluster.time} --job-name={cluster.job-name} --tasks-per-node={cluster.ntasks} --cpus-per-task={cluster.cpus-per-task} --mem-per-cpu={cluster.mem-per-cpu} -p {cluster.partition} -D {cluster.working-directory}" $1 
