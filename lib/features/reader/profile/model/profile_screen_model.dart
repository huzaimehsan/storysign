class AuthorHelpSupportModel {
  final String email;
  final String phone;
  final String supportUrl;

  AuthorHelpSupportModel({
    required this.email,
    required this.phone,
    required this.supportUrl,
  });

  factory AuthorHelpSupportModel.fromJson(Map<String, dynamic> json) {
    return AuthorHelpSupportModel(
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      supportUrl: json["supportUrl"] ?? "",
    );
  }
}

class FaqModel {
  final String id;
  final String question;
  final String answer;

  FaqModel({required this.id, required this.question, required this.answer});

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['_id'] ?? "", // '_id' key match karna zaroori hai
      question: json['question'] ?? "",
      answer: json['answer'] ?? "",
    );
  }
}

class ProfileModel {
  final String? profilePicture;
  final String email;
  final String fullName;
  final String dateJoined;

  ProfileModel({
    this.profilePicture,
    required this.email,
    required this.fullName,
    required this.dateJoined,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      profilePicture: json['profilePicture'], // null ho sakta hai
      email: json['email'] ?? "",
      fullName: json['fullName'] ?? "",
      dateJoined: json['dateJoined'] ?? "",
    );
  }
}

class LibraryStatsModel {
  int? totalUploadedBooks;
  int? signedBooks;
  int? signRejected;

  LibraryStatsModel({
    this.totalUploadedBooks,
    this.signedBooks,
    this.signRejected,
  });

  // JSON se Model banane ke liye
  factory LibraryStatsModel.fromJson(Map<String, dynamic> json) {
    return LibraryStatsModel(
      totalUploadedBooks: json['totalUploadedBooks'],
      signedBooks: json['signedBooks'],
      signRejected: json['signRejected'],
    );
  }
}

class BookResponse {
  List<BookItem> items;
  int total;
  int page;
  int limit;
  int totalPages;

  BookResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory BookResponse.fromJson(Map<String, dynamic> json) {
    return BookResponse(
      items: List<BookItem>.from(
        json['items'].map((x) => BookItem.fromJson(x)),
      ),
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
    );
  }
}

class BookItem {
  String id;
  String readerId;
  String bookId;
  String? autographRequestId; // null ho sakta hai
  String bookTitle;
  String downloadedFilePath;
  DateTime createdAt;
  DateTime updatedAt;

  BookItem({
    required this.id,
    required this.readerId,
    required this.bookId,
    this.autographRequestId,
    required this.bookTitle,
    required this.downloadedFilePath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookItem.fromJson(Map<String, dynamic> json) {
    return BookItem(
      id: json['_id'],
      readerId: json['readerId'],
      bookId: json['bookId'],
      autographRequestId: json['autographRequestId'],
      bookTitle: json['bookTitle'],
      downloadedFilePath: json['downloadedFilePath'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
