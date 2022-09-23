#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: ./read_dataset.sh <ncbi_dataset folder> <marker name>"
  exit 1
fi
LC_ALL=C

for protein_fasta in $(ls -d "$1"/data/*/"$2""_match.faa"); do
  DIR="$(dirname "${protein_fasta}")"
  wd=$(echo "$DIR" | rev | cut -d"/" -f1 | rev) #awk -F ".faa" '{print $1}')
  id=$(grep "^>" "$protein_fasta" | cut -d">" -f2 | cut -d" " -f1)

  besthit=$(grep "^$id" diamond.out | sort -gk 11 | head -n1 | cut -f2)
  found=$(grep -m1 "$besthit" "$2".pfam.headers)
  if [ "$found" ]; then
    #cat "$protein_fasta"
    sed "s|^>$id.*|>$wd@$id|g" "$protein_fasta"
  fi
done
