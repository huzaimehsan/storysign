class activeSubscription {
  final String planId;
  final String planName;
  final double amountPaid;
  final String startedAt;
  final String nextBillingAt;
  final int signsUsed;
  final int signQuota;
  final int remainingSigns;

  activeSubscription({
    required this.planId,
    required this.planName,
    required this.amountPaid,
    required this.startedAt,
    required this.nextBillingAt,
    required this.signsUsed,
    required this.signQuota,
    required this.remainingSigns,
  });

  factory activeSubscription.fromJson(Map<String, dynamic> json) {
    return activeSubscription(
      planId: json['planId']?.toString() ??
          json['_id']?.toString() ??
          json['id']?.toString() ??
          '',
      planName: json['planName'] ?? '',
      amountPaid: (json['amountPaid'] is num)
          ? (json['amountPaid'] as num).toDouble()
          : double.tryParse(json['amountPaid']?.toString() ?? '') ?? 0.0,
      startedAt: json['startedAt'] ?? '',
      nextBillingAt: json['nextBillingAt'] ?? '',
      signsUsed: (json['signsUsed'] is num)
          ? (json['signsUsed'] as num).toInt()
          : int.tryParse(json['signsUsed']?.toString() ?? '') ?? 0,
      signQuota: (json['signQuota'] is num)
          ? (json['signQuota'] as num).toInt()
          : int.tryParse(json['signQuota']?.toString() ?? '') ?? 0,
      remainingSigns: (json['remainingSigns'] is num)
          ? (json['remainingSigns'] as num).toInt()
          : int.tryParse(json['remainingSigns']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planId': planId,
      'planName': planName,
      'amountPaid': amountPaid,
      'startedAt': startedAt,
      'nextBillingAt': nextBillingAt,
      'signsUsed': signsUsed,
      'signQuota': signQuota,
      'remainingSigns': remainingSigns,
    };
  }
}