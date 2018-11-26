# vim: set filetype=sh :

rule quantify_expr_rsem:
    """
    Quantify expression values (RSEM).
    """
    input:
        bam="%s/%s/BAM/{samples}.bam" % (config["project-folder"], config["species"]),
        merge_samples="%s/%s/GTF_merged/merged_STRG.gtf" % (config["project-folder"], config["species"]),
        genome=references.loc[config["species"],"genome"]
    output:
        "%s/%s/RSEM/{samples}" % (config["project-folder"], config["species"])
    params:
        species=config["species"],
        strandedness="fr-firststrand",
        rsemgenomedir="/home/projects/faang_cost/data/transcriptome_indexes/RSEM/%s/STAR_CUFF_transcripts_Ensembl_87/RSEMindex/RSEMref" % config["species"]
    log:
        "%s/%s/RSEM/rsem.{samples}log" % (config["project-folder"], config["species"])
    benchmark:
        "%s/%s/benchmark/rsem.{samples}.benchmark.tsv" % (config["project-folder"], config["species"])
    threads: 16
    shell:"""
        /home/users/jmx/local/RSEM-1.3.0/rsem-calculate-expression --bam \
        --no-bam-output \
        --estimate-rspd \
        --calc-ci \
        --seed 12345 \
        -p {threads} \
        --ci-memory 3000 \
        --paired-end \
        --strandedness {params.strandedness} \
        {input.bam} \
        {params.rsemgenomedir} \
        {wildcards.samples}
    """
