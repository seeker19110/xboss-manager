---
description: Migration CSDL có kỷ luật — đổi schema qua migration có phiên bản, rollback được; thao tác phá vỡ → dừng & hỏi
---

Dẫn dắt **thay đổi schema cơ sở dữ liệu một cách an toàn**: mọi thay đổi đi qua **migration có phiên bản** và **rollback được** (KHUNG-1 GĐ 2 & GĐ 6; `BO-SUNG-chat-luong.md` Nhóm 1 mục 2; CLAUDE.md §6/§9).

> Chỉ áp cho hồ sơ **có CSDL** (web/backend/data…). AI **tự dò công cụ migration thật** từ repo (chống ảo giác): `supabase/migrations/`, `prisma/`, `drizzle*`, Alembic, `sqlc`, hay SQL tay — **không giả định Supabase**. Lệnh cụ thể của Supabase chỉ là ví dụ; stack khác dùng tương đương.

## Bước 0 — Dò công cụ + đọc schema hiện tại
Xác định ORM/công cụ migration đang dùng + thư mục migration + cách chạy/rollback. Đọc schema hiện tại (file thật) để không phá quan hệ/ràng buộc sẵn có.

## Bước 1 — Thiết kế thay đổi (KHUNG-1 GĐ 2)
Ràng buộc đầy đủ (`NOT NULL`, `UNIQUE`, kiểu chặt, khóa ngoại + `ON DELETE`) · index cho cột hay lọc/sắp xếp/join · thời gian **UTC** · tiền **không float** · kiểm soát truy cập (RLS/ACL) cho bảng mới. Nêu rõ thay đổi **có phá vỡ** không (xóa/đổi tên cột, đổi kiểu, NOT NULL trên bảng có dữ liệu).

## Bước 2 — DỪNG & HỎI nếu phá vỡ / khó hoàn tác (CLAUDE.md §9)
Xóa/đổi tên cột-bảng, đổi kiểu mất dữ liệu, thêm NOT NULL không default trên bảng đang chạy → **không tự ý chạy**. Đề xuất phương án **an toàn nhiều bước** (expand → migrate dữ liệu → contract) và xin xác nhận.

## Bước 3 — Viết migration tiến + lùi
- **Forward**: tạo file migration **có dấu thời gian/phiên bản**; thay đổi tối thiểu, một mục đích.
- **Backward (rollback)**: migration bù trừ hoặc kế hoạch khôi phục rõ ràng. Dữ liệu lớn → cân nhắc backfill theo lô.
- Dự án đang chạy áp kỷ luật lần đầu → **baseline schema hiện tại thành migration đầu** rồi mới thêm thay đổi mới.

## Bước 4 — Thử trên môi trường an toàn (KHÔNG dữ liệu thật)
Chạy forward **rồi** backward trên dev/staging (vd Vercel Preview → CSDL staging) để xác nhận **cả hai chiều chạy được**. Kiểm tra dữ liệu mẫu còn đúng. Tách môi trường dev/staging/prod.

## Bước 5 — Cập nhật mã & commit cùng nhau
Cập nhật type/model/validate (Zod…) khớp schema mới · commit migration + thay đổi mã **chung một PR** · trước commit/merge chạy `/cong` · ghi quyết định lớn vào `/adr`. Lên production → đi qua `/trien-khai` (backup đã thử khôi phục, rollback sẵn sàng).

Bắt đầu: chạy **Bước 0 — dò công cụ migration & đọc schema hiện tại** từ repo.
