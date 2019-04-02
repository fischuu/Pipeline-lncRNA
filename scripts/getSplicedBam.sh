#!/bin/bash

inbam=$1;
outbam=$2;

#Create a temporary sam file name based on the name of the input bam
basename=$(echo $inbam | sed 's/\.[^.]*$//')
outsam=${basename}.sam

module load samtools
#Save spliced reads to the temporary sam file
samtools view -h $inbam | awk -v OFS="\t" '$0 ~ /^@/{print $0;next;} $6 ~ /N/' > $outsam
#Transform the sam file to bam file
samtools view -S -b $outsam > $outbam

rm $outsam

