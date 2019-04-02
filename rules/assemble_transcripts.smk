# vim: set filetype=sh :

rule transcriptome_assembly_stringtie:
    """
    Transcript assembly (StringTie).
    """
    input:
        bam="%s/%s/BAM/{samples}.bam" % (config["project-folder"], config["species"]),
        splicedbam="%s/%s/BAM/{samples}_spliced.bam" % (config["project-folder"], config["species"]),
        libfile="%s/%s/SALMON/{samples}/lib_format_counts.json" % (config["project-folder"], config["species"]),
	      salmonlogfile="%s/%s/SALMON/{samples}/logs/salmon_quant.log" % (config["project-folder"], config["species"]),
        annotation=references.loc[config["species"],"annot"]
    output:
        "%s/%s/Stringtie/{samples}.stringtie.gtf" % (config["project-folder"], config["species"])
    log:
        "%s/%s/logs/stringtie.{samples}.log" % (config["project-folder"], config["species"])
    benchmark:
        "%s/%s/benchmark/stringtie.{samples}.benchmark.tsv" % (config["project-folder"], config["species"])
    threads: 12
    shell:"""
        lib_type=$(scripts/getLibType.sh {input.libfile});

       	echo "Detected lib type: " $lib_type

      	totalPolyA=$(scripts/getTotalPolyAinfo.sh {input.salmonlogfile});

        echo "Library type (total/polyA): " $totalPolyA

        if [ $totalPolyA == "polyA" ];
        then

        	if [ $lib_type == \"ISR\" ];
        	then
      	   		stringtie {input.bam} -p {threads} --rf -G {input.annotation} -v -o {output} 2> {log};
        	elif [ $lib_type == \"ISF\" ];
        	then
	        	stringtie {input.bam} -p {threads} --fr -G {input.annotation} -v -o {output} 2> {log};
        	elif [ $lib_type == \"IU\" ];
        	then
	        	stringtie {input.bam} -p {threads} -G {input.annotation} -v -o {output} 2> {log};
       		fi
	
	elif [ $totalPolyA == "total" ];
	then
	
		if [ $lib_type == \"ISR\" ];
        	then
           		stringtie {input.splicedbam} -p {threads} --rf -G {input.annotation} -v -o {output} 2> {log};
        	elif [ $lib_type == \"ISF\" ];
       		then
                	stringtie {input.splicedbam} -p {threads} --fr -G {input.annotation} -v -o {output} 2> {log};
        	elif [ $lib_type == \"IU\" ];
        	then
                	stringtie {input.splicedbam} -p {threads} -G {input.annotation} -v -o {output} 2> {log};
        	fi
	
	fi

    """
