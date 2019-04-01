rule genome_indices:
    """
    Create the Genome indices.
    """
    input:
        lambda wildcards: config["species"][wildcards.sample]
    output:
        temp("results/genome_indices/{sample}.bam")
    params:
        rg=r"@RG\tID:{sample}\tSM:{sample}"
    log:
        "logs/genome_indices/{sample}.log"
    benchmark:
        "benchmarks/{sample}.genomeindex.benchmark.txt"
    shell:
	"(bash scripts/create_STARindex.sh $genome $annot $index > {output};) 2> {log}; "
