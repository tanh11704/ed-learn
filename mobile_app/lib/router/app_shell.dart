import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_colors.dart';

class AppShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  static final GlobalKey<_AppShellState> _globalKey = GlobalKey<_AppShellState>();

  const AppShell({super.key, required this.navigationShell});

  static void hideNavBar() {
    _globalKey.currentState?.hideNavBar();
  }

  static void showNavBar() {
    _globalKey.currentState?.showNavBar();
  }

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _isBottomSheetOpen = false;

  @override
  void initState() {
    super.initState();
    AppShell._globalKey.currentState == null ? null : null;
  }

  void hideNavBar() {
    setState(() => _isBottomSheetOpen = true);
  }

  void showNavBar() {
    setState(() => _isBottomSheetOpen = false);
  }

  @override
  Widget build(BuildContext context) {
  final location = GoRouterState.of(context).uri.toString();
    final isSelfStudy = location.startsWith('/home/self-study');
    final showFab = widget.navigationShell.currentIndex == 0 && !isSelfStudy;

    return Scaffold(
      body: widget.navigationShell, // Hiển thị màn hình con tương ứng với tab được chọn
      
      // 1. NÚT NỔI Ở GÓC PHẢI DƯỚI (GIA SƯ AI)
      floatingActionButton: showFab
          ? Padding(
              padding: const EdgeInsets.only(bottom: 70, right: 8),
              child: FloatingActionButton(
                onPressed: () {
                  // Khi bấm nút, đẩy thẳng sang màn hình Camera (ẩn Nav Bar)
                  context.push('/camera');
                },
                backgroundColor: AppColors.primary,
                shape: const CircleBorder(),
                elevation: 6,
                child: const Icon(Icons.camera_alt, color: AppColors.white, size: 28),
              ),
            )
          : null,
      // Neo nút nổi vào góc phải dưới, chừa khoảng cho nav bar
      floatingActionButtonLocation:
          showFab ? FloatingActionButtonLocation.endDocked : null,

      // 2. THANH ĐIỀU HƯỚNG DƯỚI ĐÁY
      bottomNavigationBar: _isBottomSheetOpen ? null : BottomAppBar(
        shape: showFab ? const CircularNotchedRectangle() : null, // Tạo rãnh lõm cho nút nổi
        notchMargin: showFab ? 6.0 : 0,
        color: AppColors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              Expanded(
                child: _buildNavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Trang chủ',
                  index: 0,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  icon: Icons.menu_book_outlined,
                  activeIcon: Icons.menu_book,
                  label: 'Học tập',
                  index: 1,
                ),
              ),
              // const Expanded(child: SizedBox()),
              Expanded(
                child: _buildNavItem(
                  icon: Icons.edit_document,
                  activeIcon: Icons.edit_square,
                  label: 'Thi thử',
                  index: 2,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  icon: Icons.bar_chart_outlined,
                  activeIcon: Icons.bar_chart,
                  label: 'Thống kê',
                  index: 3,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Cá nhân',
                  index: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm tạo từng nút bấm trên Nav Bar
  Widget _buildNavItem({required IconData icon, required IconData activeIcon, required String label, required int index}) {
    final isSelected = widget.navigationShell.currentIndex == index;
    
    return InkWell(
      onTap: () => widget.navigationShell.goBranch(index, initialLocation: index == widget.navigationShell.currentIndex),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}