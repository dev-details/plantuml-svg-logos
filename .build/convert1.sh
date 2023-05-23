#!/bin/bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# svgo required: pnpm -g install svgo
# https://github.com/svg/svgo

# Check if a sprite name was provided as an argument
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <sprite_name> <svg_url>"
    exit 1
fi

# Directory to output the .puml files
output_dir="./plantuml"
base_name="$1"
svg_url="$2"

mkdir -p "$output_dir"

# Download to a temporary directory
tmp_dir="$(mktemp -d)"
input_file="$tmp_dir/${base_name}.svg"

curl -L "$svg_url" >> "$input_file"

svgo --multipass --pretty --final-newline "$input_file"

output_file="$output_dir/$base_name.puml"

echo "@startuml" > "$output_file"
echo "sprite $base_name $(cat "$input_file")" >> "$output_file"
echo "@enduml" >> "$output_file"
echo "" >> "$output_file"

echo "Processed file: $base_name"

"$DIR/preview.sh" "$base_name"
