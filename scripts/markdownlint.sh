#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
exec markdownlint-cli2 "$@"
