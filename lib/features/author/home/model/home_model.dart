class SubscriptionStats {
  final int totalSignRequests;
  final int signedBooks;
  final int remainingSigns;
  final int pendingRequests;

  SubscriptionStats({
    required this.totalSignRequests,
    required this.signedBooks,
    required this.remainingSigns,
    required this.pendingRequests,
  });

  // JSON se Object banane ke liye factory
  factory SubscriptionStats.fromJson(Map<String, dynamic> json) {
    return SubscriptionStats(
      totalSignRequests: json['totalSignRequests'] ?? 0,
      signedBooks: json['signedBooks'] ?? 0,
      remainingSigns: json['remainingSigns'] ?? 0,
      pendingRequests: json['pendingRequests'] ?? 0,
    );
  }

  // Object ko JSON mein convert karne ke liye (agar zaroorat pade)
  Map<String, dynamic> toJson() {
    return {
      'totalSignRequests': totalSignRequests,
      'signedBooks': signedBooks,
      'remainingSigns': remainingSigns,
      'pendingRequests': pendingRequests,
    };
  }
}