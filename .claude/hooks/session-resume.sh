#!/usr/bin/env bash
# session-resume.sh — SessionStart hook.
# Nạp trạng thái phiên trước vào ngữ cảnh để người dùng chỉ cần nhắn "tiếp tục":
# PROGRESS.md (giai đoạn/đang làm/tiếp theo/bàn giao) + tóm tắt git (branch, chưa
# commit, commit gần nhất). Chỉ ĐỌC, không đổi gì. No-op nếu thiếu jq/không có dữ liệu.
set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
command -v jq >/dev/null 2>&1 || exit 0

ctx="$(
  if [ -f "$ROOT/PROGRESS.md" ]; then
    echo "===== PROGRESS.md (trạng thái phiên trước — nguồn để 'tiếp tục') ====="
    cat "$ROOT/PROGRESS.md"
    echo
  fi
  if command -v git >/dev/null 2>&1 && git -C "$ROOT" rev-parse --git-dir >/dev/null 2>&1; then
    echo "===== Git ====="
    echo "Branch: $(git -C "$ROOT" branch --show-current 2>/dev/null)"
    echo "-- Thay đổi chưa commit --"; git -C "$ROOT" status --short 2>/dev/null
    echo "-- 5 commit gần nhất --";   git -C "$ROOT" log --oneline -5 2>/dev/null
  fi
)"

[ -n "${ctx// /}" ] || exit 0

jq -n --arg c "$ctx" '{
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: ("Trạng thái để tiếp tục công việc dở (khi người dùng nhắn \"tiếp tục\", nối tiếp mục \"Đang làm\"/\"Tiếp theo\"/\"Bàn giao\"):\n\n" + $c)
  }
}'
