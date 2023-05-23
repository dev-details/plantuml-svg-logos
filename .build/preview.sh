#!/bin/bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PLANTUML_DIR="$(dirname "$DIR")/plantuml"

# Check if the required dependencies are installed
command -v plantuml >/dev/null 2>&1 || { echo >&2 "PlantUML is required but not installed. Aborting."; exit 1; }

# Function to generate and display the PlantUML diagram
function preview_plantuml() {
    local sprite_name="$1"
    local output_file="$(mktemp -t plantuml_${sprite_name}).svg"
    local sprite_file="$PLANTUML_DIR/${sprite_name}.puml"

    # Generate the diagram using PlantUML
    cat << EOF | plantuml -svg -pipe > "$output_file"
@startuml
!include ${sprite_file}
rectangle "<\$${sprite_name}> <color:white>${sprite_name} black</color>" as black #000000
rectangle "<\$${sprite_name}> ${sprite_name} gray" as gray #e6e6e6
rectangle "<\$${sprite_name}> ${sprite_name} white" as white #ffffff

black -down-> gray
gray -down-> white

@enduml
EOF

    # Open the generated SVG in a web browser
    open "$output_file"
}

# Check if a sprite name was provided as an argument
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <sprite_name>"
    exit 1
fi

# Set the sprite name
sprite_name="$1"

# Preview the PlantUML diagram
preview_plantuml "$sprite_name"
