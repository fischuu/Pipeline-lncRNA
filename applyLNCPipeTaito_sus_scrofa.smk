#run snakemake on the cluster
#
#$1 is target file

module use $HOME/modulefiles
module load anaconda3

snakemake -s applyLNCPipe.smk \
          -j 500 \
          --latency-wait 60 \
          --configfile /proj/project_2000921/FAANG-lncRNA/pipeline/apply-Ruminomics-Papillae-Pipe_config_taito_cowtest_umd.yaml \
          --cluster-config applyLNCPipe_taito_sus_scrofa.yaml \
          --cluster "sbatch -t {cluster.time} --job-name={cluster.job-name} --tasks-per-node={cluster.ntasks} --cpus-per-task={cluster.cpus-per-task} --mem-per-cpu={cluster.mem-per-cpu} -p {cluster.partition} -D {cluster.working-directory}" $1 
