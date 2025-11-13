#!/bin/bash

# ================================
# Prettier Batch Formatter Script
# ================================
# Formats JSON, Markdown, and SVG files recursively
# Usage:
#   ./format-files.sh [directory] [--check]
#
# Example:
#   ./format-files.sh ./src           # formats files
#   ./format-files.sh ./docs --check  # only checks formatting
#
# Requirements:
#   - Node.js + npm (for npx)
#   - Prettier (installed locally or globally)
# ================================

set -e  # Stop script on any error

# Colors for prettier output
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
RESET="\033[0m"

# Parse arguments
TARGET_DIR="${1:-.}"
MODE="--write"
if [[ "$2" == "--check" ]]; then
  MODE="--check"
  echo -e "${YELLOW}Running in CHECK mode — no files will be modified.${RESET}"
fi

echo -e "${GREEN}Formatting files in:${RESET} $TARGET_DIR"
echo "----------------------------------------"

# Check for npx
if ! command -v npx &> /dev/null; then
  echo -e "${RED}Error:${RESET} npx not found. Please install Node.js and npm."
  exit 1
fi

# Check for Prettier
if ! npx prettier --version &> /dev/null; then
  echo -e "${RED}Error:${RESET} Prettier not installed. Run: npm install --save-dev prettier"
  exit 1
fi

# Function to format files by extension
format_files() {
  local EXT=$1
  local PARSER=$2
  local LABEL=$3

  echo "----------------------------------------"
  echo -e "${YELLOW}Formatting $LABEL files...${RESET}"

  # Use find + xargs for efficiency and to handle spaces in filenames
  FILES=$(find "$TARGET_DIR" -type f -name "$EXT" ! -path "*/node_modules/*" ! -path "*/.git/*")
  if [[ -z "$FILES" ]]; then
    echo "No $LABEL files found."
    return
  fi

  echo "$FILES" | xargs -r npx prettier $MODE ${PARSER:+--parser "$PARSER"}
}

# Format JSON, Markdown, and SVG files
format_files "*.json" "" "JSON"
format_files "*.md" "" "Markdown"
format_files "*.svg" "html" "SVG"

echo "----------------------------------------"
echo -e "${GREEN}✓ All formatting operations complete!${RESET}"
