This workflow annotates long non-coding RNAs from expression data in lifestock species.
The workflow consists of
* check quality with `FastQC <https://www.bioinformatics.babraham.ac.uk/projects/fastqc>`_
* read mapping with `STAR <https://github.com/alexdobin/STAR>`_
* transcriptome assembly with `stringtie <https://ccb.jhu.edu/software/stringtie/>`_
* classification of ncRNAs with `FEELnc <https://github.com/tderrien/FEELnc>`_
* quantification of expression with `RSEM <https://deweylab.github.io/RSEM>`_
