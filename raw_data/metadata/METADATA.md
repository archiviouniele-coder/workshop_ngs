# Metadata download and modification

RNA-seq metadata:
https://ftp.ebi.ac.uk/biostudies/fire/E-MTAB-/025/E-MTAB-13025/Files/E-MTAB-13025.sdrf.txt

ChIP-seq metadata:
https://ftp.ebi.ac.uk/biostudies/fire/E-MTAB-/026/E-MTAB-13026/Files/E-MTAB-13026.sdrf.txt

The metadata files were modified as follows:

- Samples carrying the ΔHP1021 genotype were excluded.
- ENA FASTQ addresses were converted from ftp:// to https://.
- A new HTTPS_FASTQ_URI column was added.
- A new FASTQ_NAME column was added.
- FASTQ names combine the sample name with the paired-end read number.

Example:

WT_1 + ERR11479310_1.fastq.gz -> WT_1_R1.fastq.gz
WT_1 + ERR11479310_2.fastq.gz -> WT_1_R2.fastq.gz

RNA-seq FASTQ files:
raw_data/fastq/rnaseq

ChIP-seq FASTQ files:
raw_data/fastq/chipseq
