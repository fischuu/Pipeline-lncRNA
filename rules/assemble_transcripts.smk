# vim: set filetype=sh :

rule transcriptome_assembly_stringtie:
    """
    Transcript assembly (StringTie).
    """
    input:
        bam="%s/%s/BAM/{samples}.bam" % (config["project-folder"], config["species"]),
        annotation=references.loc[config["species"],"annot"]
    output:
        "%s/%s/Stringtie/{samples}.stringtie.gtf" % (config["project-folder"], config["species"])
    params:
        strandedness="fr-firststrand"
    log:
        "%s/%s/logs/stringtie.{samples}.log" % (config["project-folder"], config["species"])
    benchmark:
        "%s/%s/benchmark/stringtie.{samples}.benchmark.tsv" % (config["project-folder"], config["species"])
    threads: 16
    shell:"""
        module load stringtie ;

        if [ {params.strandedness} == \"fr-secondstrand\" ];
        then
  	   stringtie {input.bam} -p {threads} --fr -G {input.annotation} -v -o {output} 2> {log};
        elif [ {params.strandedness} == \"fr-firststrand\" ];
        then
	   stringtie {input.bam} -p {threads} --rf -G {input.annotation} -v -o {output} 2> {log};
        fi
    """
