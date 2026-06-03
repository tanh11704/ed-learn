import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/performance_bloc/performance_state.dart';

class TimeBarChart extends StatelessWidget {
  final List<TimeCategory> categories;

  const TimeBarChart({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: categories.map(_buildBar).toList(),
    );
  }

  Widget _buildBar(TimeCategory category) {
    final maxValue = categories
        .map(
          (item) =>
              item.average > item.userValue ? item.average : item.userValue,
        )
        .fold<double>(0, (prev, value) => value > prev ? value : prev);
    final avgHeight = (category.average / maxValue) * 110;
    final userHeight = (category.userValue / maxValue) * 110;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 130,
          width: 26,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 10,
                height: avgHeight,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Positioned(
                right: 0,
                child: Container(
                  width: 10,
                  height: userHeight,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          category.label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
