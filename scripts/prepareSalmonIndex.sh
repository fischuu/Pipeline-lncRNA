#!/bin/bash

# Salmon can be used for detecting strandedness, as well as for getting an idea whether polyA or total RNA-Seq (polyA with have much higher mapping rates to cDNA than totalRNA-Seq)

echo "Prepare salmon indexes for mapping to cDNA"
echo "------------------------------------------"

species=$1;
cDNAdir=$2;

ensembl_release=94 # any way to detect latest Ensembl release automatically??

mkdir -p $cDNAdir
cd $cDNAdir

echo "downloading cDNA file from Ensembl"
echo "----------------------------------"
rsync -av rsync://ftp.ensembl.org/ensembl/pub/release-${ensembl_release}/fasta/${species}/cdna/ .

echo "Building Salmon index"
echo "---------------------"

if ! ls ${cDNAdir}/*cdna.all.fa 1> /dev/null 2>&1; then
      echo "unzipping cDNA fasta file"
      gunzip *cdna.all.fa.gz
fi

salmon index -i salmon_index --transcripts *fa

if ! ls ${cDNAdir}/*cdna.all.fa.gz 1> /dev/null 2>&1; then
      echo "zipping cDNA fasta file"
      gzip *cdna.all.fa
fi
      
