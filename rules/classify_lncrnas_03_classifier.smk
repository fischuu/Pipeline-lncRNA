# vim: set filetype=sh :

rule classify_ncrna_feelnc_03_classifier:
    """
    Classify lncRNA (FEELnc).
    """
    input:
        annotation=references.loc[config["species"],"annot"],
        lncRNA="%s/%s/FEELnc/codpot/feelnc_%s.codpot.lncRNA.gtf" % (config["project-folder"], config["species"], config["species"])
    output:
        "%s/%s/FEELnc/classifier/feelnc_%s.classifier.txt" % (config["project-folder"], config["species"], config["species"])
    log:
        "%s/%s/logs/FEELnc/feelnc_03.log" % (config["project-folder"], config["species"])
    benchmark:
        "%s/%s/benchmark/feelnc_03.benchmark.tsv" % (config["project-folder"], config["species"])
    threads: 12
    shell:"""
        FEELnc_classifier.pl --lncrna={input.lncRNA} --mrna {input.annotation} > {output} 2> {log}
    """
