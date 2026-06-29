# Bổ sung nâng cao — i18n · PWA/offline · Sentry · SEO

> Các năng lực giúp template **đa dụng** và sẵn sàng production. Mỗi mục kèm gói + **phiên bản đã xác minh
> (2026-06-29)** và file drop-in (nếu có). Bật mục nào tùy nhu cầu dự án (KHUNG 3 PHẦN A sẽ nhắc bạn quyết).
> Chạy theo nguyên tắc research-first: **xác minh lại phiên bản** khi khởi tạo.

| Năng lực | Gói (phiên bản 2026-06-29) | File drop-in kèm theo |
|----------|----------------------------|------------------------|
| Đa ngôn ngữ (i18n) | `next-intl` 4.x | `i18n/request.ts`, `messages/*.json` |
| PWA / offline | `@serwist/next` 9.x + `serwist` | `app/sw.ts`, `app/manifest.ts` |
| Theo dõi lỗi | `@sentry/nextjs` 10.x | (tạo bằng wizard) |
| SEO | (Next có sẵn) | `app/sitemap.ts`, `app/robots.ts` |
| Trang lỗi thân thiện | (Next có sẵn) | `app/not-found.tsx`, `app/error.tsx`, `app/global-error.tsx` |

---

## 1. Đa ngôn ngữ — next-intl

```bash
npm install next-intl
```

File `i18n/request.ts` (đã kèm) chọn locale theo cookie `locale`, mặc định `vi`, fallback `en`.
Thông điệp ở `messages/vi.json`, `messages/en.json` (đã kèm).

**Nối plugin vào `next.config`** (xem mục 6 — cấu hình tổng hợp). `createNextIntlPlugin()` tự tìm `i18n/request.ts`.

**Bọc Provider ở `app/layout.tsx`:**

```tsx
import { NextIntlClientProvider } from 'next-intl';
import { getLocale, getMessages } from 'next-intl/server';

export default async function RootLayout({ children }: { children: React.ReactNode }) {
  const locale = await getLocale();
  const messages = await getMessages();
  return (
    <html lang={locale} data-theme="dark" suppressHydrationWarning>
      <body>
        <NextIntlClientProvider messages={messages}>{children}</NextIntlClientProvider>
      </body>
    </html>
  );
}
```

**Dùng trong component:**
```tsx
import { useTranslations } from 'next-intl';
const t = useTranslations('home');
return <h1>{t('title')}</h1>;
```

**Đổi ngôn ngữ:** đặt cookie `locale` (qua server action) rồi `router.refresh()`. Định dạng ngày/số/tiền
dùng `useFormatter` của next-intl để đúng theo locale.

---

## 2. PWA / offline — Serwist (kế nhiệm next-pwa)

```bash
npm install @serwist/next && npm install --save-dev serwist
```

File `app/sw.ts` (đã kèm) là service worker. Nối vào `next.config` bằng `withSerwistInit` (mục 6).

- Mặc định `@serwist/next` **tự đăng ký** service worker (không cần code thêm).
- **Tắt ở dev** (`disable: NODE_ENV === 'development'`) để tránh kẹt cache khi phát triển.
- ⚠️ **Serwist chưa hỗ trợ Turbopack** (bundler mặc định của Next 16). Để thử PWA ở dev, chạy
  `next dev --webpack`. Bản production (`next build`) không bị ảnh hưởng.
- Tạo icon `public/icon-192.png` và `public/icon-512.png` cho `app/manifest.ts`.

---

## 3. Theo dõi lỗi — Sentry

Dùng **wizard chính thức** (tự tạo file đúng phiên bản, tránh viết tay sai):

```bash
npx @sentry/wizard@latest -i nextjs
```

Wizard sẽ tạo/sửa: `instrumentation.ts`, `instrumentation-client.ts`, cấu hình server/edge, và **bọc
`next.config` bằng `withSentryConfig`**. Sau khi cài:
- [ ] Đặt `SENTRY_DSN` qua biến môi trường (đã khai trong `lib/env.ts` + `.env.example`) — không hard-code.
- [ ] `environment: process.env.NODE_ENV` để tách lỗi dev/staging/prod.
- [ ] Lọc dữ liệu nhạy cảm trong `beforeSend` (đừng gửi token/PII).
- [ ] Trong `app/error.tsx`/`global-error.tsx`: gọi `Sentry.captureException(error)` (thay `console.error`).
- [ ] Bật cảnh báo (email/Slack) cho lỗi mới / tần suất tăng.

---

## 4. SEO

- **Metadata:** dùng `export const metadata` (hoặc `generateMetadata`) trong `layout.tsx`/`page.tsx`:
  `title`, `description`, `openGraph`, `twitter`, `metadataBase: new URL(process.env.NEXT_PUBLIC_SITE_URL!)`.
- **sitemap & robots:** `app/sitemap.ts` + `app/robots.ts` (đã kèm) — thêm các route quan trọng vào sitemap.
- **Dữ liệu có cấu trúc (JSON-LD):** nhúng `<script type="application/ld+json">` cho trang sản phẩm/bài viết nếu cần.
- Đặt `NEXT_PUBLIC_SITE_URL` cho cả Production và Preview.

---

## 5. Trang lỗi thân thiện (đã kèm)

`app/not-found.tsx` (404), `app/error.tsx` (lỗi cấp route), `app/global-error.tsx` (lỗi root layout).
Không phơi chi tiết kỹ thuật ra người dùng; log để theo dõi. Dùng token theme nên hợp cả Dark blue lẫn Light.

---

## 6. Cấu hình `next.config` tổng hợp

create-next-app tạo sẵn `next.config.ts` — **sửa** nó để bọc các plugin bạn dùng (bỏ plugin không cần):

```ts
import type { NextConfig } from 'next';
import createNextIntlPlugin from 'next-intl/plugin';
import withSerwistInit from '@serwist/next';
import { withSentryConfig } from '@sentry/nextjs';

const withNextIntl = createNextIntlPlugin();

const withSerwist = withSerwistInit({
  swSrc: 'app/sw.ts',
  swDest: 'public/sw.js',
  disable: process.env.NODE_ENV === 'development',
});

const nextConfig: NextConfig = {
  // cấu hình Next của bạn ở đây
};

// Thứ tự bọc: Sentry ngoài cùng. Bỏ lớp nào không dùng.
export default withSentryConfig(withSerwist(withNextIntl(nextConfig)), {
  silent: !process.env.CI,
  // org/project: đặt qua biến môi trường hoặc để wizard điền.
});
```

> Nếu chỉ dùng một phần (vd chỉ i18n), chỉ bọc lớp đó: `export default withNextIntl(nextConfig);`.

---

## Phiên bản đã xác minh (2026-06-29 — xác minh lại khi khởi tạo)

`next-intl` 4.x · `@serwist/next` 9.x · `@sentry/nextjs` 10.x · Next 16.x · Node 22 LTS.
Cách chọn & xác minh phiên bản: xem `KHUNG-3` (PHẦN B, quy tắc chọn phiên bản).
