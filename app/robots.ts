// SEO: robots.txt sinh tự động (GĐ 7). Next App Router.
import type { MetadataRoute } from 'next';

const siteUrl = process.env.NEXT_PUBLIC_SITE_URL ?? 'http://localhost:3000';

export default function robots(): MetadataRoute.Robots {
  return {
    rules: {
      userAgent: '*',
      allow: '/',
      // disallow: ['/api/', '/admin/'],  // chặn các đường nhạy cảm nếu cần
    },
    sitemap: `${siteUrl}/sitemap.xml`,
  };
}
