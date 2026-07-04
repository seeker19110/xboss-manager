#!/usr/bin/env bash
# pre-commit-gate.sh — PreToolUse hook (matcher: Bash).
# Khi Claude định chạy `git commit`, chạy cổng chất lượng (build/typecheck/lint/test)
# qua scripts/dev-task.sh. Cổng ĐỎ → exit 2 để CHẶN commit (đồng bộ CLAUDE.md §5).
# Cổng no-op (dự án chưa cấu hình lệnh) → exit 0, cho commit chạy bình thường.
#
# An toàn đa-loại-dự-án: hook KHÔNG chứa lệnh stack nào; mọi lệnh nằm sau dev-task.sh.
set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"

# Đọc payload hook từ stdin, lấy lệnh Bash sắp chạy.
payload="$(cat)"
cmd=""
if command -v jq >/dev/null 2>&1; then
  cmd="$(printf '%s' "$payload" | jq -r '.tool_input.command // empty' 2>/dev/null)"
else
  # Fallback thô: tìm chuỗi "command" trong JSON.
  cmd="$payload"
fi

# Chỉ can thiệp khi thực sự là `git commit` (bỏ qua commit-tree, --help…).
if ! printf '%s' "$cmd" | grep -Eq '(^|[^-])git[[:space:]]+([^|&;]*[[:space:]])?commit([[:space:]]|$)'; then
  exit 0
fi

# Người dùng chủ động bỏ qua cổng?
if printf '%s' "$cmd" | grep -Eq '(--no-verify|-n[[:space:]]|--no-gate)'; then
  echo "[pre-commit-gate] phát hiện --no-verify → bỏ qua cổng." >&2
  exit 0
fi

if [ ! -x "$ROOT/scripts/dev-task.sh" ]; then
  # Không có dispatcher → không chặn (an toàn), chỉ nhắc.
  echo "[pre-commit-gate] không thấy scripts/dev-task.sh → bỏ qua cổng." >&2
  exit 0
fi

if ! "$ROOT/scripts/dev-task.sh" gate; then
  echo "❌ Cổng trước commit ĐỎ (build/typecheck/lint/test). Sửa hết rồi commit lại (CLAUDE.md §5)." >&2
  echo "   Bỏ qua có chủ đích: thêm --no-verify vào lệnh git commit." >&2
  exit 2
fi

# Cổng máy móc (build/lint/test) chỉ bắt lỗi CÚ PHÁP, không bắt lỗi LOGIC/trùng lặp/hiệu năng —
# đúng việc Sonnet làm tốt qua skill /code-review, /simplify. Nudge (không chặn) khi diff staged đủ lớn.
lines_changed="$(git -C "$ROOT" diff --cached --numstat -- 2>/dev/null | awk '{a+=$1; d+=$2} END{print a+d+0}')"
files_changed="$(git -C "$ROOT" diff --cached --name-only -- 2>/dev/null | grep -c . || true)"
if [ "${lines_changed:-0}" -ge 80 ] || [ "${files_changed:-0}" -ge 5 ]; then
  echo "💡 Diff staged khá lớn (${files_changed} file, ~${lines_changed} dòng đổi). Cổng máy móc chỉ bắt lỗi cú pháp — cân nhắc chạy /code-review (hoặc /simplify) trước khi commit để bắt lỗi logic/trùng lặp/hiệu năng." >&2
fi

exit 0
