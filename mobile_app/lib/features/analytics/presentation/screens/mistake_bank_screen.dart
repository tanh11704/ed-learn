import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../bloc/mistake_bank_bloc/mistake_bank_bloc.dart';
import '../bloc/mistake_bank_bloc/mistake_bank_event.dart';
import '../bloc/mistake_bank_bloc/mistake_bank_state.dart';
import '../widgets/mistake_list_tile.dart';

class MistakeBankScreen extends StatelessWidget {
  const MistakeBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Ngân hàng lỗi sai', style: AppTextStyles.heading2),
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_alt_outlined)),
        ],
      ),
      body: BlocBuilder<MistakeBankBloc, MistakeBankState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: state.subjects.map((subject) {
                      final isSelected = subject == state.selectedSubject;
                      return GestureDetector(
                        onTap: () =>
                            context.read<MistakeBankBloc>().add(FilterMistakesBySubject(subject)),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : AppColors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            subject,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: isSelected ? AppColors.white : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                ...state.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: MistakeListTile(
                      item: item,
                      onTap: () => context.go('/statistical/mistakes/${item.id}', extra: item),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
