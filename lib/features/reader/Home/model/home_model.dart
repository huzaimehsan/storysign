import 'dart:convert';

// List parsing functions ka naam update kiya
List<AllAuthorModel> allAuthorFromJson(String str) =>
    List<AllAuthorModel>.from(json.decode(str).map((x) => AllAuthorModel.fromJson(x)));

String allAuthorToJson(List<AllAuthorModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllAuthorModel {
  String id;
  String fullName;
  dynamic profilePicture;
  String bio;
  DateTime dateJoined;

  AllAuthorModel({
    required this.id,
    required this.fullName,
    required this.profilePicture,
    required this.bio,
    required this.dateJoined,
  });

  factory AllAuthorModel.fromJson(Map<String, dynamic> json) => AllAuthorModel(
    id: json["id"]?.toString() ?? "",
    fullName: json["fullName"]?.toString() ?? "Author",
    profilePicture: json["profilePicture"],
    bio: json["bio"]?.toString() ?? "",
    dateJoined: _parseDate(json["dateJoined"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "profilePicture": profilePicture,
    "bio": bio,
    "dateJoined": dateJoined.toIso8601String(),
  };
}

class AuthorDetailModel {
  String id;
  String fullName;
  dynamic profilePicture;
  String bio;
  DateTime dateJoined;

  AuthorDetailModel({
    required this.id,
    required this.fullName,
    required this.profilePicture,
    required this.bio,
    required this.dateJoined,
  });

  factory AuthorDetailModel.fromJson(Map<String, dynamic> json) => AuthorDetailModel(
    id: json["id"]?.toString() ?? "",
    fullName: json["fullName"]?.toString() ?? "Author",
    profilePicture: json["profilePicture"],
    bio: json["bio"]?.toString() ?? "",
    dateJoined: _parseDate(json["dateJoined"]),
  );
}

DateTime _parseDate(dynamic value) {
  if (value == null) {
    return DateTime.now();
  }

  if (value is DateTime) {
    return value;
  }

  if (value is String) {
    try {
      return DateTime.parse(value);
    } catch (_) {
      return DateTime.now();
    }
  }

  return DateTime.now();
}




class TrackRequestModel {
  final List<BookItem> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  TrackRequestModel({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory TrackRequestModel.fromJson(Map<String, dynamic> json) {
    return TrackRequestModel(
      items: (json['items'] as List).map((i) => BookItem.fromJson(i)).toList(),
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
    );
  }
}

class BookItem {
  final String id;
  final String title; // Aapka JSON mein bookTitle hai
  final String coverImage;
  final String bookPdfUrl;
  final String? signedPdfUrl;
  final String personalMessage;
  final String status;
  final String? rejectionReason;
  final String? authorMessage;
  final String uploadDate; // Aapka JSON mein requestDate hai
  final int feeAmount;
  final bool isPaid;
  final Reader reader;
  final Author author;

  BookItem({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.bookPdfUrl,
    this.signedPdfUrl,
    required this.personalMessage,
    required this.status,
    this.rejectionReason,
    this.authorMessage,
    required this.uploadDate,
    required this.feeAmount,
    required this.isPaid,
    required this.reader,
    required this.author,
  });

  factory BookItem.fromJson(Map<String, dynamic> json) {
    return BookItem(
      id: json['id'],
      title: json['bookTitle'],
      coverImage: json['coverImage'],
      bookPdfUrl: json['bookPdfUrl'],
      signedPdfUrl: json['signedPdfUrl'],
      personalMessage: json['personalMessage'],
      status: json['status'],
      rejectionReason: json['rejectionReason'],
      authorMessage: json['authorMessage'],
      uploadDate: json['requestDate'],
      feeAmount: json['feeAmount'],
      isPaid: json['isPaid'],
      reader: Reader.fromJson(json['reader']),
      author: Author.fromJson(json['author']),
    );
  }
}

class Reader {
  final String id;
  final String fullName;
  final String profilePicture;

  Reader({required this.id, required this.fullName, required this.profilePicture});

  factory Reader.fromJson(Map<String, dynamic> json) {
    return Reader(
      id: json['id'],
      fullName: json['fullName'],
      profilePicture: json['profilePicture'] ?? '',
    );
  }
}

class Author {
  final String id;
  final String fullName;
  final String? profilePicture;
  final String bio;
  final String dateJoined;

  Author({required this.id, required this.fullName, this.profilePicture, required this.bio, required this.dateJoined});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      fullName: json['fullName'],
      profilePicture: json['profilePicture'],
      bio: json['bio'],
      dateJoined: json['dateJoined'],
    );
  }
}