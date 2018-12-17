#!/bin/bash

# Salmon can be used for detecting strandedness, as well as for getting an idea whether polyA or total RNA-Seq (polyA with have much higher mapping rates to cDNA than totalRNA-Seq)

echo "Prepare salmon indexes for mapping to cDNA"
echo "------------------------------------------"

species=$1;
cDNAdir=$2;

ensembl_release=94 # any way to detect latest Ensembl release automatically??

mkdir -p $cDNAdir
cd $cDNAdir


#check if there is a cDNA file in the cDNA folder
if ls ${cDNAdir}/*cdna.all.fa.gz 1> /dev/null 2>&1; then
        echo "cDNA file already exists"
else
        echo "downloading cDNA file from Ensembl"
        rsync -av rsync://ftp.ensembl.org/ensembl/pub/release-${ensembl_release}/fasta/${species}/cdna/ .
fi


# Check if salmon_index folder already exists
if ls ${cDNAdir}/salmon_index 1> /dev/null 2>&1; then
        echo "Salmon index already exists"
else
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
      
fi
