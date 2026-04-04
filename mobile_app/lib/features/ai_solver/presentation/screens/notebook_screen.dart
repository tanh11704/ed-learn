import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/save_notebook_bottom_sheet.dart';
import '../bloc/notebook_bloc/notebook_bloc.dart';
import '../bloc/notebook_bloc/notebook_event.dart';
import '../bloc/notebook_bloc/notebook_state.dart';

class NotebookScreen extends StatelessWidget {
  const NotebookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Lưu vào sổ tay', style: AppTextStyles.heading2),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Xong',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<NotebookBloc, NotebookState>(
            builder: (context, state) {
              if (state is! NotebookLoaded) {
                return const Center(child: CircularProgressIndicator());
              }

              return SaveNotebookBottomSheet(
                notebooks: state.notebooks,
                selectedIndex: state.selectedIndex,
                showHeader: false,
        onSelectNotebook: (index) => context.read<NotebookBloc>().add(
          SelectNotebook(index),
        ),
                onCreateNew: () => context.read<NotebookBloc>().add(
                      const CreateNotebook('Sổ tay mới'),
                    ),
              );
            },
          ),
        ),
      ),
    );
  }
}
