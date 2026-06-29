'use client';
// Ranh giới lỗi cấp route (GĐ 7). Bắt buộc là Client Component.
// KHÔNG phơi chi tiết kỹ thuật cho người dùng; log để theo dõi (vd gửi Sentry).
import { useEffect } from 'react';

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    // TODO: gửi lỗi tới dịch vụ theo dõi (Sentry.captureException(error)).
    console.error(error);
  }, [error]);

  return (
    <main className="bg-background text-foreground flex min-h-screen flex-col items-center justify-center gap-4 p-6 text-center">
      <h1 className="text-2xl font-semibold">Đã có lỗi xảy ra</h1>
      <p className="text-muted-foreground">Xin lỗi vì sự bất tiện. Bạn có thể thử lại.</p>
      <button
        type="button"
        onClick={reset}
        className="bg-primary text-primary-foreground rounded-lg px-4 py-2 font-medium"
      >
        Thử lại
      </button>
    </main>
  );
}
