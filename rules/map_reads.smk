# vim: set filetype=sh :

rule star_map:
    """
    Map the samples to the genome (STAR).
    """
    input:
        index=references.loc[config["species"],"index"],
        annotation=references.loc[config["species"],"annot"],
        fastq=["%s/%s/FASTQ/{samples}_1.fastq.gz" % (config["project-folder"], config["species"]),
               "%s/%s/FASTQ/{samples}_2.fastq.gz" % (config["project-folder"], config["species"])]
    output:
        file="%s/%s/BAM/{samples}.bam" % (config["project-folder"], config["species"]),
        dir=directory("%s/%s/BAM/{samples}" % (config["project-folder"], config["species"]))
    log:
        "%s/%s/logs/star_map.{samples}.log" % (config["project-folder"], config["species"])
    benchmark:
        "%s/%s/benchmark/star_map.{samples}.benchmark.tsv" % (config["project-folder"], config["species"])
    threads: 16
    shell:"""
        module load STAR;

        mkdir {output.dir};

        printf \"%s\t%s\t%s\t%s\t%s\t%s\n\" {input.index} {input.annotation} {input.fastq} {output} {log} {threads}

	[ ! -d \"{output.dir}\" ] && mkdir {output.dir}

        STAR --genomeDir {input.index} \
            --readFilesIn {input.fastq} \
            --readFilesCommand zcat \
            --outFilterType BySJout \
            --outSAMunmapped Within \
            --outSAMtype BAM SortedByCoordinate \
            --outSAMstrandField intronMotif \
            --outSAMattrIHstart 0 \
            --outFilterIntronMotifs RemoveNoncanonical \
            --runThreadN {threads} \
            --quantMode TranscriptomeSAM \
            --outWigType bedGraph \
            --outWigStrand Stranded \
            --alignSoftClipAtReferenceEnds No \
            --outFileNamePrefix {wildcards.samples}_ 2> {log};

        mv {wildcards.samples}_Aligned.sortedByCoord.out.bam {output.file}
        mv {wildcards.samples}_Log.final.out {wildcards.samples}_Log.progress.out {wildcards.samples}_Signal.UniqueMultiple.str2.out.bg {wildcards.samples}_Signal.Unique.str2.out.bg {wildcards.samples}_Aligned.toTranscriptome.out.bam {wildcards.samples}_Log.out {wildcards.samples}_Signal.UniqueMultiple.str1.out.bg {wildcards.samples}_Signal.Unique.str1.out.bg {wildcards.samples}_SJ.out.tab {output.dir}
    """
