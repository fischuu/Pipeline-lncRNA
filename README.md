# Pipeline-FAANG-lncRNA

* get started with snakemake
https://snakemake.readthedocs.io/en/stable/index.html


* load snakemakemodule
module load anaconda3/1

* general configuration file: ./applyLNCPipe_config.yaml

* configuration file for cluster usage: ./applyLNCPipe_cluster.yaml

* main script: ./applyLNCPipe.smk

* all rules (pipelines steps) are defined in this folder: rules

* show which rules exist (help function)
snakemake -s applyLNCPipe.smk --list

* dry-run of the pipeline which will show you the schedule of executions w/o running them
* here: run without a specified target (output of a rule) runs the rule 'all' (entire pipeline)
snakemake -s applyLNCPipe.smk -np

* run of the pipeline with a specified target (output of a rule) runs all steps to reach the target
* here: target is stringtie merge output
snakemake -s applyLNCPipe.smk /home/projects/faang_cost/data/RNA-seq/bos_taurus/polyA/GTF_merged/merged_STRG.gtf

* run on the RTH cluster (using the configuration file for cluster usage)
* here: with target file (pipeline until stringtie merge)
bash applyLNCPipeCluster.smk /home/projects/faang_cost/data/RNA-seq/bos_taurus/polyA/GTF_merged/merged_STRG.gtf
 
* draw the directed acyclic graph (DAG) of jobs where the edges represent dependencies between the rules
snakemake -s applyLNCPipe.smk --dag | dot -Tpdf > dag.pdf

* create the report
snakemake -s applyLNCPipe.smk --report report.html

* Create the samples file with find or ls > samples
