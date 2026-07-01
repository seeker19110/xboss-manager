#!/usr/bin/env bash
# auto-format.sh — PostToolUse hook (matcher: Edit|Write).
# Sau khi Claude sửa/tạo file, tự format ĐÚNG file đó qua scripts/dev-task.sh format-file.
# No-op an toàn khi dự án chưa có per-file formatter. Luôn exit 0 (không cản luồng).
#
# An toàn đa-loại-dự-án: không chứa lệnh stack; mọi lệnh nằm sau dev-task.sh.
set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"

payload="$(cat)"
path=""
if command -v jq >/dev/null 2>&1; then
  path="$(printf '%s' "$payload" | jq -r '.tool_input.file_path // empty' 2>/dev/null)"
fi

[ -n "$path" ] || exit 0
[ -x "$ROOT/scripts/dev-task.sh" ] || exit 0

"$ROOT/scripts/dev-task.sh" format-file "$path" >/dev/null 2>&1 || true
exit 0
