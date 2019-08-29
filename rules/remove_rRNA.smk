# vim: set filetype=sh :

rule remove_rRNA:
    """
    Split input fastq files into ribosomal and non-ribosomal reads (BBmap).
    """
    input:
        rRNA=config["params"]["bbmap"]["rRNA"],
        fastq1="%s/%s/cutadapt/{samples}_cutadapt_R1.fastq.gz" % (config["project-folder"], config["species"]),
        fastq2="%s/%s/cutadapt/{samples}_cutadapt_R2.fastq.gz" % (config["project-folder"], config["species"])
    output:
        ribo1="%s/%s/BBDUK/{samples}_ribo1.fastq.gz" % (config["project-folder"], config["species"]),
        ribo2="%s/%s/BBDUK/{samples}_ribo2.fastq.gz" % (config["project-folder"], config["species"]),
        nonribo1="%s/%s/BBDUK/{samples}_nonribo1.fastq.gz" % (config["project-folder"], config["species"]),
        nonribo2="%s/%s/BBDUK/{samples}_nonribo2.fastq.gz" % (config["project-folder"], config["species"]),
        stats="%s/%s/BBDUK/{samples}_stats.txt" % (config["project-folder"], config["species"])
    params:
        dir=directory("%s/%s/BBDUK" % (config["project-folder"], config["species"]))
    log:
        "%s/%s/logs/remove_rRNA.{samples}.log" % (config["project-folder"], config["species"])
    benchmark:
        "%s/%s/benchmark/remove_rRNA.{samples}.benchmark.tsv" % (config["project-folder"], config["species"])
    threads: 8
    shell:"""
        printf \"%s\t%s\t%s\t%s\t%s\t%s\n\" {input.rRNA} {input.fastq1} {input.fastq2} {output} {log} {threads}

        [ ! -d \"{params.dir}\" ] && mkdir {params.dir}

        bbduk.sh threads={threads} in={input.fastq1} in2={input.fastq2} outm={output.ribo1} outm2={output.ribo2} out={output.nonribo1} out2={output.nonribo2} k=31 ref={input.rRNA}

        clines=$(zcat {output.ribo1} | wc -l ); 
        creads=$(perl -E "say $clines/4")
        echo -e "ribosomal reads:\t"$creads >> {output.stats}
	
        clines=$(zcat {output.nonribo1} | wc -l ); 
        creads=$(perl -E "say $clines/4")
        echo -e "non-ribosomal reads:\t"$creads >> {output.stats}
	
    """
