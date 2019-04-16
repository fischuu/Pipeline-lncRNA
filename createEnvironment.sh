module load bioconda/3
conda create -n FAANGlncRNA
conda install -n FAANGlncRNA fastqc=0.11.8
conda install -n FAANGlncRNA star=2.6.1d
conda install -n FAANGlncRNA multiqc=1.7
conda install -n FAANGlncRNA cutadapt=1.18
conda install -n FAANGlncRNA stringtie=1.3.4
conda install -n FAANGlncRNA feelnc=0.1.1
conda install -n FAANGlncRNA subread=1.6.3
conda install -n FAANGlncRNA samtools=1.9
conda install -n FAANGlncRNA bbmap=38.22
conda install -c bioconda -n FAANGlncRNA openssl=1.0 