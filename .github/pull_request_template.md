<!--
Checklist này hiện trên MỌI Pull Request → biến "cổng chất lượng" thành thứ
buộc phải nhìn thấy trước khi merge. Tích đầy đủ trước khi yêu cầu review.
Nội dung bám theo Definition of Done (KHUNG-1) + cổng commit/merge (KHUNG-2).
-->

## Mô tả

<!-- Thay đổi gì? TẠI SAO cần thay đổi? Liên kết tới issue/task nếu có. -->

## Loại thay đổi

- [ ] `feat` — tính năng mới
- [ ] `fix` — sửa lỗi
- [ ] `refactor` — cải tổ, không đổi hành vi
- [ ] `docs` / `test` / `chore` / `style` / `perf`
- [ ] ⚠️ Breaking change (mô tả ảnh hưởng & cách di trú bên dưới)

## Cổng chất lượng (Definition of Done)

- [ ] Chạy đúng **tiêu chí chấp nhận** của tính năng (đối chiếu `PROJECT.md`)
- [ ] `lint` 0 cảnh báo · `type-check` sạch · `format:check` đạt · `build` OK
- [ ] Có **test** cho logic quan trọng và **toàn bộ test xanh**
- [ ] Xử lý đủ trạng thái **lỗi / rỗng / đang tải** trên UI
- [ ] Chạy được trên **điện thoại lẫn máy tính** (responsive)
- [ ] Không còn **bí mật** hay **code rác** (console.log debug, code chết)
- [ ] Đã **tự review diff** một lượt (đúng mục tiêu, không sửa nhầm)

## Bảo mật & dữ liệu

- [ ] Mọi đầu vào (người dùng/API) được **validate lúc chạy**
- [ ] Logic nhạy cảm (kiểm tra quyền, tính toán quan trọng) ở **phía server**
- [ ] Nếu đổi schema: có **migration có phiên bản** và **đường rollback**; RLS đã test

## Ảnh hưởng & rủi ro

<!-- Phần hệ thống nào bị ảnh hưởng? Có phá vỡ tính năng khác không?
     Đã smoke test luồng chính trên Preview chưa? Góp ý cải tiến (nếu có). -->
