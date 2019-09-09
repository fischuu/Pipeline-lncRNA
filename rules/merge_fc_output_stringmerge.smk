# vim: set filetype=sh :

rule merge_fc_output_stringmerge:
    """
    Merge fc output (Panda).
    """
    params:
        smDir=directory("%s/%s/GTF/Stringmerge_fc/" % (config["project-folder"], config["species"]))
    output:
        "%s/%s/GTF/Stringmerge_fc.csv" % (config["project-folder"], config["species"])
    log:
        "%s/%s/logs/merge_fc.log" % (config["project-folder"], config["species"])
    benchmark:
        "%s/%s/benchmark/merge_fc.benchmark.tsv" % (config["project-folder"], config["species"])
    shell:"""
        scripts/merge_fc.py -f {params.smDir} -o {output}
    """
