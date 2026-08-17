class SubscriptionPlan {
  final String id;
  final String name;
  final String planType;
  final double price;
  final List<String> features;
  final bool isActive;
  final String? stripePriceId;
  final int signQuota;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.planType,
    required this.price,
    required this.features,
    required this.isActive,
    this.stripePriceId,
    required this.signQuota,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    try {
      return SubscriptionPlan(
        id: json['_id'] ?? json['id'] ?? '',
        name: json['name'] ?? '',
        planType: json['planType'] ?? '',
        price: json['price'] != null 
            ? (json['price'] is String ? double.parse(json['price']) : (json['price'] as num).toDouble())
            : 0.0,
        features: json['features'] != null && json['features'] is List
            ? List<String>.from(json['features'].map((f) => f.toString()))
            : [],
        isActive: json['isActive'] ?? false,
        stripePriceId: json['stripePriceId'],
        signQuota: json['signQuota'] ?? 0,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'].toString()) : DateTime.now(),
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'].toString()) : DateTime.now(),
      );
    } catch (e) {
      print('Error parsing SubscriptionPlan: $e');
      print('JSON: $json');
      rethrow;
    }
  }
}