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
    time: 05:00:00
    job-name:  starindex
    ntasks: 1
    cpus-per-task: 16
    mem-per-cpu: 60G
    shell:
	"(bash scripts/create_STARindex.sh $genome $annot $index > {output};) 2> {log}; "
