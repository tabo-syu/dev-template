#!/usr/bin/env bash
# Claude Code が Go ファイルを編集したあとに gofmt をかける。
# PostToolUse フックとして stdin に JSON を受け取る。
set -euo pipefail

command -v jq >/dev/null || exit 0
command -v gofmt >/dev/null || exit 0

file="$(jq -r '.tool_input.file_path // empty')"

if [[ "$file" == *.go && -f "$file" ]]; then
  gofmt -w "$file"
fi
