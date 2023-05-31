#!/bin/bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

test "${DEBUG:-}" && set -x

function display_help {
    echo "Usage: $0 [--help] [--no-optimize] [--no-preview] <sprite_name> <svg_url>"
    echo "--no-optimize: Disables the SVG optimization"
    echo "--help: Shows this help message."
    echo "--no-preview: Disables preview"
    exit 0
}

function download_svg {
    local base_name="$1"
    local svg_url="$2"

    # Download to a temporary directory
    tmp_dir="$(mktemp -d)"
    svg_file="$tmp_dir/${base_name}.svg"

    curl -L "$svg_url" >> "$svg_file"
    echo "$svg_file"
}

function optimize_svg {
    local svg_file="$1"
    svgo --multipass --pretty --final-newline "$svg_file"
}


function generate_plantuml {
    local base_name="$1"
    local svg_file="$2"

    output_dir="./plantuml"
    mkdir -p "$output_dir"

    output_file="$output_dir/$base_name.puml"

    echo "@startuml" > "$output_file"
    echo "sprite $base_name $(cat "$svg_file")" >> "$output_file"
    echo "@enduml" >> "$output_file"
    echo "" >> "$output_file"    
}

function preview_plantuml {
    local base_name="$1"
    "$DIR/preview.sh" "$base_name"
}

function main {
    local OPTIMIZE=true
    local HELP=false
    local PREVIEW=true
    local args=()

    # Parse flags
    while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
            --no-optimize)
            OPTIMIZE=false
            shift
            ;;
            --help)
            display_help
            ;;
            --no-preview)
            PREVIEW=false
            shift
            ;;
            *)
            args+=("$key")
            shift
            ;;
        esac
    done

    local base_name="${args[0]:-}"
    local svg_url="${args[1]:-}"

    if [[ -z "$base_name" || -z "$svg_url" ]]; then
        echo "Error: Invalid sprite name or SVG URL"
        echo ""
        display_help
        exit 1
    fi

    local svg_file="$(download_svg "$base_name" "$svg_url")"

    if $OPTIMIZE; then
        optimize_svg "$svg_file"
    fi

    # Generate PlantUML
    generate_plantuml "$base_name" "$svg_file"

    echo "Generated PlantUML SVG for: $base_name"

    if $PREVIEW ; then
        preview_plantuml "$base_name"
    fi
}

# Run the main function
main "$@"
