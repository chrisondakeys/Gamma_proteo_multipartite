#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: ./prepare_headers.sh <Pfam FASTA file>"
  exit 1
fi

#1) find headers for every marker in Pfam FASTA file

#=====================================================#

grep "^>" "$1" > tmpfile0123
for marker in markers/*; do
    marker_name="$(basename "${marker}")"
    pfam=$(ls "$marker" | grep ^PF | cut -d"." -f1)
    grep "$pfam" tmpfile0123 > "$marker_name.pfam.headers"
done
rm tmpfile0123
