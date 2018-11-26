# vim: set filetype=sh :

rule compose_merge:
    """
    collect gtf files of all samples in one text file
    """
    input:
       expand("%s/%s/Stringtie/{sample}.stringtie.gtf" % (config["project-folder"], config["species"]), sample=samples)
    output:
       txt="%s/%s/Stringtie/stringtie_gtfs.txt" % (config["project-folder"], config["species"])
    run:
        with open(output.txt, 'w') as out:
            print(*input, sep="\n", file=out)
