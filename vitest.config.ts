import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react';
import path from 'path';

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: './vitest.setup.ts',
    // Loại E2E (Playwright) khỏi Vitest — hai bộ chạy riêng.
    exclude: ['node_modules', 'e2e', '.next'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'html'],
      // Sàn an toàn tối thiểu (KHÔNG phải mục tiêu) — bắt việc "quên viết test".
      // Ưu tiên chất lượng test ở đường đi quan trọng + ca biên hơn con số %.
      thresholds: { lines: 70, functions: 70, branches: 70, statements: 70 },
      exclude: ['e2e/**', '**/*.config.*', '**/*.d.ts', 'vitest.setup.ts'],
    },
  },
  resolve: {
    alias: { '@': path.resolve(__dirname, './') },
  },
});
