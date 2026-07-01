#!/usr/bin/env bash
# session-guide.sh — SessionStart hook.
# HIỆN cho NGƯỜI DÙNG (systemMessage) gợi ý "nên làm gì tiếp theo" khi mở phiên,
# CHỈ trong dự án dùng khung/template này. Tự nhận biết trạng thái để gợi ý đúng:
#   • Chưa có tiến độ  → hướng bắt đầu (mô tả ý tưởng / /tu-van / /khoi-tao / /tu-dong)
#   • Đang làm dở      → hướng tiếp tục ('tiếp tục' / /tu-dong / /cong)
# Không đổi gì (chỉ đọc). No-op nếu thiếu jq hoặc không phải dự án của khung.
set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
command -v jq >/dev/null 2>&1 || exit 0

# Marker: chỉ chạy trong dự án áp dụng khung này.
[ -d "$ROOT/docs/framework" ] || [ -f "$ROOT/.claude/commands/tu-dong.md" ] || exit 0

# Trích "Giai đoạn hiện tại" thật (bỏ dòng rỗng và placeholder "(vd").
phase=""
if [ -f "$ROOT/PROGRESS.md" ]; then
  phase="$(awk '/## Giai đoạn hiện tại/{f=1;next} /^## /{f=0} f' "$ROOT/PROGRESS.md" \
           | sed 's/^[[:space:]]*-[[:space:]]*//' \
           | grep -v '^[[:space:]]*$' | grep -v '(vd' | head -1)"
fi

# Có thay đổi chưa commit? → coi như đang làm dở.
dirty=""
if command -v git >/dev/null 2>&1 && git -C "$ROOT" rev-parse --git-dir >/dev/null 2>&1; then
  dirty="$(git -C "$ROOT" status --short 2>/dev/null | head -1)"
fi

if [ -z "$phase" ] && [ -z "$dirty" ]; then
  msg="🧭 Dự án dùng KHUNG (template). Chưa có tiến độ ghi nhận.
Bắt đầu thế nào:
• Mô tả ý tưởng/yêu cầu dự án — hoặc gõ /tu-van (chọn công nghệ, research-first)
• /khoi-tao (dựng nền dự án mới)  •  /tu-dong (Opus lập kế hoạch → chạy tự động)
• Bản đồ chế độ tự động: docs/framework/TU-DONG-tong-quan.md"
else
  extra=""
  [ -n "$phase" ] && extra=" — GĐ hiện tại: ${phase}"
  [ -n "$dirty" ] && extra="${extra} (có thay đổi chưa commit)"
  msg="🧭 Dự án dùng KHUNG${extra}.
Tiếp theo nên:
• Gõ 'tiếp tục' để nối việc dở (PROGRESS.md đã được nạp) — xem mục 'Đang làm'/'Tiếp theo'/'Bàn giao phiên'
• /tu-dong để tự động điều phối  •  /cong trước khi commit  •  /su-co nếu có sự cố"
fi

jq -n --arg m "$msg" '{systemMessage:$m}'
exit 0
