# vim: set filetype=sh :

rule featureCounts_quantify_stringmerge:
    """
    Quantify the reads against stringmerge output (featureCounts).
    """
    input:
        bam="%s/%s/BAM/{samples}.bam" % (config["project-folder"], config["species"]),
        gtf="%s/%s/GTF_merged/merged_STRG.gtf" % (config["project-folder"], config["species"])
    output:
        "%s/%s/GTF/Stringmerge_fc/{samples}_stringmerge_fc.txt" % (config["project-folder"], config["species"])
    log:
        "%s/%s/logs/featureCounts/featureCounts_sm.{samples}.log" % (config["project-folder"], config["species"])
    benchmark:
        "%s/%s/benchmark/featureCounts/featureCounts_sm.{samples}.benchmark.tsv" % (config["project-folder"], config["species"])
    threads: 12
    shell:"""
          featureCounts -p \
                        -T {threads} \
                        -a {input.gtf} \
                        -o {output} \
                        {input.bam} 2> {log}
    """
