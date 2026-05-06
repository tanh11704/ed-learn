import 'package:equatable/equatable.dart';

class UserBadgeResponse extends Equatable {
  final String userBadgeId;
  final String badgeId;
  final String badgeCode;
  final String badgeName;
  final String badgeDescription;
  final String category;
  final String? imageUrl;
  final int xpReward;
  final String? earnedAt;
  final bool isNew;

  const UserBadgeResponse({
    required this.userBadgeId,
    required this.badgeId,
    required this.badgeCode,
    required this.badgeName,
    required this.badgeDescription,
    required this.category,
    required this.imageUrl,
    required this.xpReward,
    required this.earnedAt,
    required this.isNew,
  });

  factory UserBadgeResponse.fromJson(Map<String, dynamic> json) {
    return UserBadgeResponse(
      userBadgeId: json['userBadgeId'] ?? '',
      badgeId: json['badgeId'] ?? '',
      badgeCode: json['badgeCode'] ?? '',
      badgeName: json['badgeName'] ?? '',
      badgeDescription: json['badgeDescription'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'],
      xpReward: json['xpReward'] ?? 0,
      earnedAt: json['earnedAt'],
      isNew: json['isNew'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
        userBadgeId,
        badgeId,
        badgeCode,
        badgeName,
        badgeDescription,
        category,
        imageUrl,
        xpReward,
        earnedAt,
        isNew,
      ];
}

class PageUserBadgeResponse extends Equatable {
  final int totalElements;
  final int totalPages;
  final int size;
  final int number;
  final List<UserBadgeResponse> content;

  const PageUserBadgeResponse({
    required this.totalElements,
    required this.totalPages,
    required this.size,
    required this.number,
    required this.content,
  });

  factory PageUserBadgeResponse.fromJson(Map<String, dynamic> json) {
    final contentJson = (json['content'] as List?) ?? [];
    return PageUserBadgeResponse(
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      size: json['size'] ?? 0,
      number: json['number'] ?? 0,
      content: contentJson.map((e) => UserBadgeResponse.fromJson(e)).toList(),
    );
  }

  @override
  List<Object?> get props => [totalElements, totalPages, size, number, content];
}
