---
description: Chạy tự động — Opus lên kế hoạch TOÀN BỘ (plan mode) rồi thực thi tự động (Sonnet code + Haiku việc phụ), qua các cổng của khung. Dùng khi mô tả dự án MỚI hoặc bắt đầu làm trên dự án CÓ SẴN.
---

Bạn vận hành ở chế độ **"Opus lên kế hoạch — chạy tự động"**. Áp dụng khi: người dùng **mô tả một dự án/tính năng mới**, hoặc bắt đầu **làm việc trên một repo có sẵn**.

> Nền model: repo đặt mặc định `opusplan` (`.claude/settings.json`) → **Plan Mode dùng Opus** (lý luận/kiến trúc), **thực thi tự chuyển Sonnet 5** (viết code). Việc tra cứu/xác minh phiên bản giao **subagent Haiku** (`tra-cuu`, `kiem-tra-phien-ban`). Đây là lý do "Opus cao nhất lên kế hoạch rồi chạy tự động" hoạt động mà không phải đổi model tay.

## Bước 1 — LẬP KẾ HOẠCH TOÀN BỘ bằng Opus (trong Plan Mode)
Vào **plan mode** (Opus). Trước khi lập kế hoạch, **nghiên cứu thật** (không bịa):
- **Dự án MỚI (greenfield):** theo `/tu-van` + KHUNG-3 — phân loại loại dự án → chọn hồ sơ → **xác minh phiên bản bằng nguồn sống** (giao subagent `kiem-tra-phien-ban`) → đề xuất stack. Bám 9 giai đoạn KHUNG-1.
- **Dự án CÓ SẴN (brownfield):** theo `AP-DUNG-vao-du-an-co-san.md` — **đọc repo để biết stack thật** (giao subagent `tra-cuu`), KHÔNG áp stack mặc định; đề xuất nâng cấp tăng dần.

Kế hoạch phải bao trùm: mục tiêu & phạm vi (DoR), các giai đoạn/cột mốc, việc chia nhỏ kiểm tra được, rủi ro + cách giảm, tiêu chí chấp nhận + DoD, điểm cần "dừng và hỏi" (CLAUDE.md §9), và **các cổng** giữa giai đoạn.

## Bước 2 — CHỐT KẾ HOẠCH (một cổng phê duyệt)
Trình kế hoạch đầy đủ để người dùng duyệt (ExitPlanMode). Đây là **cổng phê duyệt DUY NHẤT bắt buộc** trước khi chạy — vừa theo Plan Mode của Claude Code, vừa theo cổng giai đoạn của khung. **Không tự thực thi khi chưa được duyệt.**

## Bước 3 — THỰC THI TỰ ĐỘNG (Sonnet + Haiku)
Sau khi duyệt, chạy **tự động** theo kế hoạch, không hỏi lại từng bước:
- **Sonnet 5** viết code theo từng phần nhỏ, hoàn chỉnh, kiểm tra được.
- Giao **subagent Haiku** các việc cơ học: tìm file/định vị (`tra-cuu`), xác minh phiên bản (`kiem-tra-phien-ban`).
- **Tự động chất lượng đã bật:** auto-format khi sửa file, **cổng chặn `git commit` khi đỏ** (`.claude/hooks/`), qua `scripts/dev-task.sh`. Điền `.claude/project-commands.sh` (copy từ `.example.sh`) nếu dự án có lệnh riêng.
- Cập nhật `PROGRESS.md` sau mỗi mốc; commit theo conventional commits.

## Ranh giới tự động (BẮT BUỘC — không vượt)
Chạy tự động **KHÔNG** có nghĩa bỏ cổng. **Vẫn dừng và hỏi** khi (CLAUDE.md §9): yêu cầu mơ hồ nhiều cách hiểu; thao tác không thể hoàn tác (xóa dữ liệu, đổi schema phá vỡ); breaking change lan rộng; nhiều đánh đổi lớn; đụng bảo mật/thanh toán/dữ liệu người dùng thật; **hoặc chuyển sang giai đoạn kế** (tóm tắt đã đạt cổng chưa, xin xác nhận). Ngoài các mốc đó → chạy liền mạch.

> Tóm tắt: **1 kế hoạch tổng (Opus) → 1 lần duyệt → thực thi tự động (Sonnet+Haiku) với auto-format + gate**, chỉ dừng ở các cổng/§9. Đây là mức "tự động" cao nhất vẫn an toàn theo khung.
