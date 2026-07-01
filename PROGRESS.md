# PROGRESS.md — Trạng thái dự án

> Cập nhật sau mỗi mốc đáng kể. AI đọc file này để biết đang ở đâu.

## Giai đoạn hiện tại
- GĐ 7 — Hoàn thiện công cụ/khung (tối ưu cấu hình, hướng dẫn tích hợp)

## Đã xong
- ✅ Tạo cấu hình Opusplan tiêu chuẩn (`.claude/settings-shared-opusplan.json`) — dùng chung cho mọi dự án
- ✅ Cập nhật `copy-framework.sh` để copy cấu hình Opusplan vào `_framework-dropins/`
- ✅ Cập nhật `copy-framework.ps1` tương tự cho Windows
- ✅ Viết hướng dẫn chi tiết (`CONG-CU-OPUSPLAN-CHO-DU-AN.md`) về cách sử dụng & tuỳ chỉnh cấu hình
- ✅ **Copy thẳng:** Cấu hình tự động copy vào `.claude/settings.json` (không cần chọn merge)
- ✅ **Chốt chiến lược tối ưu token:** giữ **opusplan** (Opus lập kế hoạch, Sonnet code, Haiku phụ)
      — KHÔNG dùng Fable 5 thuần (đắt, "dao mổ trâu"); Fable/Opus chỉ nâng có chọn lọc lúc cần
- ✅ Push lên nhánh `claude/opusplan-shared-config-rm5ru6`, PR #19
- ✅ **Thêm subagent Sonnet `thuc-thi`** (`.claude/agents/thuc-thi.md`) — nhận việc RÕ PHẠM VI đã bóc tách
      (viết test theo spec, boilerplate, cập nhật docs, sửa cơ học nhiều file) để rút tải khỏi main Opus.
      Đồng bộ mô tả trong CHON-MODEL, TU-DONG-tong-quan, CONG-CU-OPUSPLAN, copy-framework.sh/.ps1, /tu-dong.

- ✅ **Gộp 3 doc model/tự động → 1** (`docs/framework/MODEL-va-TU-DONG.md`): gộp CHON-MODEL +
      CONG-CU-OPUSPLAN + TU-DONG-tong-quan, khử trùng lặp (594→~360 dòng, −2 file). Cập nhật mọi
      tham chiếu: CLAUDE.md, `/adr` `/su-co` `/tu-van` `/tu-dong`, session-guide.sh.
- ✅ **Quyết định giữ scaffold web** (Next.js+Supabase) làm hồ sơ mặc định — không tách/xóa.
- ✅ PR #21 đã merge vào `main` (`main` = branch, 0/0).
- ✅ **Codify quy trình PR → merge tự động** vào CLAUDE.md §8: sau khi tạo PR thì đăng ký theo dõi + đặt lịch 3 phút, CI xanh thì squash-merge vào `main`, luôn quay về `main`, **FIFO không nhảy cóc** (PR tạo trước merge trước).
- ✅ **Thêm tính năng audit toàn diện** (`/audit-toan-dien`, khác `/audit-toi-uu` chỉ tối ưu mã nguồn):
      - `docs/ops/audit-toan-dien-prompt.md` — playbook 11 nhóm (kiến trúc, bảo mật, chất lượng mã/
        chống lỗi logic, test/coverage, hiệu năng, a11y/UI-UX, dependency, CI/CD/vận hành, tài liệu
        đồng bộ, dữ liệu/migration, cấu hình & bí mật), quy trình 2 giai đoạn (quét → dừng chờ duyệt
        → xử lý qua `/cong`).
      - `.claude/commands/audit-toan-dien.md` — slash command, có bước bắt buộc hỏi người dùng
        "quét lại từ đầu hay tiếp tục" dựa vào `docs/ops/AUDIT-TOAN-DIEN-TRANG-THAI.md` (file trạng
        thái tạo tại dự án đích, cập nhật ngay sau mỗi nhóm để resume được qua nhiều phiên).
      - Cập nhật `CLAUDE.md` §1 (TRIGGER mới), `copy-framework.sh`/`.ps1` (liệt kê lệnh mới khi copy khung).

## Đang làm
- (xong)

## Tiếp theo
- Mở PR cho nhánh `claude/project-audit-feature-2jyw07`, theo dõi CI, merge khi xanh.

## Quyết định quan trọng (trỏ tới ADR nếu có)
- Cấu hình Opusplan được thêm vào `_framework-dropins/` (an toàn, không đè cấu hình cũ)
- `.claude/` (hooks + agents) cũng được copy vào `_framework-dropins/` để dự án cũ tự merge nếu cần
- **opusplan là điểm ngọt, không đổi**; tối ưu token thêm bằng CHIA VIỆC (subagent) chứ không "route theo độ khó"
  (Claude Code không có bộ định tuyến model per-query). `thuc-thi` cùng Sonnet với pha-code opusplan —
  lợi ích là **cô lập ngữ cảnh + song song**, không phải model rẻ hơn.

## Nợ kỹ thuật (chỗ "làm tạm" cần quay lại)
- (không có)

## Bàn giao phiên (điền khi WIND-DOWN gần chạm limit 5h — để phiên sau "tiếp tục")
> Chế độ tự động ghi ở đây trước khi dừng: việc vừa xong, việc DỞ ở đâu, bước kế tiếp cụ thể.
- Lần cập nhật: 2026-07-01
- Việc DỞ / bước tiếp theo: Commit tất cả thay đổi & push lên nhánh `claude/opusplan-shared-config-rm5ru6`
- Cần lưu ý khi chạy tiếp: Doc model/tự động nay gộp ở `docs/framework/MODEL-va-TU-DONG.md` (thay 3 file cũ). Subagent Sonnet: `.claude/agents/thuc-thi.md`.
