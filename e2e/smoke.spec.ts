import { test, expect } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';

/**
 * Smoke test mẫu cho LUỒNG CHÍNH + quét accessibility tự động (axe).
 * Thay nội dung cho khớp app thật. Chạy trên cả project `desktop` và `mobile`.
 *
 * Nguyên tắc selector: ưu tiên getByRole / getByLabel (bền hơn CSS, lại ép a11y đúng).
 */

test('trang chủ tải được và có tiêu đề chính', async ({ page }) => {
  await page.goto('/');
  // Mọi trang nên có đúng một <h1>.
  await expect(page.getByRole('heading', { level: 1 })).toBeVisible();
});

test('trang chủ không có vi phạm accessibility nghiêm trọng', async ({ page }) => {
  await page.goto('/');
  const results = await new AxeBuilder({ page })
    .withTags(['wcag2a', 'wcag2aa']) // bám tiêu chuẩn WCAG AA của khung
    .analyze();
  expect(results.violations).toEqual([]);
});

/**
 * Mẫu cho một luồng có tương tác (bỏ comment & sửa khi đã có tính năng):
 *
 * test('người dùng hoàn thành luồng chính', async ({ page }) => {
 *   await page.goto('/');
 *   await page.getByRole('link', { name: 'Bắt đầu' }).click();
 *   await page.getByLabel('Email').fill('user@example.com');
 *   await page.getByRole('button', { name: 'Tiếp tục' }).click();
 *   await expect(page.getByText('Thành công')).toBeVisible();
 * });
 */
