import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/countdown_card.dart';
import '../widgets/daily_progress_bar.dart';
import '../widgets/task_list_item.dart';
import '../widgets/empty_dashboard_view.dart';
import '../widgets/streak_success_dialog.dart';
import '../widgets/task_detail_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const LoadDashboardData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(elevation: 0, backgroundColor: Colors.white),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeEmpty) {
            return const EmptyDashboardView();
          }

          if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lỗi: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(const LoadDashboardData());
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (state is HomeLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(const RefreshDashboard());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // header
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Ngày / greeting nhỏ
                                Text(
                                  _getGreeting(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),

                                const SizedBox(height: 6),

                                /// Lời chào chính
                                Text(
                                  _getGreetingMessage(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),

                                const SizedBox(height: 8),

                                /// Tên user
                                Text(
                                  (state.userName ?? 'Người dùng')
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),

                          /// Avatar
                          GestureDetector(
                            onTap: () => context.go('/profile'),
                            child: CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.blue.shade50,
                              backgroundImage: state.userAvatar != null
                                  ? NetworkImage(state.userAvatar!)
                                  : null,
                              child: state.userAvatar == null
                                  ? Icon(
                                      Icons.person,
                                      color: Colors.blue.shade400,
                                      size: 26,
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Countdown card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        onTap: () {
                          context.go('/home/schedule');
                        },
                        child: CountdownCard(
                          daysRemaining: state.daysRemaining,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Nhiệm vụ hôm nay header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Text(
                            'Nhiệm vụ hôm nay',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.go('/home/schedule');
                            },
                            child: Text(
                              'Xem tất cả',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Task list
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.tasks.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final task = state.tasks[index];
                          return TaskListItem(
                            task: task,
                            onTap: () {
                              _showTaskDetail(context, task);
                            },
                            onCompleted: () {
                              context.read<HomeBloc>().add(
                                MarkTaskCompleted(task.id),
                              );
                              if (state.streak == 7 && !task.isCompleted) {
                                _showStreakDialog(context, state.streak);
                              }
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Daily progress section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tiến độ hàng ngày',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                '${state.dailyProgress}%',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Tiến độ hôm nay: ${state.dailyProgress}%\nBạn chỉ còn 1 nhiệm vụ để đạt mục tiêu!',
                                  ),
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            },
                            child: DailyProgressBar(
                              progress: state.dailyProgress,
                              message: state.dailyProgress >= 100
                                  ? '"Xuất sắc! Bạn đã hoàn thành mục tiêu hôm nay!"'
                                  : state.dailyProgress >= 70
                                  ? '"Gần rồi! Chỉ còn ${100 - state.dailyProgress}% nữa!"'
                                  : '"Bạn chỉ còn ${100 - state.dailyProgress}% để đạt mục tiêu hôm nay!"',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showTaskDetail(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TaskDetailBottomSheet(
        task: task,
        onMarkCompleted: () {
          context.read<HomeBloc>().add(MarkTaskCompleted(task.id));
          Navigator.pop(context);
        },
        onEdit: () {
          // TODO: Navigate to edit task
          Navigator.pop(context);
        },
        onDelete: () {
          // TODO: Delete task
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showStreakDialog(BuildContext context, int streak) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StreakSuccessDialog(
        streak: streak,
        onClose: () {
          // Handle streak dialog close
        },
      ),
    );
  }

  String _getGreeting() {
    final now = DateTime.now();
    final day = now.day;
    final month = now.month;
    final dayOfWeek = _getDayOfWeek();

    if (dayOfWeek == 'Chủ Nhật') {
      return '$dayOfWeek, $day Tháng $month';
    }
    return 'Thứ $dayOfWeek, $day Tháng $month';
  }

  String _getDayOfWeek() {
    final days = ['Hai', 'Ba', 'Tư', 'Năm', 'Sáu', 'Bảy', 'Chủ Nhật'];
    return days[DateTime.now().weekday - 1];
  }

  String _getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) {
      return 'Chào buổi sáng!';
    } else if (hour >= 11 && hour < 13) {
      return 'Chào buổi trưa!';
    } else if (hour >= 13 && hour < 17) {
      return 'Chào buổi chiều!';
    } else if (hour >= 17 && hour < 22) {
      return 'Chào buổi tối!';
    } else {
      return 'Chào đêm khuya!';
    }
  }
}
