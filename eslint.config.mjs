// Flat config (ESLint 9/10) — thay cho .eslintrc.json (đã bỏ).
// Next.js 16 đã loại bỏ lệnh `next lint`; chạy ESLint trực tiếp qua `npm run lint`.
import { dirname } from 'path';
import { fileURLToPath } from 'url';
import { FlatCompat } from '@eslint/eslintrc';

const __dirname = dirname(fileURLToPath(import.meta.url));
const compat = new FlatCompat({ baseDirectory: __dirname });

const eslintConfig = [
  // eslint-config-next đã gồm React, React Hooks và một bộ rule jsx-a11y cốt lõi.
  ...compat.extends('next/core-web-vitals', 'next/typescript'),

  {
    files: ['**/*.{ts,tsx}'],
    // Bật lint dựa trên kiểu (type-aware) để rule no-floating-promises hoạt động.
    languageOptions: {
      parserOptions: { projectService: true, tsconfigRootDir: __dirname },
    },
    rules: {
      'no-console': ['warn', { allow: ['warn', 'error'] }],
      '@typescript-eslint/no-explicit-any': 'error',
      '@typescript-eslint/no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
      '@typescript-eslint/no-floating-promises': 'error',
      // Siết thêm vài rule accessibility (plugin jsx-a11y đã được next đăng ký):
      'jsx-a11y/no-autofocus': 'warn',
      'jsx-a11y/label-has-associated-control': 'warn',
    },
  },

  {
    ignores: [
      '.next/**',
      'coverage/**',
      'playwright-report/**',
      'public/sw.js',
      'next-env.d.ts',
    ],
  },
];

export default eslintConfig;
