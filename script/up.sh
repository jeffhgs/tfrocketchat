#!/bin/bash
cd /docker-build
docker-compose up -d
service nginx start
