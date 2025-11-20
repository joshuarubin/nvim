#!/bin/bash

# Get the file path from the Edit tool's file_path parameter
FILE_PATH="$2"

# Only lint Lua files
if [[ ! "$FILE_PATH" =~ \.lua$ ]]; then
  exit 0
fi

# Check if file exists
if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# Use the Makefile lua-lint-hook target
cd "$CLAUDE_PROJECT_DIR" && make lua-lint-hook FILES="$FILE_PATH" 2>&1

exit 0
