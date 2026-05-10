import { apiJson } from './ensureOk';
import type { CustomPageDto } from './models/lms.dto';
import type { AdminUserDto } from './models/adminUser.dto';

/**
 * Đường dẫn danh sách người đăng ký (phân trang).
 * Khi backend bổ sung endpoint, thêm vào OpenAPI; có thể ghi đè bằng env.
 */
const LIST_PATH =
  (import.meta.env.VITE_ADMIN_USERS_LIST_PATH as string | undefined)?.trim() ||
  '/api/v1/admin/users';

export async function listRegisteredUsers(params?: {
  page?: number;
  size?: number;
  search?: string;
}): Promise<CustomPageDto<AdminUserDto>> {
  const page = params?.page ?? 0;
  const size = params?.size ?? 20;
  const q = params?.search?.trim();
  return apiJson<CustomPageDto<AdminUserDto>>({
    url: LIST_PATH,
    method: 'GET',
    params: {
      page,
      size,
      ...(q ? { search: q } : {}),
    },
  });
}
