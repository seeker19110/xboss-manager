# Bộ khung phát triển dự án (drop-in)

Giải nén bộ này vào **gốc repo** của một dự án Next.js mới (đã tạo bằng
`create-next-app` với TypeScript + Tailwind + ESLint). Phần lớn file đã ở đúng chỗ;
chỉ 2 file cần gộp tay (xem bên dưới).

## Bắt đầu từ đâu
Đọc **`docs/framework/KHOI-TAO-du-an-moi.md`** — runbook chỉ rõ làm gì theo thứ tự và
phải tuân thủ gì. Đó là kim chỉ nam chính.

## File đã sẵn sàng (chỉ cần giải nén)
- `CLAUDE.md` — luật cho AI (Claude Code tự đọc). **Nhớ điền các chỗ `[ĐIỀN: ...]`.**
- `PROJECT.md` — mẫu đặc tả dự án (điền trước khi code).
- `PROGRESS.md` — mẫu theo dõi trạng thái.
- `lib/env.ts` — xác thực biến môi trường (đổi tên biến cho khớp dự án).
- `.prettierrc`, `.prettierignore`, `.eslintrc.json`, `commitlint.config.js`,
  `.lintstagedrc.json`, `vitest.config.ts`, `vitest.setup.ts`, `.gitignore`
- `.husky/pre-commit`, `.husky/commit-msg` — hook (cần chạy `npx husky init` trước, xem dưới).
- `.github/pull_request_template.md`, `.github/dependabot.yml`, `.github/workflows/ci.yml`
- `docs/framework/` — 5 tài liệu khung (quy trình, luật AI, mẫu dự án, cấu hình, runbook).
- `docs/adr/0000-template.md` — mẫu ghi quyết định kỹ thuật.

## 2 việc phải làm tay
1. `MERGE-vao-package.json.md` — cài gói + thêm khối `scripts` + `npx husky init`.
2. `MERGE-vao-tsconfig.json.md` — thêm các cờ TypeScript strict.

> Sau khi gộp xong, làm tiếp theo runbook (`docs/framework/KHOI-TAO-du-an-moi.md`):
> bật branch protection trên GitHub, kết nối Supabase, deploy thử Vercel, rồi
> **kiểm chứng hàng rào** (thử commit sai phải bị chặn) trước khi code tính năng.

## Lưu ý
- `.eslintrc.json` dùng cấu hình kiểu cũ. Nếu dự án của bạn dùng ESLint flat config
  (`eslint.config.mjs`), hãy chuyển các `rules` tương ứng sang đó.
- Hai file MERGE và README này KHÔNG cần commit — xóa sau khi setup xong nếu muốn.
