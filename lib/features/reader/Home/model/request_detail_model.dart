import 'dart:convert';

// JSON String ko direct object mein convert karne ke liye helper function
RequestDetailModel bookResponseModelFromJson(String str) =>
    RequestDetailModel.fromJson(json.decode(str));

String bookResponseModelToJson(RequestDetailModel data) =>
    json.encode(data.toJson());

/// --- Main Response Model ---
class RequestDetailModel {
  final List<BookItem> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  RequestDetailModel({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory RequestDetailModel.fromJson(Map<String, dynamic> json) => RequestDetailModel(
    items: List<BookItem>.from(json["items"].map((x) => BookItem.fromJson(x))),
    total: json["total"] ?? 0,
    page: json["page"] ?? 1,
    limit: json["limit"] ?? 10,
    totalPages: json["totalPages"] ?? 1,
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "total": total,
    "page": page,
    "limit": limit,
    "totalPages": totalPages,
  };
}

/// --- Book Item Model ---
class BookItem {
  final String id;
  final String bookTitle;
  final String coverImage;
  final String bookPdfUrl;
  final String? signedPdfUrl;
  final String personalMessage;
  final String status;
  final String? rejectionReason;
  final String? authorMessage;
  final DateTime requestDate;
  final int feeAmount;
  final bool isPaid;
  final Reader reader;
  final Author author;

  // Stripe Fields Added
  final String? clientSecret;
  final String? paymentIntentId;

  BookItem({
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
    this.clientSecret,      // Added
    this.paymentIntentId,   // Added
  });

  factory BookItem.fromJson(Map<String, dynamic> json) => BookItem(
    id: json["id"] ?? "",
    bookTitle: json["bookTitle"] ?? "",
    coverImage: json["coverImage"] ?? "",
    bookPdfUrl: json["bookPdfUrl"] ?? "",
    signedPdfUrl: json["signedPdfUrl"],
    personalMessage: json["personalMessage"] ?? "",
    status: json["status"] ?? "submitted",
    rejectionReason: json["rejectionReason"],
    authorMessage: json["authorMessage"],
    requestDate: DateTime.parse(json["requestDate"] ?? DateTime.now().toIso8601String()),
    feeAmount: json["feeAmount"] ?? 0,
    isPaid: json["isPaid"] ?? false,
    reader: Reader.fromJson(json["reader"]),
    author: Author.fromJson(json["author"]),
    clientSecret: json["clientSecret"],       // Mapping added
    paymentIntentId: json["paymentIntentId"], // Mapping added
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bookTitle": bookTitle,
    "coverImage": coverImage,
    "bookPdfUrl": bookPdfUrl,
    "signedPdfUrl": signedPdfUrl,
    "personalMessage": personalMessage,
    "status": status,
    "rejectionReason": rejectionReason,
    "authorMessage": authorMessage,
    "requestDate": requestDate.toIso8601String(),
    "feeAmount": feeAmount,
    "isPaid": isPaid,
    "reader": reader.toJson(),
    "author": author.toJson(),
    "clientSecret": clientSecret,         // Mapping added
    "paymentIntentId": paymentIntentId,   // Mapping added
  };
}

/// --- Reader Model ---
class Reader {
  final String id;
  final String fullName;
  final String? profilePicture; // Nullable

  Reader({
    required this.id,
    required this.fullName,
    this.profilePicture,
  });

  factory Reader.fromJson(Map<String, dynamic> json) => Reader(
    id: json["id"] ?? "",
    fullName: json["fullName"] ?? "",
    profilePicture: json["profilePicture"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "profilePicture": profilePicture,
  };
}

/// --- Author Model ---
class Author {
  final String id;
  final String fullName;
  final String? profilePicture; // Nullable
  final String bio;
  final DateTime dateJoined;

  Author({
    required this.id,
    required this.fullName,
    this.profilePicture,
    required this.bio,
    required this.dateJoined,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
    id: json["id"] ?? "",
    fullName: json["fullName"] ?? "",
    profilePicture: json["profilePicture"],
    bio: json["bio"] ?? "",
    dateJoined: DateTime.parse(json["dateJoined"] ?? DateTime.now().toIso8601String()),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "profilePicture": profilePicture,
    "bio": bio,
    "dateJoined": dateJoined.toIso8601String(),
  };
}