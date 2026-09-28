# Workflow execution log

## Day 1

- Created `.gitignore` and `README.md`.
- Connected the local repository to GitHub.
- Tested Docker with a mounted project folder.
- Downloaded the matched `GCF_025998455.1` FASTA, GFF3, and GTF files for chromosome `NZ_AP026446.1` and derived the RSeQC BED12 gene model from the GFF3.
- Ran `02_download_ena_fastq.sh` to download and filter the original SDRFs, create `RNAseq_metadata.txt` and `Chipseq_metadata.txt`, and retrieve the WT FASTQ files.
- Recorded the metadata sources and transformations in `raw_data/metadata/METADATA.md` and reviewed GEO/SRA as an optional route.
- Ran fastp to trim adapters and low-quality tails, filter poor reads, and create trimmed FASTQ files.
- Inspected the fastp HTML reports; raw pairs were removed automatically after successful processing.

## Day 2 RNA-seq mapping

Date: 2026-09-27

The Bowtie2 mapping workflow was run using:

```bash
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-bowtie2-samtools \
  bash scripts/day2_rnaseq/02_map_bowtie2_sort_index.sh
```

### Correction to the mapping script

The original `samtools sort` command contained the unsupported `-b`
option. The command was corrected to:

```bash
samtools sort \
  -@ 2 \
  -o "${bam_file}" \
  "${sam_file}"
```

### Recovery of WTS_1

The script stopped after Bowtie2 had completed mapping `WTS_1`, leaving:

```text
results/day2_rnaseq/bam/WTS_1.sam
```

Rather than repeating the completed alignment, the existing SAM file was
manually processed through the remaining workflow steps:

1. Coordinate sorting to `WTS_1.sorted.bam`.
2. BAM validation with `samtools quickcheck`.
3. Indexing of the sorted BAM.
4. Pre-filter `samtools flagstat`.
5. Filtering with `samtools view -q 10 -f 2 -F 2828`.
6. Validation and indexing of `WTS_1.filtered.bam`.
7. Post-filter `samtools flagstat`.

The sorted BAM passed `samtools quickcheck`, and sorting, indexing,
filtering, and flagstat commands all returned exit status 0.

The unfiltered `WTS_1` alignment contained:

- 13,913,786 total read records.
- 11,549,444 mapped records (83.01%).
- 10,109,038 properly paired records (72.65%).
- 6,956,893 read 1 records.
- 6,956,893 read 2 records.

The temporary `WTS_1.sam` file was deleted only after the sorted and
filtered BAM files had been validated and indexed.

### Resume handling

A completion check was added to the sample loop. A sample is skipped only
when its sorted BAM, filtered BAM, both BAM indexes, and both flagstat logs
exist and are nonempty.

This allowed the script to skip the completed `WTS_1` sample and process
the remaining five samples without overwriting the recovered outputs.

All temporary SAM files were removed after successful processing.