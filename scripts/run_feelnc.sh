#!/bin/bash

# This function takes the inputs:
# 1. A gtf with candidate loci 
# 2. A gtf with the reference genes
# 3. A fasta with the reference genome
# 4. An output foldername
# 5. A name for the analysis


export FEELNCPATH=/home/users/fischer/bin/FEELnc
export PERL5LIB=${FEELNCPATH}/lib/:$PERL5LIB

export PATH=$PATH:${FEELNCPATH}/scripts/
export PATH=$PATH:${FEELNCPATH}/utils/

# for LINUX
#----------
export PATH=$PATH:${FEELNCPATH}/bin/LINUX/
FEELloc="/home/users/fischer/bin/FEELnc/scripts"


echo "I am the applyFEELnc.sh script version";
echo "-------------------------------------------------"

# Give meaningful names to input variables:
CANDIDATES=$1;
ANNOTATION=$2;
GENOME=$3;
OUTPUTFOLDER=$4;
PROJECTNAME=$5;

# Create some variables requires for the output
afterFilter="$OUTPUTFOLDER/filter/$PROJECTNAME.filter.gtf"
afterFilterLog="$OUTPUTFOLDER/filter/$PROJECTNAME.filter.log"
afterCodpot="$PROJECTNAME.codpot"
afterClass="$OUTPUTFOLDER/classifier/$PROJECTNAME.classifier.txt"
afterClassLog="$OUTPUTFOLDER/classifier/$PROJECTNAME.classifier.log"

echo "GTF file              :" $CANDIDATED;
echo "Annotation            :" $ANNOTATION;
echo "Genome                :" $GENOME;
echo "Output folder         :" $OUTPUTFOLDER;
echo "Project name          :" $PROJECTNAME;

echo "--------------------------------------------------------------------"
echo "Start the filter module..."

if [ ! -f $afterFilter ]; then
  mkdir -p $OUTPUTFOLDER/filter/;
  $FEELloc/FEELnc_filter.pl --infile=$CANDIDATES \
                            --mRNAfile=$ANNOTATION \
                            --biotype=transcript_biotype=protein_coding \
                            --monoex=-1 \
                            --outlog=$afterFilterLog > $afterFilter
  echo "... done!"

fi 

echo "--------------------------------------------------------------------"
echo "Start the coding potential module..."


if [ ! -f $OUTPUTFOLDER/codpot/$afterCodpot ]; then

  mkdir -p $OUTPUTFOLDER/codpot/;
  $FEELloc/FEELnc_codpot.pl --infile=$afterFilter \
                            --mRNAfile=$ANNOTATION \
                            --genome=$GENOME \
                            -b transcript_biotype=protein_coding \
                            --mode=shuffle \
                            --outname=$afterCodpot \
                            --outdir=$OUTPUTFOLDER/codpot/
  echo "... done!"

fi

echo "--------------------------------------------------------------------"
echo "Start the classifier module:"

if [ ! -f $afterClass ]; then

  mkdir -p $OUTPUTFOLDER/classifier/;
  $FEELloc/FEELnc_classifier.pl --lncrna=$OUTPUTFOLDER/codpot/$afterCodpot.lncRNA.gtf \
                                --mrna=$ANNOTATION > $afterClass
echo "... done!"

fi

echo "--------------------------------------------------------------------"
echo "FEELnc finished!"
