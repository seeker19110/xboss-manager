# Checklist triển khai trên DỰ ÁN THẬT (những việc template không đóng gói sẵn được)

> **File ghi chú để bổ sung sau.** Template chứa sẵn *quy trình + cấu hình mẫu*, nhưng có những thứ
> **chỉ tồn tại khi đã có dự án thật** (mã nguồn thật, repo settings, tài khoản dịch vụ, bí mật, lựa chọn
> nhà cung cấp). Tài liệu này gom hết lại thành một chỗ — đi từ trên xuống, tick dần.
>
> Đây **không phải lỗ hổng của template** mà là phần "điền vào chỗ trống" theo từng dự án. Mỗi mục ghi rõ
> *mở khóa cái gì* (file/cổng nào trong khung sẽ hoạt động sau khi làm) và *xem chi tiết ở đâu*.

---

## 1. Tạo bộ mã nguồn thật (mở khóa toàn bộ CI)

- [ ] `npx create-next-app@latest` (TypeScript + Tailwind + ESLint) → sinh `package.json`, `tsconfig.json`, `next.config.ts`.
- [ ] Gộp `MERGE-vao-package.json.md`: cài gói + thêm khối `scripts` + `npx husky init` (rồi copy đè 2 hook `.husky/*`).
- [ ] Gộp `MERGE-vao-tsconfig.json.md`: thêm các cờ `strict` (`noUncheckedIndexedAccess`...).
- [ ] Nối theme vào `app/globals.css` + `app/layout.tsx` (script no-flash) — xem `BO-SUNG-giao-dien-theme.md`.

> **Mở khóa:** mọi job CI hiện đang *tự bỏ qua khi chưa có `package.json`* (quality/e2e/lighthouse/codeql/release)
> sẽ tự kích hoạt. Sau bước này, xóa step guard `package.json` nếu muốn CI luôn chạy đầy đủ.

## 2. Xác minh lại công nghệ & phiên bản (research-first)

- [ ] **Xác minh lại phiên bản** từng gói bằng nguồn sống tại thời điểm khởi tạo (KHUNG 3, PHẦN B/B4) —
      bản ghi trong khung là ảnh chụp **2026-06-29**, sẽ lỗi thời.
- [ ] Ghi `PROJECT.md` mục 4: mỗi lựa chọn + **phiên bản + ngày xác minh** + 1 câu lý do; ghi **ADR** cho quyết định lớn.

## 3. Điền đặc tả & luật cho dự án

- [ ] `PROJECT.md`: điền đủ 10 mục (vấn đề, MVP+tiêu chí chấp nhận, phi chức năng, schema, API, DoD, rủi ro).
- [ ] `CLAUDE.md`: thay **mọi** chỗ `[ĐIỀN: ...]` (stack, lệnh, cấu trúc, quy ước). *CI sẽ fail nếu còn `[ĐIỀN]`.*
- [ ] `PROGRESS.md`: ghi giai đoạn hiện tại + việc tiếp theo.
- [ ] `LICENSE` + `.github/CODEOWNERS`: đổi `seeker19110`/MIT thành chủ sở hữu & giấy phép thật của dự án.

## 4. Cấu hình GitHub repository (Settings — không đóng gói được trong code)

- [ ] **Branch protection** cho `main` (KHOI-TAO Bước 6 / HUONG-DAN Bước 11): yêu cầu PR + status checks xanh +
      nhánh cập nhật + review từ Code Owners. Chọn các check bắt buộc: `quality`, `e2e`, `lighthouse`,
      `analyze` (CodeQL), `gitleaks`.
- [ ] **Code scanning**: Settings → Code security & analysis → bật (CodeQL cần để upload kết quả; nếu không
      job sẽ lỗi "Code scanning is not enabled"). Public: miễn phí · Private: cần GitHub Advanced Security.
- [ ] **Dependabot alerts** + **security updates**: bật trong Code security (file `dependabot.yml` đã có sẵn).
- [ ] **Secret scanning** (GitHub native) — bật nếu repo hỗ trợ (bổ trợ cho gitleaks).

## 5. Bí mật & biến môi trường (KHÔNG commit — đặt qua dashboard)

- [ ] **GitHub Actions secrets** (dùng bởi `lighthouse-ci.yml`, job `e2e`): `NEXT_PUBLIC_SUPABASE_URL`,
      `NEXT_PUBLIC_SUPABASE_ANON_KEY` (+ biến build khác nếu có).
- [ ] **Vercel env**: đặt riêng cho **Production** và **Preview**; Preview trỏ Supabase "staging".
- [ ] `.env.local` (local, đã bị `.gitignore` chặn): copy từ `.env.example`, điền giá trị thật.
- [ ] Đổi tên biến trong `lib/env.ts` cho khớp dự án; thêm bí mật mới vào `serverSchema`.

## 6. Cơ sở dữ liệu — Supabase (mở khóa RLS + migration thật)

- [ ] `npx supabase init` → `link --project-ref <ref>`; commit `supabase/` (gồm `config.toml`).
- [ ] Thay migration **mẫu** (`supabase/migrations/...init_example.sql`) bằng **schema thật**.
- [ ] **Bật & test RLS** trước khi mở cho người ngoài.
- [ ] **Backup tự động** đã bật và **đã thử khôi phục một lần** (BO-SUNG Nhóm 1 mục 2).

## 7. Hosting & triển khai — Vercel

- [ ] Kết nối repo với Vercel; xác nhận build + deploy "Hello World" OK.
- [ ] Mỗi PR tự sinh **Preview** (= staging miễn phí); chỉ `main` deploy production.

## 8. Quan sát & ra mắt (GĐ 6–7)

- [ ] **Sentry**: chạy `npx @sentry/wizard@latest -i nextjs`; đặt `SENTRY_DSN` qua env; bật cảnh báo
      (BO-SUNG-nang-cao mục 3).
- [ ] **Analytics**: chọn nhà cung cấp theo nhu cầu (BO-SUNG-nang-cao mục 7) + đặt khóa qua env.
- [ ] **release-please**: lần merge đầu vào `main` sẽ mở "release PR"; merge nó để cắt phiên bản + CHANGELOG.
- [ ] Checklist ra mắt GĐ 7 (KHUNG 1): privacy/terms, SEO meta/OG, trang lỗi, onboarding, kênh phản hồi.

## 9. Kiểm thử thật

- [ ] Thay `e2e/smoke.spec.ts` bằng **luồng chính thật** (đăng nhập → thao tác lõi → đạt mục tiêu).
- [ ] Viết unit test cho logic quan trọng + ca biên; giữ coverage ≥ ngưỡng (`vitest.config.ts`).

## 10. Kiểm chứng hàng rào (cổng "sẵn sàng phát triển")

- [ ] Thử commit message sai chuẩn → **bị chặn**; thêm code sai kiểu rồi commit → **bị chặn**.
- [ ] Tạo PR thử → CI chạy; khi đỏ thì **không merge được**.
- [ ] Đối chiếu **Phần C** của `KHOI-TAO-du-an-moi.md` — đạt đủ mới bắt đầu code tính năng.

---

> Với **dự án đã có sẵn** (brownfield), không làm tuần tự như trên mà áp tăng dần theo
> `AP-DUNG-vao-du-an-co-san.md` (đo baseline → hạ nợ dần). Checklist này vẫn là danh mục "đích đến".
