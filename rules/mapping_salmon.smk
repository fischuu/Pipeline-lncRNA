# vim: set filetype=sh :

rule mapping_salmon:
    """
    Map the reads (salmon).
    """
    input:
        fastq1="%s/%s/FASTQ/{samples}_1.fastq.gz" % (config["project-folder"], config["species"]),
        fastq2="%s/%s/FASTQ/{samples}_2.fastq.gz" % (config["project-folder"], config["species"])
    output:
        directory("%s/%s/SALMON/{samples}" % (config["project-folder"], config["species"])) 
    params:
        species=config["species"],
        cdna=references.loc[config["species"],"cdna"]
    log:
        "%s/%s/logs/SALMON/salmonMapping_{samples}.log" % (config["project-folder"], config["species"])
    benchmark:
        "%s/%s/benchmark/salmonMapping_{samples}.benchmark.tsv" % (config["project-folder"], config["species"])
    threads: 16
    shell:"""
        module load salmon/0.12.0
        
        mkdir -p {output}

        salmon quant -i {params.cdna}/salmon_index -p {threads} -l A -1 {input.fastq1} -2 {input.fastq2} -o {output} 2> {log};
    """
