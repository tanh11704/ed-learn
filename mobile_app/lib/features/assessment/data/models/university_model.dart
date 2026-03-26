import '../../domain/entities/university.dart';

class UniversityModel extends University {
  const UniversityModel({
    required super.id,
    required super.name,
    required super.location,
    super.logoUrl,
  });

  factory UniversityModel.fromJson(Map<String, dynamic> json) {
    return UniversityModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? 'Chưa có tên').toString(),
      location: (json['location'] ?? 'Chưa rõ').toString(),
      logoUrl: json['logo']?.toString(),
    );
  }
}
