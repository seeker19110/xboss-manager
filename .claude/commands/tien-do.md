---
description: Theo dõi tiến độ — cập nhật PROGRESS.md (giai đoạn, đã xong/đang làm/tiếp theo, quyết định, nợ kỹ thuật) và kiểm cổng trước khi chuyển giai đoạn
---

Giữ **`PROGRESS.md` luôn phản ánh đúng trạng thái dự án** và **kiểm cổng giữa các giai đoạn** trước khi chuyển bước (CLAUDE.md §2; KHUNG-1 — 9 giai đoạn + cổng).

> Dùng đầu mỗi phiên (nêu đang ở đâu, làm gì tiếp) và sau mỗi mốc. Không bỏ giai đoạn; chuyển giai đoạn phải **đạt cổng + xin xác nhận người dùng**.

## Bước 1 — Đọc trạng thái thật (không đoán)
Đọc `PROGRESS.md` + `PROJECT.md` (mục 0 hồ sơ, MVP, DoD) + lịch sử git gần đây + `TODO`/nợ kỹ thuật. Suy ra **giai đoạn hiện tại** đúng thực tế (greenfield thường GĐ 0–4; brownfield thường GĐ 4–5 hoặc GĐ 8).

## Bước 2 — Cập nhật `PROGRESS.md`
Giữ các mục: **Giai đoạn hiện tại** · **Đã xong** · **Đang làm** · **Tiếp theo** · **Quyết định quan trọng** (trỏ ADR) · **Nợ kỹ thuật** (chỗ "làm tạm" cần quay lại). Viết ngắn, có thể kiểm chứng; cập nhật sau mỗi mốc.

## Bước 3 — Kiểm cổng giai đoạn (KHUNG-1, theo hồ sơ)
Đối chiếu cổng của giai đoạn đang ở (cổng đặc thù theo hồ sơ — KHUNG-3 PHẦN C). Ví dụ: GĐ 1 → tiêu chí chấp nhận + DoD (`/ke-hoach`); GĐ 3 → hàng rào chặn được lỗi (`/khoi-tao`); GĐ 5 → test xanh (`/kiem-thu`); GĐ 6–7 → cổng CI/CD + checklist ra mắt (`/trien-khai`). Nêu rõ **đã đạt / còn thiếu gì**.

## Bước 4 — Đề xuất việc tiếp theo + chuyển giai đoạn
Chia nhỏ việc kế tiếp (mỗi phần hoàn chỉnh, kiểm tra được). **Chủ động góp ý** rủi ro/cách tốt hơn/phạm vi phình (CLAUDE.md §2). Nếu đủ điều kiện sang giai đoạn mới → **tóm tắt đã đạt cổng & xin xác nhận** trước khi chuyển.

Bắt đầu: chạy **Bước 1 — đọc trạng thái thật**, rồi cập nhật `PROGRESS.md` và báo cổng.
