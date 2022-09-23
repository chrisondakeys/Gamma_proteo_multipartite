#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: ./read_dataset.sh <ncbi_dataset folder>"
  exit 1
fi
LC_ALL=C
for protein_fasta in $(ls -d "$1"/data/*/*.faa); do
  DIR="$(dirname "${protein_fasta}")"
  echo "Now hmm-scanning files in $DIR"
  wd=$(echo "$protein_fasta" | rev | cut -d"/" -f2- | rev) #awk -F ".faa" '{print $1}')
  for marker in markers/*; do
    marker_name="$(basename "${marker}")"
    hmmscan --noali --domtblout "$wd/$marker_name.out" --cpu 1 "$marker/$marker_name.hmm" "$protein_fasta" > /dev/null
    grep -v "^#" "$wd/$marker_name.out" | sort -gk 7 | sed -n 1p > "$wd/tmpfile"
    mv "$wd/tmpfile" "$wd/$marker_name.out"
    protein_id=$(awk '{print $4}' "$wd/$marker_name.out")
    if [ -z "$protein_id" ]; then
      echo "Warning: $marker_name not found in $DIR"
    else
    ## if marker is found file is created. Easier for a later assessment and concatenation step
    shiba-keep "$protein_id" "$protein_fasta" > "$DIR/$marker_name""_match.faa"
    fi
  done
  echo "Done hmm-scanning files in $DIR"
  echo
done
