# vim: set filetype=sh :

rule compose_merge:
    """
    collect gtf files of all samples in one text file
    """
    input:
       files=expand("%s/%s/Stringtie/{sample}.stringtie.gtf" % (config["project-folder"], config["species"]), sample=samples)
    output:
       txt="%s/%s/Stringtie/stringtie_gtfs.txt" % (config["project-folder"], config["species"])
    params:
       folder="%s/%s/Stringtie/" % (config["project-folder"], config["species"])
    shell:"""
       scripts/composeMerge.sh {params.folder} {output.txt}
    """

