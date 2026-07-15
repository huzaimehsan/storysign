class NotificationModel {
  final String id;
  final String message;
  final String createdAt;

  NotificationModel({
    required this.id,
    required this.message,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? "",
      message: json['message'] ?? "",
      createdAt: json['createdAt'] ?? "",
    );
  }
}