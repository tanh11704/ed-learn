import 'package:flutter/material.dart';
import 'package:mobile_app/features/mock_exam/presentation/screens/exam_solutiondetail_screen.dart';

class ExamResultScreen extends StatelessWidget {
	const ExamResultScreen({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: const Color(0xFFF7F9FC),
			appBar: AppBar(
				backgroundColor: Colors.white,
				elevation: 0,
				leading: IconButton(
					onPressed: () => Navigator.of(context).maybePop(),
					icon: const Icon(Icons.arrow_back, color: Colors.black87),
				),
				title: const Text(
					'Kết quả bài thi',
					style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
				),
				centerTitle: true,
			),
			body: SafeArea(
				child: ListView(
					padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
					children: [
						Container(
							padding: const EdgeInsets.all(24),
							decoration: BoxDecoration(
								color: Colors.white,
								borderRadius: BorderRadius.circular(20),
								border: Border.all(color: const Color(0xFFE5E7EB)),
							),
							child: Column(
								children: [
									Container(
										height: 140,
										width: 140,
										decoration: BoxDecoration(
											shape: BoxShape.circle,
											border: Border.all(color: const Color(0xFF3B82F6), width: 8),
										),
										child: const Center(
											child: Column(
												mainAxisAlignment: MainAxisAlignment.center,
												children: [
													Text(
														'8.5',
														style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Color(0xFF2563EB)),
													),
													Text('/10', style: TextStyle(color: Colors.black45)),
												],
											),
										),
									),
									const SizedBox(height: 18),
									const Text(
										'Tuyệt vời!',
										style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
									),
									const SizedBox(height: 6),
									const Text(
										'Bạn đã hoàn thành bài thi rất tốt. Hãy tiếp tục phát huy nhé!',
										textAlign: TextAlign.center,
										style: TextStyle(fontSize: 12, color: Colors.black54),
									),
									const SizedBox(height: 18),
									Container(
										padding: const EdgeInsets.all(14),
										decoration: BoxDecoration(
											color: const Color(0xFFF1F5F9),
											borderRadius: BorderRadius.circular(14),
										),
										child: Row(
											children: const [
												Icon(Icons.timer, color: Color(0xFF3B82F6)),
												SizedBox(width: 10),
												Text('Thời gian', style: TextStyle(color: Colors.black54)),
												Spacer(),
												Text(
													'25:00',
													style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
												),
											],
										),
									),
									const SizedBox(height: 14),
									Row(
										children: const [
											_ResultChip(
												title: 'Câu đúng',
												value: '17/20',
												color: Color(0xFF16A34A),
												background: Color(0xFFEFFDF4),
												icon: Icons.check_circle,
											),
											SizedBox(width: 12),
											_ResultChip(
												title: 'Câu sai',
												value: '3/20',
												color: Color(0xFFEF4444),
												background: Color(0xFFFFF1F2),
												icon: Icons.cancel,
											),
										],
									),
									const SizedBox(height: 20),
									SizedBox(
										width: double.infinity,
										height: 48,
										child: ElevatedButton(
											onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const ExamSolutionDetailScreen()));},
											style: ElevatedButton.styleFrom(
												backgroundColor: const Color(0xFF2E6BFF),
												shape: RoundedRectangleBorder(
													borderRadius: BorderRadius.circular(12),
												),
												elevation: 0,
											),
											child: const Text(
												'Xem chi tiết lời giải',
												style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
											),
										),
									),
								],
							),
						),
					],
				),
			),
		);
	}
}

class _ResultChip extends StatelessWidget {
	final String title;
	final String value;
	final Color color;
	final Color background;
	final IconData icon;

	const _ResultChip({
		required this.title,
		required this.value,
		required this.color,
		required this.background,
		required this.icon,
	});

	@override
	Widget build(BuildContext context) {
		return Expanded(
			child: Container(
				padding: const EdgeInsets.all(12),
				decoration: BoxDecoration(
					color: background,
					borderRadius: BorderRadius.circular(14),
					border: Border.all(color: background),
				),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Row(
							children: [
								Icon(icon, color: color, size: 18),
								const SizedBox(width: 6),
								Text(title, style: TextStyle(fontSize: 12, color: color)),
							],
						),
						const SizedBox(height: 8),
						Text(
							value,
							style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color),
						),
					],
				),
			),
		);
	}
}
