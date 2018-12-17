# vim: set filetype=sh :

rule transcriptome_assembly_stringtie:
    """
    Transcript assembly (StringTie).
    """
    input:
        bam="%s/%s/BAM/{samples}.bam" % (config["project-folder"], config["species"]),
        libfile="%s/%s/SALMON/{samples}/lib_format_counts.json" % (config["project-folder"], config["species"]),
        annotation=references.loc[config["species"],"annot"]
    output:
        "%s/%s/Stringtie/{samples}.stringtie.gtf" % (config["project-folder"], config["species"])
    log:
        "%s/%s/logs/stringtie.{samples}.log" % (config["project-folder"], config["species"])
    benchmark:
        "%s/%s/benchmark/stringtie.{samples}.benchmark.tsv" % (config["project-folder"], config["species"])
    threads: 16
    shell:"""
        module load stringtie ;

        lib_type=$(scripts/getLibType.sh {input.libfile});

       echo "Detected lib type: " $lib_type

        if [ $lib_type == \"ISR\" ];
        then
      	   stringtie {input.bam} -p {threads} --rf -G {input.annotation} -v -o {output} 2> {log};
      	   samplesStranded.append(wildcard.samples);
      	   
        elif [ $lib_type == \"ISF\" ];
        then
	         stringtie {input.bam} -p {threads} --fr -G {input.annotation} -v -o {output} 2> {log};
	         samplesStranded.append(wildcard.samples);
	         
        elif [ $lib_type == \"IU\" ];
        then
	         stringtie {input.bam} -p {threads} -G {input.annotation} -v -o {output} 2> {log};
        fi
    """