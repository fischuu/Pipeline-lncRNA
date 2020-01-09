# vim: set filetype=sh :

rule classify_ncrna_feelnc_01_filter:
    """
    Filter input for lncRNA (FEELnc).
    """
    input:
        candidates="%s/%s/GTF_merged/merged_STRG.gtf" % (config["project-folder"], config["species"]),
        annotation=references.loc[config["species"],"annot"],
        genome=references.loc[config["species"],"genome"]
    output:
        "%s/%s/FEELnc/filter/feelnc_%s.filter.gtf" % (config["project-folder"], config["species"], config["species"])
    params:
        name="feelnc_%s" % config["species"],
        dir="%s/%s/FEELnc" % (config["project-folder"], config["species"])
    log:
        "%s/%s/logs/FEELnc/feelnc_01.log" % (config["project-folder"], config["species"])
    benchmark:
        "%s/%s/benchmark/feelnc_01.benchmark.tsv" % (config["project-folder"], config["species"])
    threads: 12
    shell:"""
        scripts/run_feelnc_01_filter.sh {input.candidates} {input.annotation} {input.genome} {params.dir} {params.name} &> {log}
    """
