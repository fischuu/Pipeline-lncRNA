# vim: set filetype=sh :

rule classify_ncrna_feelnc_02_codingpot:
    """
    lncRNA coding potential (FEELnc).
    """
    input:
        candidates="%s/%s/GTF_merged/merged_STRG.gtf" % (config["project-folder"], config["species"]),
        annotation=references.loc[config["species"],"annot"],
        genome=references.loc[config["species"],"genome"],
        filter="%s/%s/FEELnc/filter/feelnc_%s.filter.gtf" % (config["project-folder"], config["species"], config["species"])
    output:
        lncRNA="%s/%s/FEELnc/codpot/feelnc_%s.codpot.lncRNA.gtf" % (config["project-folder"], config["species"], config["species"]),
        mRNA="%s/%s/FEELnc/codpot/feelnc_%s.codpot.mRNA.gtf" % (config["project-folder"], config["species"], config["species"])
    params:
        name="feelnc_%s" % config["species"],
        dir="%s/%s/FEELnc" % (config["project-folder"], config["species"])
    log:
        "%s/%s/logs/FEELnc/feelnc_02.log" % (config["project-folder"], config["species"])
    benchmark:
        "%s/%s/benchmark/feelnc_02.benchmark.tsv" % (config["project-folder"], config["species"])
    threads: 12
    shell:"""
        scripts/run_feelnc_02_codingpot.sh {input.candidates} {input.annotation} {input.genome} {params.dir} {params.name} &> {log}
    """
