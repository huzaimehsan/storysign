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
class BookItem {
  final String id;
  final String title;
  final String coverImage;
  final String pdfUrl;
  final String? signedPdfUrl;
  final String status;
  final String uploadDate;
  final String readerId;
  final String? autographRequestId; // 💡 Yeh field add karein

  BookItem({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.pdfUrl,
    this.signedPdfUrl,
    required this.status,
    required this.uploadDate,
    required this.readerId,
    this.autographRequestId, // 💡 Constructor mein add karein
  });

  factory BookItem.fromJson(Map<String, dynamic> json) {
    return BookItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      coverImage: json['coverImage'] ?? '',
      pdfUrl: json['pdfUrl'] ?? '',
      signedPdfUrl: json['signedPdfUrl'],
      status: json['status'] ?? '',
      uploadDate: json['uploadDate'] ?? '',
      readerId: json['readerId'] ?? '',
      autographRequestId: json['autographRequestId'], // 💡 JSON se parse karein
    );
  }
}