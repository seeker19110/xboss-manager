#!/usr/bin/env bash
# report-status.sh — SessionStart hook.
# BÁO CÁO trạng thái cấu hình model mỗi khi mở phiên và ÉP dùng opusplan.
#   • Đọc trường "model" từ stdin (SessionStart payload) + cấu hình THẬT trong
#     .claude/settings.json (model / fallbackModel / effortLevel / alwaysThinkingEnabled).
#   • opusplan            → ✅ xác nhận, in tóm tắt cấu hình (systemMessage).
#   • KHÁC / không đọc được → ⚠️ cảnh báo + additionalContext YÊU CẦU AI CHỦ ĐỘNG
#     nhắc /model opusplan rồi KIỂM TRA lại ("luôn kiểm tra và chỉnh lại").
# GIỚI HẠN THẬT: hook/AI KHÔNG tự gõ /model được — chỉ đặt mặc định (settings) +
#   kiểm tra & hướng dẫn sửa mỗi phiên. Chỉ ĐỌC, không đổi gì.
# No-op nếu thiếu jq hoặc không phải dự án dùng khung này.
set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
command -v jq >/dev/null 2>&1 || exit 0

# Marker: chỉ chạy trong dự án áp dụng khung này.
[ -d "$ROOT/docs/framework" ] || [ -f "$ROOT/.claude/commands/auto.md" ] || exit 0

# Cấu hình THẬT đang khai báo trong settings.json (để đối chiếu với model phiên).
settings="$ROOT/.claude/settings.json"
cfg_model="?"; cfg_fb=""; cfg_effort="?"; cfg_think="?"
if [ -f "$settings" ]; then
  cfg_model="$(jq -r '.model // "?"' "$settings" 2>/dev/null || echo '?')"
  cfg_fb="$(jq -r '(.fallbackModel // []) | join(", ")' "$settings" 2>/dev/null || echo '')"
  cfg_effort="$(jq -r '.effortLevel // "?"' "$settings" 2>/dev/null || echo '?')"
  cfg_think="$(jq -r 'if has("alwaysThinkingEnabled") then (.alwaysThinkingEnabled|tostring) else "?" end' "$settings" 2>/dev/null || echo '?')"
fi
cfg_line="📊 Cấu hình (.claude/settings.json): model=${cfg_model} · fallback=[${cfg_fb}] · effort=${cfg_effort} · thinking=${cfg_think}"

# Model phiên (SessionStart stdin có trường "model"; không phải lúc nào cũng có).
payload="$(cat 2>/dev/null || true)"
model_id="$(printf '%s' "$payload" | jq -r '.model // empty' 2>/dev/null || true)"

case "$model_id" in
  *opusplan*)
    msg="${cfg_line}
✅ Model phiên: opusplan — đúng (Opus lập kế hoạch → Sonnet viết code)."
    actx="" ;;
  "")
    msg="${cfg_line}
🔎 Model phiên: CHƯA đọc được → KIỂM TRA bằng /model (cần thấy opusplan). Nếu chưa phải: /model opusplan."
    actx="report-status: không đọc được model phiên. LUÔN kiểm tra đầu phiên — chủ động nhắc người dùng gõ /model để xác nhận opusplan; nếu chưa phải, hướng dẫn /model opusplan rồi kiểm tra lại. Hook/AI không tự gõ /model được." ;;
  *)
    msg="${cfg_line}
⚠️ Model phiên = ${model_id} — KHÔNG phải opusplan. SỬA NGAY: /model opusplan rồi kiểm tra lại (/model)."
    actx="report-status: model phiên='${model_id}' KHÁC opusplan (cấu hình repo là opusplan). LUÔN tự động chỉnh: chủ động nhắc người dùng gõ /model opusplan NGAY, CHỜ họ xác nhận đã chuyển, rồi mới tiếp tục. Hook/AI không tự gõ /model được. Nếu người dùng cố ý giữ model khác, tôn trọng nhưng nêu rõ đánh đổi (Opus thuần tốn quota Pro; Sonnet/Haiku thuần mất pha Opus lập kế hoạch)." ;;
esac

if [ -n "$actx" ]; then
  jq -n --arg m "$msg" --arg c "$actx" \
    '{systemMessage:$m, hookSpecificOutput:{hookEventName:"SessionStart", additionalContext:$c}}'
else
  jq -n --arg m "$msg" '{systemMessage:$m}'
fi
exit 0
