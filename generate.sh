#!/bin/sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Accept config file as parameter
NETWORK_YML="${1:-docker-compose.network.yml}"

# Resolve config file path (allow absolute or relative to script dir)
if [ "${NETWORK_YML#/}" != "$NETWORK_YML" ]; then
    NETWORK_YML="$NETWORK_YML"
else
    NETWORK_YML="$SCRIPT_DIR/$NETWORK_YML"
fi

TEMPLATE_FILE="$SCRIPT_DIR/docker-compose.template.yml"
OUTPUT_FILE="$SCRIPT_DIR/docker-compose.yml"

# Check if config.yml exists
if [ ! -f "$NETWORK_YML" ]; then
    echo "Error: network config not found at $NETWORK_YML"
    exit 1
fi

# Check if template exists
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Error: template file not found at $TEMPLATE_FILE"
    exit 1
fi

echo "Generating Grafana composition from $NETWORK_YML and $TEMPLATE_FILE..."

# Extract values from config.yml
if command -v yq >/dev/null 2>&1; then
    NETWORK=$(docker run --rm -v "$SCRIPT_DIR:/data" mikefarah/yq:latest eval '.networks | keys | .[0]' "/data/$(basename "$NETWORK_YML")" 2>/dev/null || echo "common")
fi

echo "Using network: $NETWORK"

# Read template and perform substitutions
template_content=$(cat "$TEMPLATE_FILE")

# Perform substitutions using parameter expansion
output_content="$template_content"
output_content="${output_content//\{\{NETWORK\}\}/$NETWORK}"

# Write output
echo "$output_content" > "$OUTPUT_FILE"
echo ""
echo "Done!"