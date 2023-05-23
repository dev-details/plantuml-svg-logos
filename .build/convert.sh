#!/bin/bash

set -euo pipefail

# svgo required: pnpm -g install svgo
# https://github.com/svg/svgo

# Directory to output the .puml files
output_dir="./plantuml"
svg_archive="https://github.com/dev-details/gilbarbara-logos/archive/refs/heads/main.tar.gz"

mkdir -p "$output_dir"

# Download and extract the repository to a temporary directory
tmp_dir="$(mktemp -d)"
curl -L "$svg_archive" | tar --strip-components=1 -xz -C "$tmp_dir"

input_dir="$tmp_dir/logos"
svgo -f "$input_dir"

# Make an array of all the .svg files
svg_files=("$input_dir"/*.svg)
total_files=${#svg_files[@]}

processed_files=0

# Iterate over every .svg file in the array
for input_file in "${svg_files[@]}"; do
    base_name=$(basename "$input_file" .svg)
    output_file="$output_dir/$base_name.puml"

    echo "@startuml" > "$output_file"
    echo "sprite $base_name $(cat "$input_file")" >> "$output_file"
    echo "@enduml" >> "$output_file"

    percent=$((100 * $processed_files / $total_files))
    echo "${percent}% Processed file: $base_name"
    
    processed_files=$((processed_files + 1))
done
