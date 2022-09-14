#!/bin/bash
# needs https://github.com/mermaid-js/mermaid-cli
for filename in ./*.mm?; do
    mmdc -i "$filename" -o "./$(basename "$filename" .mmd).pdf" -b transparent -f -w 1920 -H 1080
    mmdc -i "$filename" -o "./$(basename "$filename" .mmd).svg" -b transparent -f -w 1920 -H 1080
    mmdc -i "$filename" -o "./$(basename "$filename" .mmd).png" -b transparent -f -w 1920 -H 1080
done
