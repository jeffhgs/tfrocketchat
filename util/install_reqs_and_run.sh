#!/bin/bash
adirState="$1"
afileScript="$2"
shift
shift

mkdir -p "$adirState"

md5Script=$(md5sum "$afileScript" | cut -c1-32)
rfileScript=$(basename "$afileScript")
adirStatus="${adirState}/${md5Script}"
if [ ! -e "${adirStatus}/success" ]
then
  echo need to run "$afileScript"
  mkdir -p "$adirStatus"
  touch "$adirStatus/$rfileScript" # for debugging
  chmod +x "$afileScript"
  if "$afileScript"
  then
    touch "${adirStatus}/success"
  else
    touch "${adirStatus}/error" # for debugging
  fi
else
  echo "already ran $afileScript"
fi
echo continuing with "$@"
"$@"
