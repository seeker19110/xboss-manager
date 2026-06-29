// SEO: sitemap.xml sinh tự động (GĐ 7). Thêm các route quan trọng vào đây.
import type { MetadataRoute } from 'next';

const siteUrl = process.env.NEXT_PUBLIC_SITE_URL ?? 'http://localhost:3000';

export default function sitemap(): MetadataRoute.Sitemap {
  return [
    {
      url: siteUrl,
      lastModified: new Date(),
      changeFrequency: 'weekly',
      priority: 1,
    },
    // { url: `${siteUrl}/ve-chung-toi`, lastModified: new Date(), priority: 0.8 },
  ];
}
