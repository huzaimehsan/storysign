class PaginatedAutographResponse {
  final List<AutographItemModel> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  PaginatedAutographResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginatedAutographResponse.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List? ?? [];
    List<AutographItemModel> itemsList =
    list.map((i) => AutographItemModel.fromJson(i)).toList();

    return PaginatedAutographResponse(
      items: itemsList,
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}

class AutographItemModel {
  final String id;
  final String bookTitle;
  final String coverImage;
  final String bookPdfUrl;
  final String? signedPdfUrl;
  final String personalMessage;
  final String status;
  final String? rejectionReason;
  final String? authorMessage;
  final String requestDate;
  final num feeAmount;
  final bool isPaid;
  final ReaderModel reader;
  final AuthorDetailModel author;
  final String? signaturePlacement;
  final String bookId;

  AutographItemModel({
    required this.id,
    required this.bookTitle,
    required this.coverImage,
    required this.bookPdfUrl,
    this.signedPdfUrl,
    required this.personalMessage,
    required this.status,
    this.rejectionReason,
    this.authorMessage,
    required this.requestDate,
    required this.feeAmount,
    required this.isPaid,
    required this.reader,
    required this.author,
    this.signaturePlacement,
    required this.bookId,
  });

  factory AutographItemModel.fromJson(Map<String, dynamic> json) {
    return AutographItemModel(
      id: json['id'] ?? '',
      bookTitle: json['bookTitle'] ?? '',
      coverImage: json['coverImage'] ?? '',
      bookPdfUrl: json['bookPdfUrl'] ?? '',
      signedPdfUrl: json['signedPdfUrl'],
      personalMessage: json['personalMessage'] ?? '',
      status: json['status'] ?? 'submitted',
      rejectionReason: json['rejectionReason'],
      authorMessage: json['authorMessage'],
      requestDate: json['requestDate'] ?? '',
      feeAmount: json['feeAmount'] ?? 0,
      isPaid: json['isPaid'] ?? false,
      reader: ReaderModel.fromJson(json['reader'] ?? {}),
      author: AuthorDetailModel.fromJson(json['author'] ?? {}),
      signaturePlacement: json['signaturePlacement'],
      bookId: json['bookId'] ?? '',
    );
  }
}

class ReaderModel {
  final String id;
  final String fullName;
  final String profilePicture;
  final String email;

  ReaderModel({
    required this.id,
    required this.fullName,
    required this.profilePicture,
    required this.email,
  });

  factory ReaderModel.fromJson(Map<String, dynamic> json) {
    return ReaderModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class AuthorDetailModel {
  final String id;
  final String fullName;
  final String? profilePicture;
  final String bio;
  final String dateJoined;

  AuthorDetailModel({
    required this.id,
    required this.fullName,
    this.profilePicture,
    required this.bio,
    required this.dateJoined,
  });

  factory AuthorDetailModel.fromJson(Map<String, dynamic> json) {
    return AuthorDetailModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      profilePicture: json['profilePicture'],
      bio: json['bio'] ?? '',
      dateJoined: json['dateJoined'] ?? '',
    );
  }
}