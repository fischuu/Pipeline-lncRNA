# vim: set filetype=sh :

rule mapping_salmon:
    """
    Map the reads (salmon).
    """
    input:
        fastq1="%s/%s/BBDUK/{samples}_nonribo1.fastq.gz" % (config["project-folder"], config["species"]),
	      fastq2="%s/%s/BBDUK/{samples}_nonribo2.fastq.gz" % (config["project-folder"], config["species"]),
        index="%s/salmon_index/hash.bin" % (references.loc[config["species"],"cdna"])
    output:
        "%s/%s/SALMON/{samples}/lib_format_counts.json" % (config["project-folder"], config["species"]),
        salmonlogfile="%s/%s/SALMON/{samples}/logs/salmon_quant.log" % (config["project-folder"], config["species"])
    params:
        cdna=references.loc[config["species"],"cdna"],
        outdir="%s/%s/SALMON/{samples}" % (config["project-folder"], config["species"])
    log:
        "%s/%s/logs/SALMON/salmonMapping_{samples}.log" % (config["project-folder"], config["species"])
    benchmark:
        "%s/%s/benchmark/salmonMapping_{samples}.benchmark.tsv" % (config["project-folder"], config["species"])
    threads: 16
    shell:"""
        module load salmon/0.12.0

        salmon quant -i {params.cdna}/salmon_index -p {threads} -l A -1 {input.fastq1} -2 {input.fastq2} -o {params.outdir} 2> {log};
    """
