# vim: set filetype=sh :
import pandas as pd
from snakemake.utils import validate, min_version
##### set minimum snakemake version #####
#min_version("5.1.2")
#snakemake example: https://github.com/leipzig/snakemake-example/blob/master/Snakefile


##### load config and sample sheets #####

configfile: "applyLNCPipe_config_taito.yaml"
validate(config, schema="schemas/config.schema.yaml")

samples = pd.read_table(config["samples"], header=None)[0].tolist()

references = pd.read_table(config["ref"]).set_index("species", drop=False)
validate(references, schema="schemas/ref.schema.yaml")


##### run complete pipeline #####

rule all:
    input:
        expand("%s/%s/SALMON/{samples}" % (config["project-folder"], config["species"]), samples=samples),
        "%s/%s/FEELnc/classifier/feelnc_%s.classifier.txt" % (config["project-folder"], config["species"], config["species"]),
        expand("%s/%s/FASTQC/{samples}" % (config["project-folder"], config["species"]), samples=samples)
       
rule allWOQC:
    input:
         "%s/%s/FEELnc/classifier/feelnc_%s.classifier.txt" % (config["project-folder"], config["species"], config["species"])
 
rule qc:
    input:
        expand("%s/%s/FASTQC/{samples}" % (config["project-folder"], config["species"]), samples=samples)

### setup report #####

report: "report/workflow.rst"


##### load rules #####

include: "rules/build_salmonIndex_salmon.smk"
include: "rules/control_quality.smk"
include: "rules/mapping_salmon.smk"
#include: "rules/extract_strandedness_info_bash.smk"
include: "rules/map_reads.smk"
include: "rules/assemble_transcripts.smk"
include: "rules/compose_merge.smk"
include: "rules/merge_samples.smk"
include: "rules/classify_lncrnas.smk"
#include: "rules/quantify_expression.smk"
