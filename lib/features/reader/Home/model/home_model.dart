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
  final String title;
  final String coverImage;
  final String bookPdfUrl;
  final String? signedPdfUrl;
  final String personalMessage;
  final String status;
  final String? rejectionReason;
  final String? authorMessage;
  final String uploadDate;
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
    final Map<String, dynamic> data = Map<String, dynamic>.from(json);
    final dynamic bookJson = _firstMap(data, ['book', 'bookData', 'bookDetails', 'ebook']);
    final dynamic readerJson = _firstMap(data, ['reader', 'readerData', 'readerDetails']);
    final dynamic authorJson = _firstMap(data, ['author', 'authorData', 'authorDetails', 'authorInfo']);

    final title = _stringValue(data, ['bookTitle', 'title', 'book_title', 'bookName', 'name'], fallback: _stringValue(bookJson is Map ? Map<String, dynamic>.from(bookJson) : {}, ['title', 'bookTitle', 'book_title', 'name']));
    final coverImage = _stringValue(data, ['coverImage', 'cover_image', 'coverImageUrl', 'imageUrl', 'bookCover'], fallback: _stringValue(bookJson is Map ? Map<String, dynamic>.from(bookJson) : {}, ['coverImage', 'cover_image', 'coverImageUrl', 'imageUrl', 'bookCover']));
    final personalMessage = _stringValue(data, ['personalMessage', 'message', 'personal_message', 'note', 'requestMessage'], fallback: _stringValue(bookJson is Map ? Map<String, dynamic>.from(bookJson) : {}, ['personalMessage', 'message', 'personal_message', 'note']));
    final status = _stringValue(data, ['status', 'requestStatus', 'request_status', 'state']);
    final feeAmountText = _stringValue(data, ['feeAmount', 'fee_amount', 'price', 'totalAmount', 'total_amount']);
    final isPaid = _boolValue(data, ['isPaid', 'is_paid', 'paid']);
    final uploadDate = _stringValue(data, ['requestDate', 'createdAt', 'created_at', 'updatedAt', 'updated_at']);
    final authorName = _stringValue(authorJson is Map ? Map<String, dynamic>.from(authorJson) : {}, ['fullName', 'name', 'authorName', 'full_name']);
    final authorProfilePicture = _stringValue(authorJson is Map ? Map<String, dynamic>.from(authorJson) : {}, ['profilePicture', 'profile_picture', 'avatar', 'image']);
    final authorDateJoined = _stringValue(authorJson is Map ? Map<String, dynamic>.from(authorJson) : {}, ['dateJoined', 'joinedAt', 'createdAt', 'created_at']);

    return BookItem(
      id: data['id']?.toString() ?? '',
      title: title,
      coverImage: coverImage,
      bookPdfUrl: _stringValue(data, ['bookPdfUrl', 'book_pdf_url', 'pdfUrl', 'bookPdf']),
      signedPdfUrl: _stringValue(data, ['signedPdfUrl', 'signed_pdf_url']),
      personalMessage: personalMessage,
      status: status,
      rejectionReason: _stringValue(data, ['rejectionReason', 'rejection_reason']),
      authorMessage: _stringValue(data, ['authorMessage', 'author_message']),
      uploadDate: uploadDate,
      feeAmount: int.tryParse(feeAmountText) ?? 0,
      isPaid: isPaid,
      reader: Reader.fromJson(Map<String, dynamic>.from(readerJson is Map ? readerJson : {})),
      author: Author.fromJson({
        'id': _stringValue(authorJson is Map ? Map<String, dynamic>.from(authorJson) : {}, ['id']),
        'fullName': authorName,
        'profilePicture': authorProfilePicture,
        'bio': _stringValue(authorJson is Map ? Map<String, dynamic>.from(authorJson) : {}, ['bio', 'about']),
        'dateJoined': authorDateJoined,
      }),
    );
  }

  static BookItem? fromResponse(dynamic response) {
    if (response is Map<String, dynamic>) {
      if (response.containsKey('items') && response['items'] is List && (response['items'] as List).isNotEmpty) {
        final firstItem = (response['items'] as List).first;
        if (firstItem is Map) {
          return BookItem.fromJson(Map<String, dynamic>.from(firstItem));
        }
      }

      if (response.containsKey('data')) {
        return fromResponse(response['data']);
      }
      if (response.containsKey('request')) {
        return fromResponse(response['request']);
      }
      if (response.containsKey('autographRequest')) {
        return fromResponse(response['autographRequest']);
      }

      return BookItem.fromJson(response);
    }

    if (response is List && response.isNotEmpty) {
      final firstItem = response.first;
      if (firstItem is Map) {
        return BookItem.fromJson(Map<String, dynamic>.from(firstItem));
      }
    }

    return null;
  }
}

Map<String, dynamic>? _firstMap(Map<String, dynamic> data, List<String> keys) {
  for (final key in keys) {
    final value = data[key];
    if (value is Map) {
      return Map<String, dynamic>.from(value as dynamic);
    }
  }
  return null;
}

String _stringValue(Map<String, dynamic> data, List<String> keys, {String? fallback}) {
  for (final key in keys) {
    final value = data[key];
    if (value != null) {
      final stringValue = value.toString().trim();
      if (stringValue.isNotEmpty) {
        return stringValue;
      }
    }
  }
  return fallback ?? '';
}

bool _boolValue(Map<String, dynamic> data, List<String> keys, {bool fallback = false}) {
  for (final key in keys) {
    final value = data[key];
    if (value is bool) {
      return value;
    }
    if (value != null) {
      final stringValue = value.toString().trim().toLowerCase();
      if (stringValue == 'true') return true;
      if (stringValue == 'false') return false;
    }
  }
  return fallback;
}

class Reader {
  final String id;
  final String fullName;
  final String profilePicture;

  Reader({required this.id, required this.fullName, required this.profilePicture});

  factory Reader.fromJson(Map<String, dynamic> json) {
    return Reader(
      id: json['id']?.toString() ?? '',
      fullName: _stringValue(Map<String, dynamic>.from(json), ['fullName', 'name', 'full_name']),
      profilePicture: _stringValue(Map<String, dynamic>.from(json), ['profilePicture', 'profile_picture', 'avatar', 'image']),
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
    final data = Map<String, dynamic>.from(json);
    return Author(
      id: data['id']?.toString() ?? '',
      fullName: _stringValue(data, ['fullName', 'name', 'full_name', 'authorName']),
      profilePicture: _stringValue(data, ['profilePicture', 'profile_picture', 'avatar', 'image']),
      bio: _stringValue(data, ['bio', 'about']),
      dateJoined: _stringValue(data, ['dateJoined', 'joinedAt', 'createdAt', 'created_at']),
    );
  }
}