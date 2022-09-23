#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: ./run_diamond.sh <Pfam diamond database> <ncbi_dataset folder>"
  exit 1
fi

#2) log proteins not found
#3) concatenate all found proteins
#4) run diamond blast
#5) store output in a big table which gets read later

#=====================================================#
cat "$2"/data/*/*_match.faa > tempfile01234
shiba-keep <(grep "^>" tempfile01234 | cut -d">" -f2 | cut -d" " -f1 | sort | uniq) tempfile01234 > concatenated.faa
rm tempfile01234


diamond blastp --db "$1" --query concatenated.faa --out diamond.out --outfmt 6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qseq -p 56 -b10 -c1 --sensitive
