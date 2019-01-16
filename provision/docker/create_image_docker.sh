#!/bin/bash

dockerfile=$1
dockerfile_path="/home/vagrant"

docker build -t "$dockerfile" -f "$dockerfile" "$dockerfile_path"

rm -f "$dockerfile $dockerfile.sh makefile"
