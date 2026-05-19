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
import '../widgets/top_courses_section.dart';

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
                    const SizedBox(height: 12),

                    if (state.topCourses.isNotEmpty) ...[
                      TopCoursesSection(courses: state.topCourses),
                      const SizedBox(height: 16),
                    ],

                    // ── Streak card (data từ API /user-streaks/me) ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildStreakCard(context, state),
                    ),
                    const SizedBox(height: 12),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.orange.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.local_fire_department,
                                color: Colors.deepOrange,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: '1,240 ',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'bạn đang trong phòng tự học',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () => context.go('/home/self-study'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade600,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              child: const Text('Tham gia ngay'),
                            ),
                          ],
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

                    if (!state.tasksFromApi)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: Text(
                          'Đang hiển thị nhiệm vụ mẫu (API chưa sẵn sàng)',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.orange[700],
                          ),
                        ),
                      ),

                    // Task list
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: state.tasks.isEmpty
                          ? Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.task_alt,
                                      size: 36, color: Colors.grey[400]),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Chưa có nhiệm vụ hôm nay',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
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
                                    if (state.streak > 0 &&
                                        !task.isCompleted) {
                                      _showStreakDialog(
                                          context, state.streak);
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
        onClose: () {},
      ),
    );
  }

  // ── Streak card — hiển thị dữ liệu từ API /user-streaks/me ──
  Widget _buildStreakCard(BuildContext context, HomeLoaded state) {
    final isActive = (state.streakStatus ?? 'ACTIVE') == 'ACTIVE';
    final accentColor = isActive ? Colors.deepOrange : Colors.grey;

    // Định dạng ngày hoạt động cuối
    String lastActivityLabel = 'Chưa có';
    if (state.lastActivityDay != null && state.lastActivityDay!.isNotEmpty) {
      try {
        final parts = state.lastActivityDay!.split('-');
        if (parts.length == 3) {
          lastActivityLabel = '${parts[2]}/${parts[1]}/${parts[0]}';
        } else {
          lastActivityLabel = state.lastActivityDay!;
        }
      } catch (_) {
        lastActivityLabel = state.lastActivityDay!;
      }
    }

    return GestureDetector(
      onTap: () {
        if (state.streak > 0) {
          _showStreakDialog(context, state.streak);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.local_fire_department_rounded,
                    color: accentColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chuỗi ngày học',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[800],
                        ),
                      ),
                      Text(
                        isActive ? 'Đang duy trì' : 'Chưa hoạt động',
                        style: TextStyle(
                          fontSize: 11,
                          color: isActive ? Colors.green[600] : Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                    child: Text(
                    isActive ? 'ACTIVE' : (state.streakStatus ?? 'INACTIVE'),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: isActive ? Colors.green[700] : Colors.grey[600],
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Stats row
            Row(
              children: [
                // Current streak
                Expanded(
                  child: _buildStreakStat(
                    label: 'Hiện tại',
                    value: '${state.streak}',
                    unit: 'ngày',
                    icon: Icons.local_fire_department,
                    color: state.streak > 0 ? Colors.deepOrange : Colors.grey,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey[200],
                ),
                // Longest streak
                Expanded(
                  child: _buildStreakStat(
                    label: 'Dài nhất',
                    value: '${state.longestStreak}',
                    unit: 'ngày',
                    icon: Icons.emoji_events_rounded,
                    color: Colors.amber[700]!,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey[200],
                ),
                // Freeze count
                Expanded(
                  child: _buildStreakStat(
                    label: 'Lượt đóng băng',
                    value: '${state.streakFreezeCount}',
                    unit: 'lượt',
                    icon: Icons.ac_unit_rounded,
                    color: Colors.blue[400]!,
                  ),
                ),
              ],
            ),

            // Last activity
            if (state.lastActivityDay != null) ...[
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded,
                      size: 12, color: Colors.grey[500]),
                  const SizedBox(width: 6),
                  Text(
                    'Hoạt động gần nhất: $lastActivityLabel',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStreakStat({
    required String label,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
