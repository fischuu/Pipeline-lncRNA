# vim: set filetype=sh :

rule buildsalmonIndex_salmon:
    """
    Prepare index (salmon).
    """
    input:
    output:
        "%s/salmon_index/hash.bin" % (references.loc[config["species"],"cdna"]) 
    params:
        species=config["species"],
        cdna=references.loc[config["species"],"cdna"]
    log:
        "%s/%s/logs/SALMON/salmon.log" % (config["project-folder"], config["species"])
    benchmark:
        "%s/%s/benchmark/salmon.benchmark.tsv" % (config["project-folder"], config["species"])
    threads: 16
    shell:"""
        module load salmon/0.12.0
        
        scripts/prepareSalmonIndex.sh {params.species} {params.cdna}
    """
