# vim: set filetype=sh :

rule featureCounts_quantify_FEELnc_out:
    """
    Quantify the reads against FEELnc output regions (featureCounts).
    """
    input:
        bam="%s/%s/BAM/{samples}.bam" % (config["project-folder"], config["species"]),
        lncRNA="%s/%s/FEELnc/codpot/feelnc_%s.codpot.lncRNA.gtf" % (config["project-folder"], config["species"], config["species"]),
        mRNA="%s/%s/FEELnc/codpot/feelnc_%s.codpot.mRNA.gtf" % (config["project-folder"], config["species"], config["species"])
    output:
        lncRNA="%s/%s/GTF/FEELnc_fc/lncRNA/{samples}_lncRNA_fc.txt" % (config["project-folder"], config["species"]),
        mRNA="%s/%s/GTF/FEELnc_fc/mRNA/{samples}_mRNA_fc.txt" % (config["project-folder"], config["species"])
    log:
        "%s/%s/logs/featureCounts/featureCounts_FEELnc.{samples}.log" % (config["project-folder"], config["species"])
    benchmark:
        "%s/%s/benchmark/featureCounts/featureCounts_FEELnc.{samples}.benchmark.tsv" % (config["project-folder"], config["species"])
    threads: 12
    shell:"""
          featureCounts -p \
                        -T {threads} \
                        -a {input.lncRNA} \
                        -o {output.lncRNA} \
                        {input.bam} 2> {log}
  
          featureCounts -p \
                        -T {threads} \
                        -a {input.mRNA} \
                        -o {output.mRNA} \
                        {input.bam} 2> {log}
    """
