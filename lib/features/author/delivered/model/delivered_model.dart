class UserModel {
  final String id;
  final String fullName;
  final String? profilePicture;
  final String? bio;
  final String? dateJoined;

  UserModel({
    required this.id,
    required this.fullName,
    this.profilePicture,
    this.bio,
    this.dateJoined,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      profilePicture: json['profilePicture']?.toString(),
      bio: json['bio']?.toString(),
      dateJoined: json['dateJoined']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'profilePicture': profilePicture,
      'bio': bio,
      'dateJoined': dateJoined,
    };
  }
}

class DeliveryItemModel {
  final String id;
  final String bookTitle;
  final String coverImage;
  final String bookPdfUrl;
  final String signedPdfUrl;
  final String personalMessage;
  final String status;
  final String? rejectionReason;
  final String authorMessage;
  final String requestDate;
  final double feeAmount;
  final bool fromLibrary;
  final bool isPaid;
  final UserModel? reader;
  final UserModel? author;

  DeliveryItemModel({
    required this.id,
    required this.bookTitle,
    required this.coverImage,
    required this.bookPdfUrl,
    required this.signedPdfUrl,
    required this.personalMessage,
    required this.status,
    this.rejectionReason,
    required this.authorMessage,
    required this.requestDate,
    required this.feeAmount,
    required this.fromLibrary,
    required this.isPaid,
    this.reader,
    this.author,
  });

  factory DeliveryItemModel.fromJson(Map<String, dynamic> json) {
    return DeliveryItemModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      bookTitle: json['bookTitle']?.toString() ?? '',
      coverImage: json['coverImage']?.toString() ?? '',
      bookPdfUrl: json['bookPdfUrl']?.toString() ?? '',
      signedPdfUrl: json['signedPdfUrl']?.toString() ?? '',
      personalMessage: json['personalMessage']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      rejectionReason: json['rejectionReason']?.toString(),
      authorMessage: json['authorMessage']?.toString() ?? '',
      requestDate: json['requestDate']?.toString() ?? '',
      feeAmount: json['feeAmount'] != null ? (json['feeAmount'] as num).toDouble() : 0.0,
      fromLibrary: json['fromLibrary'] ?? false,
      isPaid: json['isPaid'] ?? false,
      reader: json['reader'] != null ? UserModel.fromJson(json['reader'] as Map<String, dynamic>) : null,
      author: json['author'] != null ? UserModel.fromJson(json['author'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookTitle': bookTitle,
      'coverImage': coverImage,
      'bookPdfUrl': bookPdfUrl,
      'signedPdfUrl': signedPdfUrl,
      'personalMessage': personalMessage,
      'status': status,
      'rejectionReason': rejectionReason,
      'authorMessage': authorMessage,
      'requestDate': requestDate,
      'feeAmount': feeAmount,
      'fromLibrary': fromLibrary,
      'isPaid': isPaid,
      'reader': reader?.toJson(),
      'author': author?.toJson(),
    };
  }
}

class DeliveryResponse {
  final List<DeliveryItemModel> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  DeliveryResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory DeliveryResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryResponse(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => DeliveryItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
    };
  }
}