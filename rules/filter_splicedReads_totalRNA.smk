# vim: set filetype=sh :

rule filter_splicedReads_totalRNA:
    """
    Select only spliced reads for total RNA-Seq samples; retain original bam files with a different name.
    """
    input:
        bam="%s/%s/BAM/{samples}.bam" % (config["project-folder"], config["species"]),
        salmonlogfile="%s/%s/SALMON/{samples}/logs/salmon_quant.log" % (config["project-folder"], config["species"])
    output:
        outbam="%s/%s/BAM/{samples}_spliced.bam" % (config["project-folder"], config["species"])
    log:
        "%s/%s/logs/filter_splicedReads_totalRNA.{samples}.log" % (config["project-folder"], config["species"])
    benchmark:
        "%s/%s/benchmark/filter_splicedReads_totalRNA.{samples}.benchmark.tsv" % (config["project-folder"], config["species"])
    threads: 1
    shell:"""

        totalPolyA=$(scripts/getTotalPolyAinfo.sh {input.salmonlogfile});

        echo "Library type (total/polyA): " $totalPolyA

        if [ $totalPolyA == "total" ];
        then
		./scripts/getSplicedBam.sh {input.bam} {output.outbam}		
        else
		touch {output.outbam}
	fi
    """
