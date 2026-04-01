import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../models/assessment_ui_models.dart';

class UniversitiesScreen extends StatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  State<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {
    late final Future<List<UniversityUi>> _universitiesFuture;

  @override
  void initState() {
    super.initState();
        _universitiesFuture = Future.value(const [
      UniversityUi(id: 1, name: 'Đại học Bách Khoa Hà Nội', location: 'Hà Nội'),
      UniversityUi(id: 2, name: 'Đại học Quốc gia Hà Nội', location: 'Hà Nội'),
      UniversityUi(id: 3, name: 'Đại học Ngoại thương', location: 'Hà Nội'),
      UniversityUi(id: 4, name: 'Đại học Kinh tế Quốc dân', location: 'Hà Nội'),
      UniversityUi(id: 5, name: 'Đại học Bách Khoa TP.HCM', location: 'TP. Hồ Chí Minh'),
      UniversityUi(id: 6, name: 'Đại học Quốc gia TP.HCM', location: 'TP. Hồ Chí Minh'),
      UniversityUi(id: 7, name: 'Đại học Sư phạm Hà Nội', location: 'Hà Nội'),
      UniversityUi(id: 8, name: 'Đại học Cần Thơ', location: 'Cần Thơ'),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/assessment/target-university');
            }
          },
        ),
        title: Text('Tất cả trường đại học', style: AppTextStyles.heading2),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<List<UniversityUi>>(
          future: _universitiesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Không tải được dữ liệu trường.', style: AppTextStyles.caption),
              );
            }

            final universities = snapshot.data ?? [];
            if (universities.isEmpty) {
              return Center(
                child: Text('Chưa có dữ liệu trường.', style: AppTextStyles.caption),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              itemCount: universities.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = universities[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.school, color: AppColors.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(item.location, style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

