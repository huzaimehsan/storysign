class ReaderLibraryBookDetailModel {
  final String id;
  final String title;
  final String coverImage;
  final String pdfUrl;
  final String status;
  final String uploadDate;
  final String? signedPdfUrl;
  final String? downloadUrl;
  final bool isPaid;
  final num feeAmount;
  final String authorName;
  final String? authorProfilePicture;
  final String personalMessage;
  final String? autographRequestId;
  final String? paymentIntentId;
  final String? clientSecret;

  ReaderLibraryBookDetailModel({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.pdfUrl,
    required this.status,
    required this.uploadDate,
    this.signedPdfUrl,
    this.downloadUrl,
    required this.isPaid,
    required this.feeAmount,
    required this.authorName,
    this.authorProfilePicture,
    required this.personalMessage,
    this.autographRequestId,
    this.paymentIntentId,
    this.clientSecret,
  });

  factory ReaderLibraryBookDetailModel.fromJson(Map<String, dynamic> json) {
    final author = json['author'];
    final authorName =
        (author is Map<String, dynamic> ? author['fullName'] : null) ??
        json['authorName'] ??
        '';

    return ReaderLibraryBookDetailModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      coverImage: json['coverImage']?.toString() ?? '',
      pdfUrl: json['pdfUrl']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      uploadDate: json['uploadDate']?.toString() ?? '',
      signedPdfUrl: json['signedPdfUrl']?.toString(),
      downloadUrl: json['downloadUrl']?.toString(),
      isPaid: json['isPaid'] == true,
      feeAmount: json['feeAmount'] ?? 0,
      authorName: authorName.toString(),
      authorProfilePicture: (author is Map ? author['profilePicture'] : null)
          ?.toString(),
      personalMessage: json['personalMessage']?.toString() ?? '',
      autographRequestId: json['autographRequestId']?.toString(),
      paymentIntentId: json['paymentIntentId']?.toString(),
      clientSecret: json['clientSecret']?.toString(),
    );
  }
}
