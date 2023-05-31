#!/bin/bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

test "${DEBUG:-}" && set -x

PLANTUML_DIR="$(dirname "$DIR")/plantuml"

function command_exists {
    type "$1" &> /dev/null
}

function generate_plantuml() {
    local sprite_name="$1"
    local sprite_file="$PLANTUML_DIR/${sprite_name}.puml"
    local sprite_contents=$(grep -v -e '@startuml' -e '@enduml' "$sprite_file")

    cat << EOF 
@startuml
${sprite_contents}

rectangle "<\$${sprite_name}> <color:white>${sprite_name} black</color>" as black #000000
rectangle "<\$${sprite_name}> ${sprite_name} gray" as gray #e6e6e6
rectangle "<\$${sprite_name}> ${sprite_name} white" as white #ffffff

black -down-> gray
gray -down-> white

@enduml
EOF
}

function preview_plantuml() {
    local sprite_name="$1"
    local output_file="$(mktemp -t plantuml_${sprite_name}).svg"

    # Generate the diagram using PlantUML
    generate_plantuml "$sprite_name" | plantuml -svg -pipe > "$output_file"

    # Open the generated SVG in a web browser
    open "$output_file"
}

function main {
    local STDOUT=false
    
    while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
            --stdout)
            STDOUT=true
            shift
            ;;
            *)
            break
            ;;
        esac
    done

    if [[ $# -ne 1 ]]; then
        echo "Usage: $0 [--stdout] <sprite_name>"
        exit 1
    fi

    local sprite_name="$1"

    if $STDOUT ; then
        generate_plantuml "$sprite_name"
    else
        if ! command_exists plantuml ; then
            echo "PlantUML is not installed, run the command with --stdout option to output PlantUML contents."
            exit 1
        fi

        preview_plantuml "$sprite_name"
    fi
}

main "$@"
