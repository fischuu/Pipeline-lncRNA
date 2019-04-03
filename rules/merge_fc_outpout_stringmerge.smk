# vim: set filetype=sh :

rule merge_fc_outpout_stringmerge:
    """
    Merge fc output (Panda).
    """
    input:
        directory("%s/%s/GTF/Stringmerge_fc/" % (config["project-folder"], config["species"]))
    output:
        "%s/%s/GTF/Stringmerge_fc.txt" % (config["project-folder"], config["species"])
    log:
        "%s/%s/logs/merge_fc.log" % (config["project-folder"], config["species"])
    benchmark:
        "%s/%s/benchmark/merge_fc.benchmark.tsv" % (config["project-folder"], config["species"])
    shell:"""
        scripts/merge_fc.py -f {input} -o {output}
    """
