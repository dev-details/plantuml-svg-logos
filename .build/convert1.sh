#!/bin/bash

# svgo required: pnpm -g install svgo
# https://github.com/svg/svgo

# Directory to output the .puml files
output_dir="./plantuml"
base_name="$1"
svg_url="$2"

mkdir -p "$output_dir"

# Download to a temporary directory
tmp_dir="$(mktemp -d)"
input_file="$tmp_dir/${base_name}.svg"

curl -L "$svg_url" >> "$input_file"

svgo "$input_file"

output_file="$output_dir/$base_name.puml"

echo "@startuml" > "$output_file"
echo "sprite $base_name $(cat "$input_file")" >> "$output_file"
echo "@enduml" >> "$output_file"

echo "Processed file: $base_name"
