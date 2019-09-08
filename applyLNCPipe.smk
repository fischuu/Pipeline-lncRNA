# vim: set filetype=sh :
import pandas as pd
from snakemake.utils import validate, min_version
##### set minimum snakemake version #####
#min_version("5.1.2")
#snakemake example: https://github.com/leipzig/snakemake-example/blob/master/Snakefile


##### load config and sample sheets #####

#configfile: "applyLNCPipe_config_taito.yaml"
#validate(config, schema="schemas/config.schema.yaml")

samples = pd.read_table(config["samples"], header=None)[0].tolist()

references = pd.read_table(config["ref"], delimiter='\s+', lineterminator='\n').set_index("species", drop=False)
#validate(references, schema="schemas/ref.schema.yaml")


##### run complete pipeline #####

rule all:
    input:
      # Prepare the data (download and index build)
      ####################################
      # The output from the SALMON part
      ####################################
#        expand("%s/%s/SALMON/{samples}/lib_format_counts.json" % (config["project-folder"], config["species"]), samples=samples),
      # The output from the FEELnc part
      ####################################
#        "%s/%s/FEELnc/classifier/feelnc_%s.classifier.txt" % (config["project-folder"], config["species"], config["species"]),
      # The quality checks
      ####################################
        expand("%s/%s/FASTQC/{samples}" % (config["project-folder"], config["species"]), samples=samples),
      # Quantification 
      ####################################
        expand("%s/%s/SALMON/{samples}/lib_format_counts.json" % (config["project-folder"], config["species"]), samples=samples),
        expand("%s/%s/SALMON/{samples}/logs/salmon_quant.log" % (config["project-folder"], config["species"]), samples=samples),
        expand("%s/%s/BAM/{samples}.bam" % (config["project-folder"], config["species"]), samples=samples),
        expand(directory("%s/%s/BAM/{samples}" % (config["project-folder"], config["species"])), samples=samples),
        expand("%s/%s/BAM/{samples}_spliced.bam" % (config["project-folder"], config["species"]), samples=samples),
        "%s/%s/GTF_merged/merged_STRG.gtf" % (config["project-folder"], config["species"]),
        expand("%s/%s/GTF/FEELnc_fc/lncRNA/{samples}_lncRNA_fc.txt" % (config["project-folder"], config["species"]), samples=samples),
        expand("%s/%s/GTF/Ref_fc/{samples}_ref_fc.txt" % (config["project-folder"], config["species"]), samples=samples),
        expand("%s/%s/GTF/Stringmerge_fc/{samples}_stringmerge_fc.txt" % (config["project-folder"], config["species"]), samples=samples),
        "%s/%s/GTF/Stringmerge_fc.csv" % (config["project-folder"], config["species"])
### setup report #####

report: "report/workflow.rst"


##### load rules #####

###include: "rules/downloadFASTQ_bash.smk"
###include: "rules/build_STARIndex_star.smk"
###include: "rules/compose_samples_bash.smk"
include: "rules/control_quality.smk"
include: "rules/cutadapt_trim_reads.smk"
include: "rules/remove_rRNA.smk"
include: "rules/build_salmonIndex_salmon.smk"
include: "rules/mapping_salmon.smk"
include: "rules/map_reads.smk"
### FILTER READS WITH LESS THAN 1Mio mapped reads
include: "rules/filter_splicedReads_totalRNA.smk"
include: "rules/assemble_transcripts.smk"
include: "rules/compose_merge.smk"
include: "rules/merge_samples.smk"
include: "rules/classify_lncrnas.smk"
include: "rules/featureCounts_quantify_FEELnc_out.smk"
### MERGE THE QUANTIFICATION
include: "rules/featureCounts_quantify_reference.smk"
### MERGE THE QUANTIFICATION
include: "rules/featureCounts_quantify_stringmerge.smk"
include: "rules/merge_fc_output_stringmerge.smk"
