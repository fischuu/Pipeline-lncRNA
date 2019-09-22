# vim: set filetype=sh :

rule classify_ncrna_feelnc:
    """
    Predict lncRNA (FEELnc).
    """
    input:
        candidates="%s/%s/GTF_merged/merged_STRG.gtf" % (config["project-folder"], config["species"]),
        annotation=references.loc[config["species"],"annot"],
        genome=references.loc[config["species"],"genome"]
    output:
        txt="%s/%s/FEELnc/classifier/feelnc_%s.classifier.txt" % (config["project-folder"], config["species"], config["species"]),
        lncRNA="%s/%s/FEELnc/codpot/feelnc_%s.codpot.lncRNA.gtf" % (config["project-folder"], config["species"], config["species"]),
        mRNA="%s/%s/FEELnc/codpot/feelnc_%s.codpot.mRNA.gtf" % (config["project-folder"], config["species"], config["species"])
    params:
        name="feelnc_%s" % config["species"],
        dir="%s/%s/FEELnc" % (config["project-folder"], config["species"])
    log:
        "%s/%s/logs/FEELnc/feelnc.log" % (config["project-folder"], config["species"])
    benchmark:
        "%s/%s/benchmark/feelnc.benchmark.tsv" % (config["project-folder"], config["species"])
    threads: 16
    shell:"""
        scripts/run_feelnc.sh {input.candidates} {input.annotation} {input.genome} {params.dir} {params.name} &> {log}
    """
