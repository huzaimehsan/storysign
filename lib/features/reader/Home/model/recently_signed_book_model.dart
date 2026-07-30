class AuthorModel {
  final String id;
  final String fullName;
  final String? profilePicture;

  AuthorModel({
    required this.id,
    required this.fullName,
    this.profilePicture,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      profilePicture: json['profilePicture'],
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

class SignedBookModel {
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
  final String bookId;
  final bool fromLibrary;
  final num feeAmount;
  final String authorName;
  final AuthorModel? author;

  SignedBookModel({
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
    required this.bookId,
    required this.fromLibrary,
    required this.feeAmount,
    required this.authorName,
    this.author,
  });

  factory SignedBookModel.fromJson(Map<String, dynamic> json) {
    return SignedBookModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      coverImage: json['coverImage'] ?? '',
      pdfUrl: json['pdfUrl'] ?? '',
      signedPdfUrl: json['signedPdfUrl'],
      downloadUrl: json['downloadUrl'],
      status: json['status'] ?? '',
      uploadDate: json['uploadDate'] ?? '',
      readerId: json['readerId'] ?? '',
      autographRequestId: json['autographRequestId'] ?? '',
      bookId: json['bookId']?.toString() ??
          (json['book'] is Map ? json['book']['id']?.toString() : null) ??
          json['id']?.toString() ?? '',
      fromLibrary: json['fromLibrary'] ?? false,
      feeAmount: json['feeAmount'] ?? 0,
        authorName: json['authorName'] ?? (json['author'] != null && json['author'] is Map ? (json['author']['fullName'] as String?) ?? '' : ''),
        author: json['author'] != null
          ? AuthorModel.fromJson(json['author'] as Map<String, dynamic>)
          : null,
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
      'bookId': bookId,
      'fromLibrary': fromLibrary,
      'feeAmount': feeAmount,
      'authorName': authorName,
      'author': author?.toJson(),
    };
  }
}

class MyBooksResponse {
  final List<SignedBookModel> items;
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
          .map((e) => SignedBookModel.fromJson(e as Map<String, dynamic>))
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