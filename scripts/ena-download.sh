#!/bin/bash
## Hackathon ncRNA pipeline; 12 Nov 2018
## frank.panitz@mbg.au.dk; doncheva@rth.dk
## Download FASTQ from ENA

currentDir=$PWD

# Specify accession list & data storage
#enaAccList=/home/fpa/hackathon/test-data/goat.ena-accession.list
enaAccList=$1
dataDir=$2


if [[ ! -f $enaAccList ]]; then echo $enaAccList ': File not found, aborting.' ; exit; fi
mkdir -p $dataDir
cd $dataDir
pwd
IFS=$'\n' read -d '' -r -a StringArray < $enaAccList

## For each line in accession list check if md5 (for fastq) exists/matches or download
#cat $enaAccList | while read LINE; do 
#for LINE in ${StringArray[@]}; do
parallelDownload () {
    local LINE=$1
        echo $LINE

        ## Get run accession
        runAcc=$(echo $LINE | awk '{print $1}')
        wget "https://www.ebi.ac.uk/ena/data/warehouse/filereport?accession=${runAcc}&result=read_run&fields=run_accession,fastq_ftp,fastq_md5" -O ${runAcc}.filereport


        ## Write md5 from filereport
        echo -n $(cat ${runAcc}.filereport | tail -1 | awk '{print $3}' | awk -F ";" '{print $1}') > $runAcc.md5
        echo -e "  $(cat ${runAcc}.filereport | tail -1 | awk '{print $2}' | basename $(awk -F ";" '{print $1}'))" >> $runAcc.md5
        echo -n $(cat ${runAcc}.filereport | tail -1 | awk '{print $3}' | awk -F ";" '{print $2}') >> $runAcc.md5
        echo -e "  $(cat ${runAcc}.filereport | tail -1 | awk '{print $2}' | basename $(awk -F ";" '{print $2}'))" >> $runAcc.md5

        ## Check if md5 matches/exists, otherwise download fastq, do md5 and check
        ## read1
        fileFound=false
        MD5OKAY=false

        if [ -e "${runAcc}_1.fastq.gz.md5" ]; then
           fileFound=true;
           echo FILE FOUND
           if grep -q "$(cat ${runAcc}_1.fastq.gz.md5 | awk '{print $1}')" $runAcc.md5; then
                echo MD5 SUM OK
                MD5OKAY=true;
           fi
        fi

        if [ "$fileFound" = true ] && [ "$MD5OKAY" = true ]; then
           echo NOTHING TO BE DONE

        else
           fileFound=false
           MD5OKAY=false
           echo NOT FOUND
           echo '[WGET]'
           wget ftp://$(cat ${runAcc}.filereport | tail -1 | awk '{print $2}' | awk -F ";" '{print $1}')
           md5sum ${runAcc}_1.fastq.gz > ${runAcc}_1.fastq.gz.md5
           if grep -q $(cat ${runAcc}_1.fastq.gz.md5 | awk '{print $1}') $runAcc.md5; then
                echo OK
           else
                echo '[FAIL - Check downloaded fastq-1 file and md5sum]'        
           fi
        fi
	

	## read2
        fileFound=false
        MD5OKAY=false

        if [ -e "${runAcc}_2.fastq.gz.md5" ]; then
           fileFound=true;
           echo FILE FOUND
           if grep -q "$(cat ${runAcc}_2.fastq.gz.md5 | awk '{print $1}')" $runAcc.md5; then
                echo MD5 SUM OK
                MD5OKAY=true;
           fi
        fi

        if [ "$fileFound" = true ] && [ "$MD5OKAY" = true ]; then
           echo NOTHING TO BE DONE

        else
                fileFound=false
                MD5OKAY=false
                echo NOT FOUND
                echo '[WGET]'
                wget ftp://$(cat ${runAcc}.filereport | tail -1 | awk '{print $2}' | awk -F ";" '{print $2}')
                md5sum ${runAcc}_2.fastq.gz > ${runAcc}_2.fastq.gz.md5
                if grep -q $(cat ${runAcc}_2.fastq.gz.md5 | awk '{print $1}') $runAcc.md5; then
                        echo OK
                else
                        echo '[FAIL - Check downloaded fastq-2 file and md5sum]'        
                fi
        fi
}

N=4
(
for LINE in ${StringArray[@]}; do 
   ((i=i%N)); ((i++==0)) && wait
   parallelDownload "$LINE" & 
done
)

touch downloadReady

cd ${currentDir}
