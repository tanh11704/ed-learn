import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _method = 'bank';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Thanh toán', style: AppTextStyles.heading2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ĐANG CHỌN', style: AppTextStyles.caption),
                  const SizedBox(height: 6),
                  Text('Gói Premium 1 Năm', style: AppTextStyles.bodyLarge),
                  const SizedBox(height: 6),
                  Text('799.000đ', style: AppTextStyles.heading1),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Nhập mã Voucher...',
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: () {}, child: const Text('Áp dụng')),
              ],
            ),
            const SizedBox(height: 16),
            Text('PHƯƠNG THỨC THANH TOÁN', style: AppTextStyles.caption),
            const SizedBox(height: 8),
            _methodTile(
              'bank',
              'Chuyển khoản QR',
              'Nhận phòng học riêng trong 30 giây',
            ),
            _methodTile('momo', 'Ví MoMo', 'Thanh toán nhanh chóng qua app'),
            _methodTile(
              'zalopay',
              'ZaloPay',
              'Tiện lợi, an toàn bảo mật tuyệt đối',
            ),
            _methodTile(
              'card',
              'Thẻ Ngân hàng',
              'Visa, Mastercard, ATM nội địa',
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text('Tổng cộng 799.000đ', style: AppTextStyles.heading2),
            ),
            const SizedBox(height: 10),
            PrimaryButton(text: 'Thanh toán 799.000đ', onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _methodTile(String id, String title, String sub) {
    final selected = _method == id;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => setState(() => _method = id),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 16,
                child: Icon(Icons.account_balance_wallet_outlined, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.bodyMedium),
                    Text(sub, style: AppTextStyles.caption),
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
      ),
    );
  }
}
