#!/usr/bin/env bash
# Sign all treesitter parsers to prevent macOS code signature issues
# Run this after plugin updates that rebuild parsers

set -euo pipefail

# Only run on macOS
if [[ "$(uname -s)" != "Darwin" ]]; then
	exit 0
fi

parser_dir="$HOME/.local/share/nvim/site/parser"

if [[ ! -d "$parser_dir" ]]; then
	echo "Parser directory not found: $parser_dir"
	exit 0
fi

echo "Signing treesitter parsers in $parser_dir..."
for parser in "$parser_dir"/*.so; do
	if [[ -f "$parser" ]]; then
		codesign --force --sign - "$parser" 2>&1 | grep -v "replacing existing signature" || true
	fi
done

echo "All parsers signed successfully"
