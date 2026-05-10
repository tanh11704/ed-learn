/** Bản ghi người dùng từ API quản trị (khớp GET /api/v1/admin/users). */
export interface AdminUserDto {
  id: string;
  email: string;
  fullName: string;
  role: string;
  createdAt?: string;
  updatedAt?: string;
}
