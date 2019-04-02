#!/bin/bash

input=$1;

if [[ ! -f $input ]] ; then
    echo 'salmon log file not found, aborting.'
    exit
fi

if [[ $(grep "Mapping rate" $input | head -1 | awk '{split($NF,a,"."); print a[1]}') -ge "60" ]] ; then
	echo "polyA"
elif [[ $(grep "Mapping rate" $input | head -1 | awk '{split($NF,a,"."); print a[1]}') -lt "60" ]] ; then
	echo "total"
else 
	echo "error"
fi
