# Cần gộp vào `package.json`

Không thể đưa sẵn `package.json` (sẽ ghi đè file của create-next-app), nên làm tay 2 việc:

## 1. Cài các gói

```bash
# Chất lượng code
npm install --save-dev prettier prettier-plugin-tailwindcss

# Pre-commit hooks
npm install --save-dev husky lint-staged

# Chuẩn commit message
npm install --save-dev @commitlint/cli @commitlint/config-conventional

# Kiểm thử (unit)
npm install --save-dev vitest @vitejs/plugin-react jsdom \
  @testing-library/react @testing-library/jest-dom @vitest/coverage-v8

# Kiểm thử (E2E + accessibility) — xem Nhóm 2
npm install --save-dev @playwright/test @axe-core/playwright
npx playwright install --with-deps   # tải trình duyệt (bỏ qua nếu môi trường đã có)

# Hiệu năng (Lighthouse CI) — xem Nhóm 2
npm install --save-dev @lhci/cli
# (jsx-a11y đã có sẵn trong eslint-config-next — không cần cài riêng)

# Xác thực biến môi trường (dùng bởi lib/env.ts)
npm install zod

# (Tùy chọn — xem BO-SUNG-nang-cao) i18n / PWA / Sentry:
# npm install next-intl @serwist/next @sentry/nextjs
# npm install --save-dev serwist
```

> **ESLint 9/10 + Next 16:** dùng **flat config** (`eslint.config.mjs`, đã kèm) — `.eslintrc.json` đã bị bỏ,
> lệnh `next lint` đã bị Next 16 loại bỏ (chạy `eslint` trực tiếp). `@eslint/eslintrc` (cho FlatCompat) đã đi
> kèm create-next-app. **Tailwind v4:** cần `@tailwindcss/postcss` + `postcss.config.mjs` (đã kèm); globals.css
> dùng `@import "tailwindcss";` (create-next-app bản Tailwind đã cài sẵn các gói này).

> **Phiên bản:** dùng bản ổn định mới nhất. Đã xác minh ngày 2026-06-29 (xác minh lại khi bạn bắt đầu):
> Next 16.x · React 19.x · TypeScript 6.x · Tailwind 4.x · `@supabase/supabase-js` 2.x · Zod 4.x ·
> Vitest 4.x · Playwright 1.x · Node 22 LTS. Chi tiết cách chọn & xác minh: `docs/framework/KHUNG-3-...md`.

## 2. Thêm khối `scripts` này vào `package.json`

```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "eslint . --max-warnings 0",
    "lint:fix": "eslint . --fix",
    "type-check": "tsc --noEmit",
    "format": "prettier --write .",
    "format:check": "prettier --check .",
    "test": "vitest run",
    "test:watch": "vitest",
    "test:coverage": "vitest run --coverage",
    "test:e2e": "playwright test",
    "lhci": "lhci autorun",
    "prepare": "husky"
  }
}
```

## 3. Kích hoạt Husky

```bash
npx husky init
```

> Lệnh này tạo lại `.husky/` và một `pre-commit` mẫu. Sau khi chạy, **copy đè** lại
> hai file `.husky/pre-commit` và `.husky/commit-msg` từ bộ khung này (để đúng nội dung).
