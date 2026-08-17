import 'dart:convert';

List<AllAuthorModel> allAuthorFromJson(String str) => List<AllAuthorModel>.from(
  json.decode(str).map((x) => AllAuthorModel.fromJson(x)),
);

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

  factory AuthorDetailModel.fromJson(Map<String, dynamic> json) =>
      AuthorDetailModel(
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
  final List<NewBookItem> items;
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
      items: (json['items'] as List)
          .map((i) => NewBookItem.fromJson(i))
          .toList(),
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
    );
  }
}

class NewBookItem {
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
  final String paymentIntentId;
  final String clientSecret;
  final Reader reader;
  final Author author;
  final String autographRequestId;
  final String bookId;

  NewBookItem({
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
    required this.paymentIntentId,
    required this.clientSecret,
    required this.reader,
    required this.author,
    required this.autographRequestId,
    required this.bookId,
  });

  // --- copyWith method ---
  NewBookItem copyWith({
    String? id,
    String? title,
    String? coverImage,
    String? bookPdfUrl,
    String? signedPdfUrl,
    String? personalMessage,
    String? status,
    String? rejectionReason,
    String? authorMessage,
    String? uploadDate,
    int? feeAmount,
    bool? isPaid,
    String? paymentIntentId,
    String? clientSecret,
    Reader? reader,
    Author? author,
    String? autographRequestId,
    String? bookId,
  }) {
    return NewBookItem(
      id: id ?? this.id,
      title: title ?? this.title,
      coverImage: coverImage ?? this.coverImage,
      bookPdfUrl: bookPdfUrl ?? this.bookPdfUrl,
      signedPdfUrl: signedPdfUrl ?? this.signedPdfUrl,
      personalMessage: personalMessage ?? this.personalMessage,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      authorMessage: authorMessage ?? this.authorMessage,
      uploadDate: uploadDate ?? this.uploadDate,
      feeAmount: feeAmount ?? this.feeAmount,
      isPaid: isPaid ?? this.isPaid,
      paymentIntentId: paymentIntentId ?? this.paymentIntentId,
      clientSecret: clientSecret ?? this.clientSecret,
      reader: reader ?? this.reader,
      author: author ?? this.author,
      autographRequestId: autographRequestId ?? this.autographRequestId,
      bookId: bookId ?? this.bookId,
    );
  }

  factory NewBookItem.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = Map<String, dynamic>.from(json);

    final dynamic bookJson = _firstMap(data, [
      'book',
      'bookData',
      'bookDetails',
      'ebook',
    ]);
    final dynamic readerJson = _firstMap(data, [
      'reader',
      'readerData',
      'readerDetails',
    ]);
    final dynamic authorJson = _firstMap(data, [
      'author',
      'authorData',
      'authorDetails',
      'authorInfo',
    ]);

    return NewBookItem(
      id: data['id']?.toString() ?? '',
      title: _stringValue(
        data,
        ['bookTitle', 'title', 'name'],
        fallback: _stringValue(
          bookJson is Map ? Map<String, dynamic>.from(bookJson) : {},
          ['title', 'name'],
        ),
      ),
      coverImage: _stringValue(
        data,
        ['coverImage', 'imageUrl'],
        fallback: _stringValue(
          bookJson is Map ? Map<String, dynamic>.from(bookJson) : {},
          ['coverImage', 'imageUrl'],
        ),
      ),
      bookPdfUrl: _stringValue(data, ['bookPdfUrl', 'book_pdf_url', 'pdfUrl']),
      signedPdfUrl: _stringValue(data, ['signedPdfUrl', 'signed_pdf_url']),
      personalMessage: _stringValue(
        data,
        ['personalMessage', 'message', 'note'],
        fallback: _stringValue(
          bookJson is Map ? Map<String, dynamic>.from(bookJson) : {},
          ['message'],
        ),
      ),
      status: _stringValue(data, ['status', 'requestStatus', 'state']),
      rejectionReason: _stringValue(data, [
        'rejectionReason',
        'rejection_reason',
      ]),
      authorMessage: _stringValue(data, ['authorMessage', 'author_message']),
      uploadDate: _stringValue(data, ['requestDate', 'createdAt', 'updatedAt']),
      feeAmount:
          int.tryParse(
            _stringValue(data, ['feeAmount', 'price', 'totalAmount']),
          ) ??
          0,
      isPaid: _boolValue(data, ['isPaid', 'is_paid', 'paid']),
      paymentIntentId: _stringValue(data, [
        'paymentIntentId',
        'payment_intent_id',
      ]),
      clientSecret: _stringValue(data, ['clientSecret', 'client_secret']),
      autographRequestId: _stringValue(data, ['autographRequestId', 'autograph_request_id']),
      bookId: _stringValue(
        data,
        ['bookId', 'book_id'],
        fallback: _stringValue(
          bookJson is Map ? Map<String, dynamic>.from(bookJson) : {},
          ['id'],
        ),
      ),
      reader: Reader.fromJson(
        Map<String, dynamic>.from(readerJson is Map ? readerJson : {}),
      ),
      author: Author.fromJson({
        'id': _stringValue(
          authorJson is Map ? Map<String, dynamic>.from(authorJson) : {},
          ['id'],
        ),
        'fullName': _stringValue(
          authorJson is Map ? Map<String, dynamic>.from(authorJson) : {},
          ['fullName', 'name', 'authorName'],
        ),
        'profilePicture': _stringValue(
          authorJson is Map ? Map<String, dynamic>.from(authorJson) : {},
          ['profilePicture', 'avatar'],
        ),
        'bio': _stringValue(
          authorJson is Map ? Map<String, dynamic>.from(authorJson) : {},
          ['bio', 'about'],
        ),
        'dateJoined': _stringValue(
          authorJson is Map ? Map<String, dynamic>.from(authorJson) : {},
          ['dateJoined', 'createdAt'],
        ),
      }),
    );
  }

  static NewBookItem? fromResponse(dynamic response) {
    if (response is Map<String, dynamic>) {
      Map<String, dynamic> merged = Map<String, dynamic>.from(response);
      if (merged.containsKey('data') && merged['data'] is Map) {
        final innerData = Map<String, dynamic>.from(merged['data']);
        if ((innerData['clientSecret'] == null || innerData['clientSecret'].toString().isEmpty) &&
            merged['clientSecret'] != null) {
          innerData['clientSecret'] = merged['clientSecret'];
        }
        if ((innerData['paymentIntentId'] == null || innerData['paymentIntentId'].toString().isEmpty) &&
            merged['paymentIntentId'] != null) {
          innerData['paymentIntentId'] = merged['paymentIntentId'];
        }
        merged = innerData;
      } else if (merged.containsKey('request') && merged['request'] is Map) {
        final requestMap = Map<String, dynamic>.from(merged['request']);
        if (merged.containsKey('clientSecret'))
          requestMap['clientSecret'] = merged['clientSecret'];
        if (merged.containsKey('paymentIntentId'))
          requestMap['paymentIntentId'] = merged['paymentIntentId'];
        merged = requestMap;
      }
      return NewBookItem.fromJson(merged);
    }
    return null;
  }
}

// Helpers
dynamic _firstMap(Map<String, dynamic> data, List<String> keys) {
  for (final key in keys) {
    if (data[key] is Map) return data[key];
  }
  return {};
}

String _stringValue(
  Map<String, dynamic> data,
  List<String> keys, {
  String fallback = '',
}) {
  for (final key in keys) {
    if (data[key] != null) return data[key].toString();
  }
  return fallback;
}

bool _boolValue(Map<String, dynamic> data, List<String> keys) {
  for (final key in keys) {
    if (data[key] == true || data[key].toString().toLowerCase() == 'true')
      return true;
  }
  return false;
}

class Reader {
  final String id;
  final String fullName;
  final String profilePicture;

  Reader({
    required this.id,
    required this.fullName,
    required this.profilePicture,
  });

  factory Reader.fromJson(Map<String, dynamic> json) {
    return Reader(
      id: json['id']?.toString() ?? '',
      fullName: _stringValue(Map<String, dynamic>.from(json), [
        'fullName',
        'name',
        'full_name',
      ]),
      profilePicture: _stringValue(Map<String, dynamic>.from(json), [
        'profilePicture',
        'profile_picture',
        'avatar',
        'image',
      ]),
    );
  }
}

class Author {
  final String id;
  final String fullName;
  final String? profilePicture;
  final String bio;
  final String dateJoined;

  Author({
    required this.id,
    required this.fullName,
    this.profilePicture,
    required this.bio,
    required this.dateJoined,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json);
    return Author(
      id: data['id']?.toString() ?? '',
      fullName: _stringValue(data, [
        'fullName',
        'name',
        'full_name',
        'authorName',
      ]),
      profilePicture: _stringValue(data, [
        'profilePicture',
        'profile_picture',
        'avatar',
        'image',
      ]),
      bio: _stringValue(data, ['bio', 'about']),
      dateJoined: _stringValue(data, [
        'dateJoined',
        'joinedAt',
        'createdAt',
        'created_at',
      ]),
    );
  }
}
