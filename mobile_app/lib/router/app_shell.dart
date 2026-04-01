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
    return Scaffold(
      body: widget.navigationShell, // Hiển thị màn hình con tương ứng với tab được chọn
      
      // 1. NÚT NỔI Ở GIỮA (GIA SƯ AI)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Khi bấm nút giữa, đẩy thẳng sang màn hình Camera (ẩn Nav Bar)
          context.push('/camera'); 
        },
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.camera_alt, color: AppColors.white, size: 28),
      ),
      // Neo nút nổi vào đúng vị trí giữa thanh Nav Bar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // 2. THANH ĐIỀU HƯỚNG DƯỚI ĐÁY
      bottomNavigationBar: _isBottomSheetOpen ? null : BottomAppBar(
        shape: const CircularNotchedRectangle(), // Tạo rãnh lõm cho nút nổi
        notchMargin: 8.0,
        color: AppColors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Trang chủ', index: 0),
              _buildNavItem(icon: Icons.menu_book_outlined, activeIcon: Icons.menu_book, label: 'Học tập', index: 1),
              
              const SizedBox(width: 48), // Khoảng trống ở giữa nhường chỗ cho nút Camera
              
              _buildNavItem(icon: Icons.edit_document, activeIcon: Icons.edit_square, label: 'Thi thử', index: 2),
              _buildNavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Cá nhân', index: 3),
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
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}