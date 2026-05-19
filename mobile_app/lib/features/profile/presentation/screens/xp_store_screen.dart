import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/datasources/user_badge_remote_datasource.dart';
import '../../data/repositories/user_badge_repository_impl.dart';

class XpStoreScreen extends StatefulWidget {
  const XpStoreScreen({super.key});

  @override
  State<XpStoreScreen> createState() => _XpStoreScreenState();
}

class _XpStoreScreenState extends State<XpStoreScreen> {
  int _selectedTab = 0;
  int _totalXp = 0;
  bool _isLoading = true;

  late final UserBadgeRepositoryImpl _badgeRepository;

  final List<String> _tabs = const ['Khung Avatar', 'Giao diện', 'Voucher'];

  final List<_StoreItem> _avatarItems = const [
    _StoreItem(name: 'Khung Avatar\nLửa Thiêng', priceXp: 500, color: Color(0xFFFF7A1A), icon: Icons.blur_circular),
    _StoreItem(name: 'Khung Avatar\nPhi Hành Gia', priceXp: 800, color: Color(0xFF6A64FF), icon: Icons.crop_square_rounded),
    _StoreItem(name: 'Khung Avatar\nVương Miện', priceXp: 1500, requiredLevel: 'Cần Cấp 15', color: Color(0xFFA0846A), icon: Icons.workspace_premium),
    _StoreItem(name: 'Khung Avatar\nKim Cương', priceXp: 2000, requiredLevel: 'Cần Cấp 20', color: Color(0xFF7D889A), icon: Icons.diamond_outlined),
  ];

  final List<_StoreItem> _themeItems = const [
    _StoreItem(name: 'Theme Neon', priceXp: 600, color: Color(0xFF00C2FF), icon: Icons.color_lens_outlined),
    _StoreItem(name: 'Theme Tối', priceXp: 750, color: Color(0xFF454A5E), icon: Icons.dark_mode_outlined),
    _StoreItem(name: 'Theme Galaxy', priceXp: 1200, requiredLevel: 'Cần Cấp 14', color: Color(0xFF5A4AC9), icon: Icons.auto_awesome),
  ];

  final List<_StoreItem> _voucherItems = const [
    _StoreItem(name: 'Voucher giảm 10%', priceXp: 900, color: Color(0xFF29B36A), icon: Icons.local_offer_outlined),
    _StoreItem(name: 'Voucher 50.000đ', priceXp: 1200, color: Color(0xFF1D9BF0), icon: Icons.card_giftcard_outlined),
    _StoreItem(name: 'Voucher 100.000đ', priceXp: 2500, requiredLevel: 'Cần Cấp 16', color: Color(0xFF7D889A), icon: Icons.lock_outline_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _badgeRepository = UserBadgeRepositoryImpl(UserBadgeRemoteDataSourceImpl());
    _loadXpBalance();
  }

  Future<void> _loadXpBalance() async {
    try {
      final result = await _badgeRepository.getMyBadges(page: 0, size: 100);
      final earned = result.content.fold<int>(0, (sum, b) => sum + b.xpReward);
      if (mounted) {
        setState(() {
          _totalXp = earned;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
            // XP balance card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF4FF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFD4E2FF)),
              ),
              child: Row(
                children: [
                  Expanded(
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
                        _isLoading
                            ? const SizedBox(
                                height: 28,
                                width: 28,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: _formatXp(_totalXp),
                                      style: AppTextStyles.heading1.copyWith(fontWeight: FontWeight.w800),
                                    ),
                                    TextSpan(
                                      text: ' XP',
                                      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                  // Refresh button
                  IconButton(
                    onPressed: () {
                      setState(() => _isLoading = true);
                      _loadXpBalance();
                    },
                    icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
                    tooltip: 'Làm mới',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Source note
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8EC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFDFA0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 14, color: Color(0xFFD48A00)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'XP được tích lũy từ các huy hiệu bạn đã đạt được',
                      style: AppTextStyles.caption.copyWith(color: const Color(0xFFD48A00)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // Tabs
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
                'Hoàn thành thử thách để kiếm thêm XP và mở khóa phần thưởng độc quyền!',
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _storeCard(_StoreItem item) {
    final canAfford = _totalXp >= item.priceXp;
    final hasLevelReq = item.requiredLevel != null;

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
          Stack(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: hasLevelReq
                        ? [const Color(0xFFB8BFCC), const Color(0xFF8E97A8)]
                        : [item.color.withValues(alpha: 0.86), item.color],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  hasLevelReq ? Icons.lock_outline_rounded : item.icon,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              if (!hasLevelReq && !canAfford)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF4444),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 12, color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.name,
            style: AppTextStyles.bodyMedium.copyWith(
              color: hasLevelReq ? AppColors.textSecondary : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          if (hasLevelReq)
            Text(
              item.requiredLevel!,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            )
          else
            GestureDetector(
              onTap: () => _onRedeem(item),
              child: Container(
                width: double.infinity,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: canAfford
                      ? (item.priceXp == 800 ? const Color(0xFFF4BE22) : const Color(0xFFFF7A1A))
                      : const Color(0xFFCDD0D8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${item.priceXp} XP',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onRedeem(_StoreItem item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [item.color.withValues(alpha: 0.86), item.color],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(item.icon, color: Colors.white, size: 38),
            ),
            const SizedBox(height: 16),
            Text(item.name.replaceAll('\n', ' '), style: AppTextStyles.heading2, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: 'Giá: ', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                  TextSpan(
                    text: '${item.priceXp} XP',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: '  •  Số dư: ${_formatXp(_totalXp)} XP',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_totalXp < item.priceXp)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFCCCC)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Color(0xFFFF4444), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Không đủ XP. Cần thêm ${item.priceXp - _totalXp} XP nữa.',
                        style: AppTextStyles.caption.copyWith(color: const Color(0xFFFF4444)),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FFF4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFB2DFDB)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFF29B36A), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tính năng đổi thưởng sẽ sớm ra mắt. Hãy tiếp tục tích lũy XP!',
                        style: AppTextStyles.caption.copyWith(color: const Color(0xFF29B36A)),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text('Đóng', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatXp(int xp) {
    if (xp >= 1000) {
      return '${(xp / 1000).toStringAsFixed(xp % 1000 == 0 ? 0 : 1)}k';
    }
    return xp.toString();
  }
}

class _StoreItem {
  final String name;
  final int priceXp;
  final String? requiredLevel;
  final Color color;
  final IconData icon;

  const _StoreItem({
    required this.name,
    required this.priceXp,
    required this.color,
    required this.icon,
    this.requiredLevel,
  });
}
