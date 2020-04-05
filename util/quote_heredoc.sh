#!/bin/bash

fileIn="$1"
fileOut="$2"
symEnd="$3"

# invariant:
#
# for every x,
#
# bash ~/bin/quote_heredoc.sh "$x" "$x.out" | bash
# diff -u "$x" "$x.old"

usage() {
    echo "ERROR: $1" 1>&2
    echo "" 1>&2
    echo "usage:" 1>&2
    echo "    quote_heredoc.sh <input filename> [output filename] [end symbol]" 1>&2
    echo "" 1>&2
    exit 1
}

if [ -z "$fileIn" ]
then
    usage "<input file> required"
fi

if [ ! -e "$fileIn" ]
then
    usage "<input file> not found"
fi

if [ -z "$fileOut" ]
then
    fileOut="$fileIn"
fi

if [ -z "$symEnd" ]
then
    symEnd=EOF
fi

printf "cat > %s <<\"%s\"\n" "${fileOut}" "$symEnd"

while IFS= read -r; do
  line=$REPLY
  printf "%s\n" "$line"
done < "$fileIn"

printf "%s\n" "$symEnd"
