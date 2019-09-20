# vim: set filetype=sh :

rule quality_control_fastqc:
    """
    Quality control of fastq files (FASTQC).
    """
    input:
        ["%s/%s/FASTQ/{samples}_1.fastq.gz" % (config["project-folder"], config["species"]),
         "%s/%s/FASTQ/{samples}_2.fastq.gz" % (config["project-folder"], config["species"])]
    output:
      #  zip1="%s/%s/FASTQC/{samples}/{samples}_1.zip" % (config["project-folder"], config["species"]),
      #  zip2="%s/%s/FASTQC/{samples}/{samples}_2.zip" % (config["project-folder"], config["species"]),
        dir=directory("%s/%s/FASTQC/{samples}" % (config["project-folder"], config["species"]))
    log:
        "%s/%s/logs/fastqc.{samples}.log" % (config["project-folder"], config["species"])
    benchmark:
        "%s/%s/benchmark/fastqc.{samples}.benchmark.tsv" % (config["project-folder"], config["species"])
    threads: 16
    shell:"""
        mkdir -p {output.dir}

        fastqc -t 16 --outdir {output} --extract {input} 2> {log};
    """
