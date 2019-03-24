# vim: set filetype=sh :

rule featureCounts_quantify_reference:
    """
    Quantify the reads against FEELnc output regions (featureCounts).
    """
    input:
        bam="%s/%s/BAM/{samples}.bam" % (config["project-folder"], config["species"]),
        gtf=references.loc[config["species"],"annot"]
    output:
        "%s/%s/GTF/Ref_fc/{samples}_ref_fc.txt" % (config["project-folder"], config["species"])
    log:
        "%s/%s/logs/featureCounts/featureCounts_ref.{samples}.log" % (config["project-folder"], config["species"])
    benchmark:
        "%s/%s/benchmark/featureCounts/featureCounts_ref.{samples}.benchmark.tsv" % (config["project-folder"], config["species"])
    threads: 12
    shell:"""
          featureCounts -p \
                        -T {threads} \
                        -a {input.gtf} \
                        -o {output} \
                        {input.bam} 2> {log}
    """
