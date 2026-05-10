import { useEffect, useMemo, useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Search, Loader2, ChevronLeft, ChevronRight, Eye } from 'lucide-react';
import { listRegisteredUsers } from '../../api/adminUsersApi';
import type { AdminUserDto } from '../../api/models/adminUser.dto';
import { ApiError } from '../../api/ensureOk';
import RegisteredUserDetailModal from './RegisteredUserDetailModal';
import {
  adminUsersCacheKey,
  useAdminDataCacheStore,
} from '../../store/useAdminDataCacheStore';

const PAGE_SIZE = 20;

const AVATAR_COLORS = [
  'text-primary',
  'text-blue-400',
  'text-purple-400',
  'text-cyan-400',
  'text-amber-500',
  'text-emerald-400',
];

function initialsFromName(name: string, email: string): string {
  const n = name.trim();
  if (n.length >= 2) {
    const parts = n.split(/\s+/);
    if (parts.length >= 2) {
      return (parts[0]![0]! + parts[parts.length - 1]![0]!).toUpperCase();
    }
    return n.slice(0, 2).toUpperCase();
  }
  if (email.length >= 2) return email.slice(0, 2).toUpperCase();
  return '?';
}

function roleBadgeClass(role: string): string {
  const r = role.toUpperCase();
  if (r === 'ADMIN' || r.includes('ADMIN')) {
    return 'bg-amber-500/10 text-amber-600 dark:text-amber-400 border border-amber-500/25';
  }
  return 'bg-muted text-foreground/90 border border-border';
}

function formatShortDate(iso?: string): string {
  if (!iso) return '—';
  try {
    return new Date(iso).toLocaleString('vi-VN', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    });
  } catch {
    return iso;
  }
}

function readInitialUsers() {
  const s = useAdminDataCacheStore.getState().getUsersSnapshot(adminUsersCacheKey(0, ''));
  return s;
}

export default function StudentManagement() {
  const initial = readInitialUsers();
  const [rows, setRows] = useState<AdminUserDto[]>(() => initial?.rows ?? []);
  const [loading, setLoading] = useState(() => !initial);
  const [refreshing, setRefreshing] = useState(false);
  const [loadError, setLoadError] = useState('');
  const [page, setPage] = useState(0);
  const [totalPages, setTotalPages] = useState(() => initial?.totalPages ?? 0);
  const [totalElements, setTotalElements] = useState(() => initial?.totalElements ?? 0);
  const [searchTerm, setSearchTerm] = useState('');
  const [debouncedSearch, setDebouncedSearch] = useState('');
  const [detailUser, setDetailUser] = useState<AdminUserDto | null>(null);
  const [detailOpen, setDetailOpen] = useState(false);

  const cacheKey = useMemo(
    () => adminUsersCacheKey(page, debouncedSearch),
    [page, debouncedSearch]
  );

  useEffect(() => {
    const t = window.setTimeout(() => setDebouncedSearch(searchTerm.trim()), 400);
    return () => window.clearTimeout(t);
  }, [searchTerm]);

  useEffect(() => {
    setPage(0);
  }, [debouncedSearch]);

  useEffect(() => {
    const snap = useAdminDataCacheStore.getState().getUsersSnapshot(cacheKey);
    const hadSnap = !!snap;
    if (snap) {
      setRows(snap.rows);
      setTotalPages(snap.totalPages);
      setTotalElements(snap.totalElements);
      setLoading(false);
    } else {
      setRows([]);
      setTotalPages(0);
      setTotalElements(0);
      setLoading(true);
    }

    let cancelled = false;
    if (hadSnap) setRefreshing(true);

    (async () => {
      setLoadError('');
      try {
        const res = await listRegisteredUsers({
          page,
          size: PAGE_SIZE,
          search: debouncedSearch || undefined,
        });
        const content = res.content ?? [];
        const mapped = content.map((u) => ({
          id: String(u.id ?? ''),
          email: String(u.email ?? ''),
          fullName: String(u.fullName ?? ''),
          role: String(u.role ?? ''),
          createdAt: u.createdAt,
          updatedAt: u.updatedAt,
        }));
        const te = Number(res.totalElements ?? content.length);
        const tp = Number(res.totalPages ?? 0);
        const totalEls = Number.isFinite(te) ? te : content.length;
        const totalPgs =
          Number.isFinite(tp) && tp > 0 ? tp : totalEls > 0 ? 1 : 0;

        useAdminDataCacheStore.getState().setUsersSnapshot(cacheKey, {
          rows: mapped,
          totalPages: totalPgs,
          totalElements: totalEls,
        });

        if (!cancelled) {
          setRows(mapped);
          setTotalElements(totalEls);
          setTotalPages(totalPgs);
          setLoadError('');
        }
      } catch (e: unknown) {
        if (cancelled) return;
        if (!hadSnap) {
          setRows([]);
          setTotalPages(1);
          setTotalElements(0);
        }
        const msg =
          e instanceof ApiError
            ? e.message
            : 'Không tải được danh sách người dùng.';
        const hint404 =
          e instanceof ApiError && e.status === 404
            ? ' Backend cần endpoint GET /api/v1/admin/users (phân trang) trả về CustomPage giống khóa học — xem .env VITE_ADMIN_USERS_LIST_PATH.'
            : '';
        const hintAuth =
          e instanceof ApiError &&
          (e.status === 500 || msg.toLowerCase().includes('xác thực'))
            ? ' Lỗi này thường gặp khi backend không kết nối được Redis (kiểm tra JWT/blacklist) — chạy `redis` trong docker-compose và xem log API.'
            : '';
        setLoadError(`${msg}${hint404}${hintAuth}`);
      } finally {
        if (!cancelled) {
          setLoading(false);
          setRefreshing(false);
        }
      }
    })();

    return () => {
      cancelled = true;
    };
  }, [cacheKey, page, debouncedSearch]);

  const busyBlocking = loading && rows.length === 0;
  const paginationDisabled = busyBlocking;

  return (
    <div className="space-y-6 max-w-7xl mx-auto">
      <div>
        <h1 className="text-2xl font-bold text-foreground tracking-tight mb-1">
          Người dùng đã đăng ký
        </h1>
        <p className="text-muted-foreground text-sm">
          Dữ liệu từ máy chủ: mỗi tài khoản trong bảng <code className="text-foreground">users</code> tương ứng một
          dòng (cần API phân trang). Lần vào sau trong phiên: hiển thị bản đã lưu ngay, cập nhật nền.
        </p>
      </div>

      {loadError && (
        <div className="p-4 rounded-xl bg-amber-500/10 border border-amber-500/25 text-amber-800 dark:text-amber-200 text-sm">
          {loadError}
        </div>
      )}

      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div className="relative w-full max-w-md group">
          <Search
            className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground group-focus-within:text-primary transition-colors"
            size={18}
          />
          <input
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            placeholder="Tìm theo tên, email… (gửi lên API tham số search)"
            className="w-full bg-sidebar border border-border rounded-xl py-2.5 pl-10 pr-4 text-sm text-foreground focus:outline-none focus:border-primary/50 transition-all"
          />
        </div>
        <div className="text-sm text-muted-foreground shrink-0 flex items-center gap-3">
          {busyBlocking ? (
            <span className="inline-flex items-center gap-2">
              <Loader2 className="animate-spin" size={16} /> Đang tải…
            </span>
          ) : (
            <>
              Tổng: <span className="font-bold text-foreground">{totalElements}</span> tài khoản
              {totalPages > 1 && (
                <span className="ml-2">
                  · Trang {page + 1}/{totalPages}
                </span>
              )}
              {refreshing && (
                <span className="inline-flex items-center gap-1.5 text-xs text-muted-foreground/90">
                  <Loader2 className="animate-spin" size={14} />
                  Đang cập nhật…
                </span>
              )}
            </>
          )}
        </div>
      </div>

      <div className="bg-sidebar border border-border rounded-2xl overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="border-b border-border/80 text-xs font-medium text-muted-foreground uppercase tracking-wider">
                <th className="p-4 pl-6">Người dùng</th>
                <th className="p-4">Vai trò</th>
                <th className="p-4">ID</th>
                <th className="p-4">Cập nhật</th>
                <th className="p-4 text-center w-24">Chi tiết</th>
              </tr>
            </thead>
            <tbody>
              <AnimatePresence>
                {rows.map((u, idx) => (
                  <motion.tr
                    key={u.id}
                    initial={{ opacity: 0, y: 8 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0 }}
                    className="border-b border-border/80 hover:bg-muted/50 transition-colors"
                  >
                    <td className="p-4 pl-6">
                      <div className="flex items-center gap-3">
                        <div
                          className={`w-10 h-10 rounded-full bg-muted border border-border flex items-center justify-center font-bold ${AVATAR_COLORS[idx % AVATAR_COLORS.length]}`}
                        >
                          {initialsFromName(u.fullName, u.email)}
                        </div>
                        <div>
                          <div className="font-semibold text-foreground text-sm">{u.fullName}</div>
                          <div className="text-xs text-muted-foreground">{u.email}</div>
                        </div>
                      </div>
                    </td>
                    <td className="p-4">
                      <span
                        className={`inline-flex px-2.5 py-1 rounded-lg text-xs font-medium ${roleBadgeClass(u.role)}`}
                      >
                        {u.role}
                      </span>
                    </td>
                    <td className="p-4">
                      <span className="text-xs font-mono text-muted-foreground break-all">{u.id}</span>
                    </td>
                    <td className="p-4 text-sm text-foreground/90">{formatShortDate(u.updatedAt)}</td>
                    <td className="p-4 text-center">
                      <button
                        type="button"
                        onClick={() => {
                          setDetailUser(u);
                          setDetailOpen(true);
                        }}
                        className="inline-flex items-center justify-center p-2 text-muted-foreground hover:text-primary hover:bg-muted rounded-lg transition-colors"
                        title="Xem chi tiết"
                      >
                        <Eye size={18} />
                      </button>
                    </td>
                  </motion.tr>
                ))}
              </AnimatePresence>
            </tbody>
          </table>
          {!busyBlocking && !refreshing && rows.length === 0 && !loadError && (
            <div className="p-10 text-center text-muted-foreground">Chưa có tài khoản nào.</div>
          )}
        </div>
      </div>

      {totalPages > 1 && (
        <div className="flex items-center justify-center gap-2">
          <button
            type="button"
            disabled={page <= 0 || paginationDisabled}
            onClick={() => setPage((p) => Math.max(0, p - 1))}
            className="inline-flex items-center gap-1 px-3 py-2 rounded-xl border border-border bg-muted text-sm font-medium disabled:opacity-40 disabled:pointer-events-none hover:bg-muted/80"
          >
            <ChevronLeft size={18} /> Trước
          </button>
          <button
            type="button"
            disabled={page >= totalPages - 1 || paginationDisabled}
            onClick={() => setPage((p) => p + 1)}
            className="inline-flex items-center gap-1 px-3 py-2 rounded-xl border border-border bg-muted text-sm font-medium disabled:opacity-40 disabled:pointer-events-none hover:bg-muted/80"
          >
            Sau <ChevronRight size={18} />
          </button>
        </div>
      )}

      <RegisteredUserDetailModal
        isOpen={detailOpen}
        onClose={() => {
          setDetailOpen(false);
          setDetailUser(null);
        }}
        user={detailUser}
      />
    </div>
  );
}
