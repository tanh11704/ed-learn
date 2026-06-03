import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/premium_feature_item.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  String _plan = 'year';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Nâng cấp Premium', style: AppTextStyles.heading2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mở khóa toàn bộ sức mạnh học tập!',
                    style: AppTextStyles.heading2.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Trải nghiệm không giới hạn với lộ trình cá nhân hóa.',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _planCard(
              'year',
              'Gói năm',
              '799.000đ',
              '66k/tháng • Lựa chọn phổ biến nhất',
            ),
            const SizedBox(height: 10),
            _planCard('month', 'Gói tháng', '99.000đ', '99.000đ / tháng'),
            const SizedBox(height: 16),
            Text(
              'ĐẶC QUYỀN PREMIUM',
              style: AppTextStyles.caption.copyWith(letterSpacing: .8),
            ),
            const SizedBox(height: 10),
            const PremiumFeatureItem(
              title: 'Kho đề thi không giới hạn',
              subtitle: 'Tiếp cận hơn 10,000+ đề thi từ các trường uy tín.',
            ),
            const PremiumFeatureItem(
              title: 'Xem giải thích chi tiết',
              subtitle: 'Phân tích từng bước cho mọi câu hỏi hóc búa.',
            ),
            const PremiumFeatureItem(
              title: 'Phòng học VIP',
              subtitle: 'Tương tác trực tiếp với trợ lý ảo AI 24/7.',
            ),
            const PremiumFeatureItem(
              title: 'Không quảng cáo',
              subtitle:
                  'Tập trung tuyệt đối vào việc học mà không bị làm phiền.',
            ),
            const SizedBox(height: 14),
            PrimaryButton(
              text: 'Tiếp tục thanh toán',
              onPressed: () => context.go('/profile/payment'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _planCard(String id, String title, String price, String desc) {
    final selected = _plan == id;
    return InkWell(
      onTap: () => setState(() => _plan = id),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title.toUpperCase(), style: AppTextStyles.caption),
                  const SizedBox(height: 6),
                  Text(price, style: AppTextStyles.heading2),
                  Text(desc, style: AppTextStyles.caption),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
