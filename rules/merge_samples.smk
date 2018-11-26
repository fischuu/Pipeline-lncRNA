# vim: set filetype=sh :

rule merge_samples:
    """
    Merge the gtf files (stringtie merge).
    """
    input:
        gtfs="%s/%s/Stringtie/stringtie_gtfs.txt" % (config["project-folder"], config["species"]),
        annotation=references.loc[config["species"],"annot"]
    output:
        "%s/%s/GTF_merged/merged_STRG.gtf" % (config["project-folder"], config["species"])
    params:
        tpm=config["params"]["stringtie"]["tpm"]
    log:
        "%s/%s/logs/stringtiemerge.log" % (config["project-folder"], config["species"])
    benchmark:
        "%s/%s/benchmark/stringtiemerge.benchmark.tsv" % (config["project-folder"], config["species"])
    threads: 16
    shell:"""
        module load stringtie

        stringtie --merge -G {input.annotation} -F 0 -T {params.tpm} -o {output} {input.gtfs}
    """
