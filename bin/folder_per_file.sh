#!/usr/bin/env bash

for i in *; do
    folder="${i%.*}"
    mkdir "$folder"
    mv "$i" "$folder"
done
