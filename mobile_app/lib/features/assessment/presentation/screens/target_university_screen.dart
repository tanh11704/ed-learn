import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../models/assessment_ui_models.dart';
import '../state/assessment_selection_store.dart';

class TargetUniversityScreen extends StatefulWidget {
  const TargetUniversityScreen({super.key});

  @override
  State<TargetUniversityScreen> createState() => _TargetUniversityScreenState();
}

class _TargetUniversityScreenState extends State<TargetUniversityScreen> {
    late final Future<List<UniversityUi>> _universitiesFuture;

  final List<String> _examBlocks = const ['A00', 'A01', 'D01', 'B00', 'C00', 'D07'];

  int _selectedUniversity = 0;
  String _selectedExamBlock = 'A00';

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
    ]);    AssessmentSelectionStore.selectedExamBlock.value = _selectedExamBlock;
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
              context.go('/home');
            }
          },
        ),
        title: Text('Chọn trường Đại học mục tiêu', style: AppTextStyles.heading2),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    icon: const Icon(Icons.search, size: 18),
                    hintText: 'Tìm kiếm trường đại học',
                    hintStyle: AppTextStyles.bodyMedium,
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Trường đại học phổ biến', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                  TextButton(
                    onPressed: () => context.push('/assessment/universities'),
                    child: Text('Xem tất cả', style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 162,
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

                    if (_selectedUniversity >= universities.length) {
                      _selectedUniversity = 0;
                    }

                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final item = universities[index];
                        return _UniversityCard(
                          name: item.name,
                          location: item.location,
                          selected: _selectedUniversity == index,
                          onTap: () => setState(() => _selectedUniversity = index),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(width: 12),
                      itemCount: universities.length,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text('Chọn Khối Thi', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
              Text('Chọn Tổ Hợp Môn Phù Hợp Với Trường Của Bạn', style: AppTextStyles.caption),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _examBlocks
                    .map(
                      (item) => _ExamChip(
                        label: item,
                        selected: _selectedExamBlock == item,
                        onTap: () {
                          setState(() => _selectedExamBlock = item);
                          AssessmentSelectionStore.selectedExamBlock.value = item;
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7E6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.warning),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Hệ thống sẽ dựa trên khối thi và mục tiêu trường của bạn để đề xuất lộ trình ôn tập cá nhân hóa.',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                text: 'Tiếp tục',
                onPressed: () => context.push('/assessment/intro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UniversityCard extends StatelessWidget {
  const _UniversityCard({
    required this.name,
    required this.location,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final String location;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? AppColors.primary : AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.school, color: selected ? AppColors.primaryDark : AppColors.primary),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(location, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

class _ExamChip extends StatelessWidget {
  const _ExamChip({required this.label, this.selected = false, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? AppColors.primary : AppColors.border),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: selected ? AppColors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}




