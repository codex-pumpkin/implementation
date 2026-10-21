#!/usr/bin/env bash

input="$1"

# Normalize the path (remove leading ./ )
input="${input#./}"

# Extract everything after "drawio/"
relative_path="${input#../drawio/}"

# Replace .drawio with .pdf
output_rel_path="${relative_path%.drawio}.pdf"

# Build final output path
output_file="../figures/drawio/$output_rel_path"

# Ensure output directory exists
mkdir -p "$(dirname "$output_file")"

# Export the file to PDF
drawio --export --format pdf --output "$output_file" --crop --border 16 "$input"

# Add new pdf to git
git add "$output_file"
