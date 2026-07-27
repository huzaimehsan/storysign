class AuthorNotificationModel {
  final String id;
  final String title;
  final String message;
  final bool isRead;
  final String referenceType;
  final String? referenceId;
  final DateTime createdAt;
  final DateTime updatedAt;

  AuthorNotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.referenceType,
    this.referenceId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AuthorNotificationModel.fromJson(Map<String, dynamic> json) {
    return AuthorNotificationModel(
      id: json['_id']?.toString() ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      isRead: json['isRead'] ?? false,
      referenceType: json['referenceType'] ?? '',
      referenceId: json['referenceId']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  AuthorNotificationModel copyWith({bool? isRead}) {
    return AuthorNotificationModel(
      id: id,
      title: title,
      message: message,
      isRead: isRead ?? this.isRead,
      referenceType: referenceType,
      referenceId: referenceId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}