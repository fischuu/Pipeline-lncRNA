# vim: set filetype=sh :

rule downloadFASTQ_bash:
    """
    Download the included FASTQ-files (Bash).
    """
    params:
        ids=references.loc[config["species"],"ids"]
    output:
        directory("%s/%s/FASTQ" % (config["project-folder"], config["species"]))
    log:
        "%s/%s/logs/FASTQdownload/FASTQdownload.log" % (config["project-folder"], config["species"])
    benchmark:
        "%s/%s/benchmark/FASTQdownload.benchmark.tsv" % (config["project-folder"], config["species"])
    shell:"""
        scripts/ena-download.sh {params.ids} {output}
    """
