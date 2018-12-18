#run snakemake on the cluster
#
#$1 is target file

module load anaconda3/3

snakemake -s applyLNCPipe.smk \
          -j 800 \
          --latency-wait 60 \
          --cluster-config applyLNCPipe_taito.yaml \
          --cluster "sbatch -t {cluster.time} --job-name={cluster.job-name} --tasks-per-node={cluster.ntasks} --cpus-per-task={cluster.cpus-per-task} --mem-per-cpu={cluster.mem-per-cpu} -p {cluster.partition} -D {cluster.working-directory}" $1 
