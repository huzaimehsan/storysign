class MyBookModel {
  final String id;
  final String title;
  final String coverImage;
  final String pdfUrl;
  final String? signedPdfUrl;
  final String status;
  final String uploadDate;
  final String readerId;
  final String autographRequestId;

  MyBookModel({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.pdfUrl,
    this.signedPdfUrl,
    required this.status,
    required this.uploadDate,
    required this.readerId,
    required this.autographRequestId,
  });

  factory MyBookModel.fromJson(Map<String, dynamic> json) {
    return MyBookModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      coverImage: json['coverImage'] ?? '',
      pdfUrl: json['pdfUrl'] ?? '',
      signedPdfUrl: json['signedPdfUrl'],
      status: json['status'] ?? '',
      uploadDate: json['uploadDate'] ?? '',
      readerId: json['readerId'] ?? '',
      autographRequestId: json['autographRequestId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'coverImage': coverImage,
      'pdfUrl': pdfUrl,
      'signedPdfUrl': signedPdfUrl,
      'status': status,
      'uploadDate': uploadDate,
      'readerId': readerId,
      'autographRequestId': autographRequestId,
    };
  }
}

class MyBooksResponse {
  final List<MyBookModel> items;
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
          .map((e) => MyBookModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}