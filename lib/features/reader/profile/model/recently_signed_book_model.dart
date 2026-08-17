class AuthorProfileModel {
  final String id;
  final String fullName;
  final String? profilePicture;

  AuthorProfileModel({
    required this.id,
    required this.fullName,
    this.profilePicture,
  });

  factory AuthorProfileModel.fromJson(Map<String, dynamic> json) {
    return AuthorProfileModel(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      profilePicture: json['profilePicture']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'profilePicture': profilePicture,
    };
  }
}

class MyProfileBookModel {
  final String id;
  final String title;
  final String coverImage;
  final String pdfUrl;
  final String? signedPdfUrl;
  final String? downloadUrl;
  final String status;
  final String uploadDate;
  final String readerId;
  final String autographRequestId;
  final bool fromLibrary;
  final double feeAmount;
  final String authorName;
  final AuthorProfileModel? author;

  MyProfileBookModel({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.pdfUrl,
    this.signedPdfUrl,
    this.downloadUrl,
    required this.status,
    required this.uploadDate,
    required this.readerId,
    required this.autographRequestId,
    required this.fromLibrary,
    required this.feeAmount,
    required this.authorName,
    this.author,
  });

  factory MyProfileBookModel.fromJson(Map<String, dynamic> json) {
    return MyProfileBookModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      coverImage: json['coverImage']?.toString() ?? '',
      pdfUrl: json['pdfUrl']?.toString() ?? '',
      signedPdfUrl: json['signedPdfUrl']?.toString(),
      downloadUrl: json['downloadUrl']?.toString(),
      status: json['status']?.toString() ?? '',
      uploadDate: json['uploadDate']?.toString() ?? '',
      readerId: json['readerId']?.toString() ?? '',
      autographRequestId: json['autographRequestId']?.toString() ?? '',
      fromLibrary: json['fromLibrary'] ?? false,
      feeAmount: (json['feeAmount'] != null) ? (json['feeAmount'] as num).toDouble() : 0.0,
      authorName: json['authorName']?.toString() ?? '',
      author: json['author'] != null ? AuthorProfileModel.fromJson(json['author'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'coverImage': coverImage,
      'pdfUrl': pdfUrl,
      'signedPdfUrl': signedPdfUrl,
      'downloadUrl': downloadUrl,
      'status': status,
      'uploadDate': uploadDate,
      'readerId': readerId,
      'autographRequestId': autographRequestId,
      'fromLibrary': fromLibrary,
      'feeAmount': feeAmount,
      'authorName': authorName,
      'author': author?.toJson(),
    };
  }
}

class MyBooksResponse {
  final List<MyProfileBookModel> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  MyBooksResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory MyBooksResponse.fromJson(Map<String, dynamic> json) {
    return MyBooksResponse(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => MyProfileBookModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}