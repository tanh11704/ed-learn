class UserTaskModel {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime dueDate;

  const UserTaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.dueDate,
  });

  factory UserTaskModel.fromJson(Map<String, dynamic> json) {
    return UserTaskModel(
      id: (json['id'] ?? json['taskId'] ?? '').toString(),
      title: (json['title'] ?? json['name'] ?? '').toString(),
      description: (json['description'] ?? json['note'] ?? '').toString(),
      isCompleted: json['isCompleted'] == true || json['completed'] == true,
      dueDate: _parseDate(
        json['dueDate'] ?? json['dueAt'] ?? json['scheduledAt'],
      ),
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return DateTime.now();
    }
  }
}
