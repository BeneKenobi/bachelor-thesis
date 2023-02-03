#!/bin/bash
# needs https://github.com/mermaid-js/mermaid-cli
for filename in ./*.mm?; do
    ~/node_modules/.bin/mmdc -i "$filename" -o "./$(basename "$filename").pdf" -f -b transparent -t neutral -w auto
done
