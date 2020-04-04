#!/bin/bash
adirScript="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkvol() {
  mkdir -p "$1"
  chown 1000:1000 "$1"
}

mkdir -p "/docker-build"
cp "$adirScript/docker-compose.yml" "/docker-build/docker-compose.yml"
cd /docker-build
docker-compose build
mkvol ./uploads
mkvol ./data/db
mkvol ./scripts
