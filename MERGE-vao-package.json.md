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

# Kiểm thử
npm install --save-dev vitest @vitejs/plugin-react jsdom \
  @testing-library/react @testing-library/jest-dom

# Xác thực biến môi trường (dùng bởi lib/env.ts)
npm install zod
```

## 2. Thêm khối `scripts` này vào `package.json`

```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint --max-warnings=0",
    "type-check": "tsc --noEmit",
    "format": "prettier --write .",
    "format:check": "prettier --check .",
    "test": "vitest run",
    "test:watch": "vitest",
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
