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
}

class BookItem {
  final String id;
  final String title;
  final String coverImage;
  final String pdfUrl;
  final String? signedPdfUrl;
  final String? downloadUrl;
  final String status;
  final String uploadDate;
  final String readerId;
  final String? autographRequestId;
  final bool fromLibrary;
  final num feeAmount;
  final bool isPaid; // ✅ New field added from your JSON
  final String? authorName;
  final AuthorModel? author;

  BookItem({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.pdfUrl,
    this.signedPdfUrl,
    this.downloadUrl,
    required this.status,
    required this.uploadDate,
    required this.readerId,
    this.autographRequestId,
    required this.fromLibrary,
    required this.feeAmount,
    required this.isPaid,
    this.authorName,
    this.author,
  });

  factory BookItem.fromJson(Map<String, dynamic> json) {
    return BookItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      coverImage: json['coverImage'] ?? '',
      pdfUrl: json['pdfUrl'] ?? '',
      signedPdfUrl: json['signedPdfUrl'],
      downloadUrl: json['downloadUrl'],
      status: json['status'] ?? '',
      uploadDate: json['uploadDate'] ?? '',
      readerId: json['readerId'] ?? '',
      autographRequestId: json['autographRequestId'],
      fromLibrary: json['fromLibrary'] ?? false,
      feeAmount: json['feeAmount'] ?? 0,
      isPaid: json['isPaid'] ?? false, // ✅ Handled here safely
      authorName: json['authorName'] ?? 
          (json['author'] != null && json['author'] is Map 
              ? (json['author']['fullName'] as String?) 
              : null),
      author: json['author'] != null
          ? AuthorModel.fromJson(json['author'] as Map<String, dynamic>)
          : null,
    );
  }
}

class BookResponseModel {
  final List<BookItem> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  BookResponseModel({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory BookResponseModel.fromJson(Map<String, dynamic> json) {
    return BookResponseModel(
      items: (json['items'] as List?)?.map((e) => BookItem.fromJson(e)).toList() ?? [],
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}