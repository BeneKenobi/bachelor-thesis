#!/bin/bash
# needs https://github.com/mermaid-js/mermaid-cli
for filename in ./*.mm?; do
    base_name=$(basename "$filename" .mm | basename "$filename" .mmd)
    mmdc -i "$filename" -o "./$base_name.svg" -f -b transparent -t neutral
done
