#!/usr/bin/env bash

set -euo pipefail

srr="ERR11479311"

sample="WT_2"

outdir="raw_data/fastq/rnaseq"

mkdir -p "${outdir}"

fasterq-dump "${srr}" \

  --split-files \

  --threads 2 \

  --progress \

  --details \

  --outdir "${outdir}"

gzip "${outdir}/${srr}"*.fastq
