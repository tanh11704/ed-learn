const DEFAULT_MINIO_PUBLIC_URL =
  import.meta.env.VITE_MINIO_PUBLIC_URL || 'http://localhost:9000';
const API_BASE_URL =
  import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080/api/v1';

const INTERNAL_MINIO_HOSTS = new Set(['minio', 'edlearn-minio']);

function stripTrailingSlash(value) {
  return value.replace(/\/+$/, '');
}

export function resolveAssetUrl(url) {
  if (!url || typeof url !== 'string') return '';

  const trimmedUrl = url.trim();
  if (!trimmedUrl) return '';

  try {
    const parsedUrl = new URL(trimmedUrl);
    if (!INTERNAL_MINIO_HOSTS.has(parsedUrl.hostname)) {
      return trimmedUrl;
    }

    const publicBaseUrl = stripTrailingSlash(DEFAULT_MINIO_PUBLIC_URL);
    return `${publicBaseUrl}${parsedUrl.pathname}${parsedUrl.search}${parsedUrl.hash}`;
  } catch {
    const apiRoot = API_BASE_URL.replace(/\/api\/v1\/?$/, '');
    return `${apiRoot}/uploads/${trimmedUrl.replace(/^\/+/, '')}`;
  }
}

export function applyFallbackImage(event, fallbackUrl) {
  const image = event.currentTarget;
  if (image.src !== fallbackUrl) {
    image.src = fallbackUrl;
  }
}
