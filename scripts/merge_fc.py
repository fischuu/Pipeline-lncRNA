#!/usr/bin/env python3
import pandas as pd
import argparse as ap
import glob

"""
This script takes as input a folder containig featurecounts outputs and merges them together. 
NOTE: the featurecounts outputs have to be the only .txt files in the folder!
"""

parser=ap.ArgumentParser()
parser.add_argument('-f',help='path to folder containing featurecounts outputs',required=True,type=str)
parser.add_argument('-o',help='path to output file (give also filename, eg /home/.../merged_fc.tsv)',required=True,type=str)
args = parser.parse_args()

list_featurecounts_files = glob.glob(args.f+'*.txt')
df = pd.read_csv(list_featurecounts_files[0],sep='\t',skiprows=1, index_col='Geneid')
for fc_file in list_featurecounts_files[1:]:
    df_tmp = pd.read_csv(fc_file,sep='\t',skiprows=1, index_col='Geneid', usecols=[0,6])
    assert len(df) == len(df_tmp), 'Featurecounts files have different length!'
    df = pd.concat([df, df_tmp], join='inner', axis=1)
df.to_csv(args.o, sep = '\t', index_label='Geneid')
