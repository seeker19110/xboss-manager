# Bổ sung chất lượng — Nhóm 2

> Tài liệu này gắn các bổ sung "Nhóm 2" vào bộ khung đã có (KHUNG 1, KHUNG 2, Nhóm 1).
> Trọng tâm Nhóm 2: **mobile-first, hiệu năng (Lighthouse/Core Web Vitals), kiểm thử mở rộng
> (E2E + accessibility tự động), UI/UX, và chống lỗi logic.**
> Triết lý xuyên suốt vẫn là *"tự động hóa thay vì kỷ luật"*: mỗi checklist dưới đây đều
> kèm một hàng rào máy chạy được (CI/lint/test) — đừng chỉ dựa vào việc "nhớ kiểm tra".

## Các bổ sung gắn vào khung ở đâu

| Bổ sung | Lấp lỗ hổng | Liên quan giai đoạn | Hàng rào tự động |
|---------|-------------|---------------------|------------------|
| Checklist mobile-first | "Mobile-first" mới có 1 dòng ở GĐ 2 | GĐ 2 & 4 | Playwright project `mobile` |
| Performance budget + Lighthouse CI | "Lighthouse ≥ 90" chưa được ép trong pipeline | GĐ 5 & 6 | `lighthouserc.json` + workflow |
| Accessibility tự động | A11y mới ở mức "nhớ kiểm tra tay" | GĐ 4 & 5 | `eslint-plugin-jsx-a11y` + `@axe-core/playwright` |
| Kiểm thử E2E (Playwright) | Kim tự tháp test thiếu tầng E2E | GĐ 5 | `playwright.config.ts` |
| Ngưỡng coverage | "Có test" chưa có mức tối thiểu | GĐ 5 | `vitest` coverage thresholds |
| Checklist UI/UX trạng thái | Loading/rỗng/lỗi mới là nguyên tắc, chưa thành checklist | GĐ 4 | PR template |
| Checklist chống lỗi logic | "Type safety" không bắt được lỗi *nghiệp vụ* | GĐ 4 & 5 | review + test biên |
| Observability (Sentry) | GĐ 6 nhắc Sentry nhưng chưa nói *làm sao* | GĐ 6 & 8 | `@sentry/nextjs` |
| Issue template + CHANGELOG | Quản lý việc & lịch sử thay đổi chưa có công cụ | Xuyên suốt | GitHub templates |

---

## 1. Mobile-first (cụ thể hóa)

Khung yêu cầu "mobile-first; responsive" nhưng chưa nói *kiểm cái gì*. Phần lớn người dùng vào
bằng điện thoại — thiết kế cho màn nhỏ trước, rồi mở rộng ra màn lớn (`sm:`, `md:`, `lg:` của Tailwind).

**Checklist mobile-first (đối chiếu cho mỗi màn hình):**
- [ ] Thiết kế ở khổ ~360px trước; không có thanh cuộn ngang ở bất kỳ breakpoint nào.
- [ ] **Vùng chạm ≥ 44×44px** cho mọi nút/link (Apple HIG; tối thiểu WCAG 2.2 AA là 24px) — ngón tay không phải con trỏ chuột.
- [ ] `<meta name="viewport" content="width=device-width, initial-scale=1" />` (Next có sẵn qua `viewport` export).
- [ ] Tôn trọng **safe-area** trên máy có tai thỏ: `env(safe-area-inset-*)` cho header/footer cố định.
- [ ] Input không gây zoom bất ngờ trên iOS: cỡ chữ input ≥ 16px.
- [ ] Ảnh dùng `next/image` (tự `srcset`, lazy-load, tránh layout shift); luôn đặt `width`/`height` hoặc `fill` + `sizes`.
- [ ] Font nạp qua `next/font` (tránh FOIT/FOUT và giảm CLS).
- [ ] Bàn phím ảo không che mất ô nhập đang gõ; nút submit không bị bàn phím che.
- [ ] Test thật trên thiết bị (hoặc Playwright project `mobile` ở mục 4) trước khi coi là xong.

> **Tự động:** Playwright chạy mọi smoke test trên cả viewport mobile (`Pixel 5`) lẫn desktop —
> xem `playwright.config.ts`. Một luồng chính gãy ở mobile sẽ làm CI đỏ.

---

## 2. Performance budget & Lighthouse CI

Khung nói "Lighthouse ≥ 90" nhưng để nó là việc *nhớ chạy tay* thì sớm muộn cũng quên.
Biến nó thành **cổng tự động** chạy trên mỗi PR.

### Ngân sách hiệu năng (đặt mục tiêu cụ thể trong `PROJECT.md` mục 3)

**Core Web Vitals** (đo trên 4G/thiết bị tầm trung — tức điều kiện thật của đa số người dùng):

| Chỉ số | Ngưỡng "tốt" | Ý nghĩa |
|--------|-------------|---------|
| **LCP** (Largest Contentful Paint) | ≤ 2.5s | nội dung chính hiện nhanh |
| **INP** (Interaction to Next Paint) | ≤ 200ms | bấm/gõ phản hồi mượt (thay FID từ 2024) |
| **CLS** (Cumulative Layout Shift) | ≤ 0.1 | bố cục không "nhảy" |

**Điểm Lighthouse tối thiểu (mobile):** Performance ≥ 90 · Accessibility ≥ 90 · Best Practices ≥ 90 · SEO ≥ 90.

### Cài Lighthouse CI

```bash
npm install --save-dev @lhci/cli
```

File `lighthouserc.json` (đã kèm ở gốc repo) khai báo URL cần đo + các assertion (ngưỡng).
Workflow `.github/workflows/lighthouse-ci.yml` (đã kèm) chạy build, dựng server, đo, và **fail PR nếu dưới ngưỡng**.

> Mẹo chống nhiễu: Lighthouse dao động nhẹ giữa các lần chạy. `lighthouserc.json` đặt
> `numberOfRuns: 3` (lấy trung vị). Nếu một assertion quá ngặt lúc đầu, hạ về `"warn"` thay vì
> `"error"` cho riêng chỉ số đó, siết dần sau — đừng tắt cả cổng.

---

## 3. Accessibility tự động (a11y)

A11y không chỉ là đạo đức — nó là chất lượng đo được và ảnh hưởng SEO. Tự động hóa hai tầng:

**Tầng tĩnh — ESLint:** `eslint-config-next` đã bật sẵn bộ rule **jsx-a11y cốt lõi** (thiếu `alt`,
`label` rời rạc, `onClick` trên thẻ không tương tác...) — không cần cài gói riêng. `eslint.config.mjs`
(flat config) **siết thêm** vài rule (`jsx-a11y/no-autofocus`, `jsx-a11y/label-has-associated-control`).
Cần bắt sâu hơn thì dùng tầng động (axe) bên dưới.

**Tầng động — axe trong E2E:** quét cây DOM thật (đã render) bằng axe:

```bash
npm install --save-dev @axe-core/playwright
```

Mỗi smoke test E2E nên kèm một lần quét axe (xem `e2e/smoke.spec.ts`). axe bắt được lỗi mà
linter tĩnh không thấy: tương phản màu thực tế, thứ tự heading, focus trap, ARIA sai ngữ cảnh.

**Vẫn cần kiểm tay (máy không thay được):**
- [ ] Duyệt toàn bộ luồng chính **chỉ bằng bàn phím** (Tab/Shift-Tab/Enter/Esc); focus thấy rõ.
- [ ] Thử một lượt với trình đọc màn hình (VoiceOver/TalkBack) cho luồng quan trọng nhất.
- [ ] `prefers-reduced-motion`: tắt animation lớn cho người chọn giảm chuyển động.

---

## 4. Kiểm thử mở rộng — E2E (Playwright) + coverage

Khung mô tả kim tự tháp (nhiều unit → ít integration → vài E2E) nhưng chỉ cấu hình Vitest (unit).
Bổ sung tầng đỉnh và một mức sàn cho đáy.

### E2E với Playwright

```bash
npm install --save-dev @playwright/test
npx playwright install --with-deps   # tải trình duyệt (bỏ qua nếu môi trường đã có)
```

File `playwright.config.ts` (đã kèm) định nghĩa **2 project**: `desktop` (Chromium) và
`mobile` (Pixel 5) → mọi luồng chính được kiểm trên cả hai kích thước, ép tinh thần mobile-first.

Viết E2E cho **đường đi quan trọng nhất** (đăng nhập → thao tác lõi → đạt mục tiêu), không cố phủ hết.
Mỗi E2E nên: (a) chạy được độc lập, tự dọn dữ liệu; (b) không phụ thuộc thứ tự; (c) dùng
`getByRole`/`getByLabel` (bền hơn selector CSS, lại ép a11y đúng).

### Ngưỡng coverage cho unit test

Đã thêm `coverage` vào `vitest.config.ts`. Coverage là *sàn an toàn tối thiểu*, **không phải mục tiêu** —
một số phủ cao mà toàn assert vô nghĩa thì vô dụng. Đặt sàn vừa phải (vd 70%) để bắt việc "quên viết test",
và luôn ưu tiên **chất lượng test ở đường đi quan trọng + trường hợp biên** hơn là con số.

```bash
npm install --save-dev @vitest/coverage-v8
```

Chạy: `npm run test:coverage`.

### Chiến lược dữ liệu test

- **Unit/integration:** dùng factory/fixture tạo dữ liệu tối thiểu cần cho ca test; không dùng dump production.
- **E2E:** chạy trên Supabase "staging" (Preview), **không bao giờ** chạm dữ liệu thật; mỗi test tự tạo & xóa.
- Cố định thời gian/ngẫu nhiên (mock `Date`, seed random) để test **tất định** (chạy lần nào cũng ra một kết quả).

---

## 5. UI/UX — checklist trạng thái & tương tác

Khung đã nói "xử lý trạng thái lỗi/rỗng/tải" — nâng thành checklist cụ thể để không sót.

**Mỗi màn hình hiển thị dữ liệu phải xử lý đủ 4 trạng thái:**
- [ ] **Đang tải:** skeleton hoặc spinner — *không* để màn trắng/nhảy layout.
- [ ] **Rỗng:** thông điệp rõ + hành động gợi ý ("Chưa có mục nào — Tạo mục đầu tiên").
- [ ] **Lỗi:** thông báo thân thiện (không phơi stack trace) + nút thử lại.
- [ ] **Thành công/có dữ liệu:** trạng thái bình thường.

**Form & hành động:**
- [ ] Validate inline, ngay cạnh ô lỗi; thông báo nói *cách sửa*, không chỉ "sai".
- [ ] Nút submit **disable + hiện loading** khi đang gửi → chặn double-submit.
- [ ] Sau hành động: phản hồi rõ (toast/redirect); thất bại thì giữ nguyên dữ liệu người dùng đã nhập.
- [ ] Hành động phá hủy (xóa) cần xác nhận; ưu tiên cho **hoàn tác (undo)** hơn là hỏi "chắc chưa?".

**Phản hồi & chuyển động:**
- [ ] Thao tác > ~400ms phải có chỉ báo tiến trình.
- [ ] Tôn trọng `prefers-reduced-motion`.
- [ ] Optimistic UI (nếu dùng): có **đường rollback** khi server trả lỗi (xem mục 6).

---

## 6. Chống lỗi logic (lỗi nghiệp vụ — type-checker KHÔNG bắt được)

Đây là loại bug nguy hiểm nhất: code *biên dịch sạch, type đúng*, nhưng **làm sai việc**.
TypeScript không cứu bạn ở đây — chỉ có suy nghĩ kỹ + test biên + review.

**Checklist rà soát logic (đối chiếu khi viết & khi review mọi logic nghiệp vụ):**

*Biên & rỗng:*
- [ ] Mảng/danh sách rỗng, đúng 1 phần tử, rất nhiều phần tử — đều xử lý đúng?
- [ ] `null`/`undefined`/chuỗi rỗng/số 0 — phân biệt rõ "không có" với "bằng 0/rỗng"? (`??` vs `||`).
- [ ] Off-by-one: vòng lặp, phân trang, cắt chuỗi, chỉ số mảng (`noUncheckedIndexedAccess` đã giúp một phần).

*Số & tiền:*
- [ ] Tiền tệ: **không** dùng số thực (float) — dùng số nguyên (cents) hoặc kiểu decimal. `0.1 + 0.2 !== 0.3`.
- [ ] Chia cho 0, tràn số, làm tròn — định nghĩa rõ hành vi.

*Thời gian:*
- [ ] Lưu & tính bằng **UTC**; chỉ đổi sang giờ địa phương khi hiển thị.
- [ ] Múi giờ, giờ mùa hè (DST), ranh giới ngày/tháng — test ca chuyển ngày.

*Bất đồng bộ & đồng thời:*
- [ ] **Race condition:** hai request/click đồng thời — kết quả vẫn đúng? (khóa, disable nút, idempotency).
- [ ] **Idempotency:** gửi lại cùng một thao tác (mạng chập chờn, người dùng bấm 2 lần) không tạo bản ghi trùng / tính tiền 2 lần.
- [ ] `await` đặt đúng chỗ; không có promise "trôi" (đã có `no-floating-promises`).
- [ ] Thứ tự phản hồi không đảm bảo: phản hồi cũ về sau không ghi đè dữ liệu mới (stale closure / race).

*Trạng thái & nhất quán:*
- [ ] Cập nhật một chỗ → mọi nơi phụ thuộc đồng bộ (một nguồn sự thật).
- [ ] Optimistic update có rollback khi server lỗi; UI không "kẹt" ở trạng thái lạc quan sai.
- [ ] Thao tác nhiều bước (giao dịch): hoặc xong cả, hoặc rollback cả — không để nửa vời.

> **Quy tắc:** với mỗi nhánh logic phức tạp, viết *ít nhất một test cho ca biên* trước khi coi là xong.
> Lỗi logic rẻ nhất khi bị một unit test bắt; đắt nhất khi người dùng thật gặp trên production.

---

## 7. Observability — Sentry (cụ thể hóa GĐ 6)

Khung nhắc "theo dõi lỗi (Sentry)" nhưng chưa hướng dẫn. Không có giám sát = mù trên production:
người dùng gặp lỗi, bạn không biết cho tới khi họ rời đi.

```bash
npx @sentry/wizard@latest -i nextjs
```

Wizard tự tạo config client/server/edge, gắn source map, và một route test. Sau khi cài:
- [ ] Đặt `SENTRY_DSN` qua biến môi trường (thêm vào `lib/env.ts`) — **không** hard-code.
- [ ] Tách môi trường (`environment: process.env.NODE_ENV`) để lọc lỗi dev/staging/prod riêng.
- [ ] Bật cảnh báo (email/Slack) cho lỗi mới hoặc tần suất tăng đột biến.
- [ ] Lọc dữ liệu nhạy cảm khỏi báo cáo lỗi (`beforeSend`) — đừng gửi token/PII lên Sentry.

> Tối thiểu cần: bắt lỗi chưa xử lý ở cả client lẫn server. Thêm performance tracing sau nếu cần.

---

## 8. Quản lý dự án — issue template & CHANGELOG

**Issue templates** (`.github/ISSUE_TEMPLATE/`, đã kèm): ép mọi báo lỗi/đề xuất tính năng có đủ
thông tin (các bước tái hiện, kỳ vọng vs thực tế, tiêu chí chấp nhận) → gắn với **Definition of Ready**.

**CHANGELOG.md** (đã kèm, theo chuẩn *Keep a Changelog*): ghi lại thay đổi theo phiên bản cho con người đọc.
Vì commit đã theo *conventional commits*, có thể sinh CHANGELOG tự động sau (`standard-version`/`changesets`),
nhưng bản viết tay vẫn giá trị cho mục "Unreleased".

**Nhịp nhìn lại (với người làm một mình):** cuối mỗi đợt/sprint, cập nhật `PROGRESS.md` và tự hỏi 3 câu:
gì chạy tốt, gì vướng, lần sau đổi gì. Ghi nợ kỹ thuật vào `PROGRESS.md` để không quên quay lại dọn.

---

## Tóm tắt: đặt file vào đâu

```
dự-án/
├─ lighthouserc.json                  ← ngưỡng Lighthouse (performance budget)
├─ playwright.config.ts               ← cấu hình E2E (project desktop + mobile)
├─ CHANGELOG.md                       ← lịch sử thay đổi (Keep a Changelog)
├─ e2e/
│  └─ smoke.spec.ts                   ← E2E mẫu (luồng chính + quét axe)
├─ vitest.config.ts                   ← (đã cập nhật) thêm ngưỡng coverage
├─ eslint.config.mjs                  ← flat config (siết thêm rule jsx-a11y)
└─ .github/
   ├─ ISSUE_TEMPLATE/
   │  ├─ bug_report.md
   │  ├─ feature_request.md
   │  └─ config.yml
   └─ workflows/
      └─ lighthouse-ci.yml            ← cổng Lighthouse trên mỗi PR
```

> Các gói cần cài thêm đã gộp vào `MERGE-vao-package.json.md`. Sau khi cài, chạy lại
> **Bước 14 (kiểm chứng hàng rào)** trong hướng dẫn pre-commit/CI để chắc cổng mới hoạt động.
