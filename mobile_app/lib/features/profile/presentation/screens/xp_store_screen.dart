import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class XpStoreScreen extends StatefulWidget {
  const XpStoreScreen({super.key});

  @override
  State<XpStoreScreen> createState() => _XpStoreScreenState();
}

class _XpStoreScreenState extends State<XpStoreScreen> {
  int _selectedTab = 0;

  final List<String> _tabs = const ['Khung Avatar', 'Giao diện', 'Voucher'];

  final List<_StoreItem> _avatarItems = const [
    _StoreItem(name: 'Khung Avatar\nLửa Thiêng', priceXp: 500, color: Color(0xFFFF7A1A), icon: Icons.blur_circular, unlocked: true),
    _StoreItem(name: 'Khung Avatar\nPhi Hành Gia', priceXp: 800, color: Color(0xFF6A64FF), icon: Icons.crop_square_rounded, unlocked: true),
    _StoreItem(name: 'Khung Avatar\nVương Miện', requiredLevel: 'Cần Cấp 15', color: Color(0xFFA0846A), icon: Icons.workspace_premium, unlocked: false),
    _StoreItem(name: 'Khung Avatar\nKim Cương', requiredLevel: 'Cần Cấp 15', color: Color(0xFF7D889A), icon: Icons.diamond_outlined, unlocked: false),
  ];

  final List<_StoreItem> _themeItems = const [
    _StoreItem(name: 'Theme Neon', priceXp: 600, color: Color(0xFF00C2FF), icon: Icons.color_lens_outlined, unlocked: true),
    _StoreItem(name: 'Theme Tối', priceXp: 750, color: Color(0xFF454A5E), icon: Icons.dark_mode_outlined, unlocked: true),
    _StoreItem(name: 'Theme Galaxy', requiredLevel: 'Cần Cấp 14', color: Color(0xFF5A4AC9), icon: Icons.auto_awesome, unlocked: false),
  ];

  final List<_StoreItem> _voucherItems = const [
    _StoreItem(name: 'Voucher giảm 10%', priceXp: 900, color: Color(0xFF29B36A), icon: Icons.local_offer_outlined, unlocked: true),
    _StoreItem(name: 'Voucher 50.000đ', priceXp: 1200, color: Color(0xFF1D9BF0), icon: Icons.card_giftcard_outlined, unlocked: true),
    _StoreItem(name: 'Voucher 100.000đ', requiredLevel: 'Cần Cấp 16', color: Color(0xFF7D889A), icon: Icons.lock_outline_rounded, unlocked: false),
  ];

  @override
  Widget build(BuildContext context) {
    final items = _selectedTab == 0 ? _avatarItems : _selectedTab == 1 ? _themeItems : _voucherItems;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text('Đổi điểm XP', style: AppTextStyles.heading2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF4FF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFD4E2FF)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.workspace_premium_outlined, size: 16, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text('SỐ DƯ HIỆN TẠI', style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: '1,250', style: AppTextStyles.heading1.copyWith(fontWeight: FontWeight.w800)),
                        TextSpan(text: ' XP', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_tabs.length, (index) {
                  final selected = index == _selectedTab;
                  return Padding(
                    padding: EdgeInsets.only(right: index == _tabs.length - 1 ? 0 : 16),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        padding: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: selected ? AppColors.primary : Colors.transparent,
                              width: 2.5,
                            ),
                          ),
                        ),
                        child: Text(
                          _tabs[index],
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: selected ? AppColors.primary : AppColors.textSecondary,
                            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              itemBuilder: (context, index) => _storeCard(items[index]),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Text(
                'Cày thêm XP để đổi Voucher giảm 20% khóa học Luyện thi khối A!',
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _storeCard(_StoreItem item) {
    final locked = !item.unlocked;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: locked
                    ? [const Color(0xFFB8BFCC), const Color(0xFF8E97A8)]
                    : [item.color.withValues(alpha: 0.86), item.color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(
              item.icon,
              color: Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            item.name,
            style: AppTextStyles.bodyMedium.copyWith(
              color: locked ? AppColors.textSecondary : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          if (locked)
            Text(
              item.requiredLevel ?? '',
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            )
          else
            Container(
              width: double.infinity,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: item.priceXp == 800 ? const Color(0xFFF4BE22) : const Color(0xFFFF7A1A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${item.priceXp} XP',
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            )
        ],
      ),
    );
  }
}

class _StoreItem {
  final String name;
  final int? priceXp;
  final String? requiredLevel;
  final Color color;
  final IconData icon;
  final bool unlocked;

  const _StoreItem({
    required this.name,
    required this.color,
    required this.icon,
    required this.unlocked,
    this.priceXp,
    this.requiredLevel,
  });
}
