class ReaderModel {
  final String id;
  final String fullName;
  final String? profilePicture;
  final String email;

  ReaderModel({
    required this.id,
    required this.fullName,
    this.profilePicture,
    required this.email,
  });

  factory ReaderModel.fromJson(Map<String, dynamic> json) {
    return ReaderModel(
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
      email: json['email']?.toString() ?? '',
    );
  }
}

class AuthorDetailModel {
  final String id;
  final String fullName;
  final String? profilePicture;
  final String? bio;
  final String? dateJoined;

  AuthorDetailModel({
    required this.id,
    required this.fullName,
    this.profilePicture,
    this.bio,
    this.dateJoined,
  });

  factory AuthorDetailModel.fromJson(Map<String, dynamic> json) {
    return AuthorDetailModel(
      id: json['id']?.toString() ?? '',
      fullName: _stringValue(Map<String, dynamic>.from(json), [
        'fullName',
        'name',
        'full_name',
        'authorName',
      ]),
      profilePicture: _stringValue(Map<String, dynamic>.from(json), [
        'profilePicture',
        'profile_picture',
        'avatar',
        'image',
      ]),
      bio: _stringValue(Map<String, dynamic>.from(json), ['bio', 'about']),
      dateJoined: _stringValue(Map<String, dynamic>.from(json), [
        'dateJoined',
        'joinedAt',
        'createdAt',
        'created_at',
      ]),
    );
  }
}

class SignaturePlacementModel {
  final int pageIndex;
  final num xRatio;
  final num yRatio;
  final num widthRatio;
  final num heightRatio;
  final num pageWidthPts;
  final num pageHeightPts;
  final String signatureImagePath;
  final String? signatureImageUrl;
  final String? paidAt;
  final String? stripePaymentIntentId;
  final String? createdAt;
  final String? updatedAt;

  SignaturePlacementModel({
    required this.pageIndex,
    required this.xRatio,
    required this.yRatio,
    required this.widthRatio,
    required this.heightRatio,
    required this.pageWidthPts,
    required this.pageHeightPts,
    required this.signatureImagePath,
    this.signatureImageUrl,
    this.paidAt,
    this.stripePaymentIntentId,
    this.createdAt,
    this.updatedAt,
  });

  factory SignaturePlacementModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? parent = json['\$__parent'] is Map
        ? Map<String, dynamic>.from(json['\$__parent'])
        : null;

    Map<String, dynamic> coordsData;
    if (json.containsKey('_doc') && json['_doc'] is Map) {
      coordsData = Map<String, dynamic>.from(json['_doc']);
    } else if (parent != null && parent['signaturePlacement'] is Map) {
      coordsData = Map<String, dynamic>.from(parent['signaturePlacement']);
    } else {
      coordsData = json;
    }

    return SignaturePlacementModel(
      pageIndex: int.tryParse(coordsData['pageIndex']?.toString() ?? '') ?? 0,
      xRatio: num.tryParse(coordsData['xRatio']?.toString() ?? '') ?? 0,
      yRatio: num.tryParse(coordsData['yRatio']?.toString() ?? '') ?? 0,
      widthRatio: num.tryParse(coordsData['widthRatio']?.toString() ?? '') ?? 0,
      heightRatio:
          num.tryParse(coordsData['heightRatio']?.toString() ?? '') ?? 0,
      pageWidthPts:
          num.tryParse(coordsData['pageWidthPts']?.toString() ?? '') ?? 0,
      pageHeightPts:
          num.tryParse(coordsData['pageHeightPts']?.toString() ?? '') ?? 0,
      signatureImagePath: coordsData['signatureImagePath']?.toString() ?? '',
      signatureImageUrl: json['signatureImageUrl']?.toString(),
      paidAt: parent?['paidAt']?.toString(),
      stripePaymentIntentId: parent?['stripePaymentIntentId']?.toString(),
      createdAt: parent?['createdAt']?.toString(),
      updatedAt: parent?['updatedAt']?.toString(),
    );
  }
}

class TrackingModel {
  final String id;
  final String bookTitle;
  final String coverImage;
  final String bookPdfUrl;
  final String? signedPdfUrl;
  final String? personalMessage;
  final String status;
  final String? rejectionReason;
  final String? authorMessage;
  final String requestDate;
  final num feeAmount;
  final bool fromLibrary;
  final bool isPaid;
  final ReaderModel? reader;
  final AuthorDetailModel? author;
  final SignaturePlacementModel? signaturePlacement;
  final String bookId;

  TrackingModel({
    required this.id,
    required this.bookTitle,
    required this.coverImage,
    required this.bookPdfUrl,
    this.signedPdfUrl,
    this.personalMessage,
    required this.status,
    this.rejectionReason,
    this.authorMessage,
    required this.requestDate,
    required this.feeAmount,
    required this.fromLibrary,
    required this.isPaid,
    this.reader,
    this.author,
    this.signaturePlacement,
    required this.bookId,
  });

  String? get deliveredDateApprox =>
      status == 'delivered' ? signaturePlacement?.paidAt : null;

  factory TrackingModel.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json);
    final nestedBook = _firstMap(data, [
      'book',
      'bookData',
      'bookDetails',
      'ebook',
    ]);
    final nestedAuthor = _firstMap(data, [
      'author',
      'authorData',
      'authorDetails',
      'authorInfo',
    ]);
    final nestedReader = _firstMap(data, [
      'reader',
      'readerData',
      'readerDetails',
    ]);

    final bookTitle = _stringValue(
      data,
      ['bookTitle', 'title', 'book_title', 'bookName', 'name'],
      fallback: _stringValue(
        nestedBook != null ? Map<String, dynamic>.from(nestedBook) : {},
        ['title', 'bookTitle', 'book_title', 'name'],
      ),
    );

    final coverImage = _stringValue(
      data,
      ['coverImage', 'cover_image', 'coverImageUrl', 'imageUrl', 'bookCover'],
      fallback: _stringValue(
        nestedBook != null ? Map<String, dynamic>.from(nestedBook) : {},
        ['coverImage', 'cover_image', 'coverImageUrl', 'imageUrl', 'bookCover'],
      ),
    );

    final bookPdfUrl = _stringValue(
      data,
      ['bookPdfUrl', 'book_pdf_url', 'pdfUrl', 'bookPdf'],
      fallback: _stringValue(
        nestedBook != null ? Map<String, dynamic>.from(nestedBook) : {},
        ['pdfUrl', 'bookPdfUrl', 'book_pdf_url'],
      ),
    );

    final authorData = _ensureMap(nestedAuthor);
    final readerData = _ensureMap(nestedReader);

    return TrackingModel(
      id: data['id']?.toString() ?? '',
      bookTitle: bookTitle,
      coverImage: coverImage,
      bookPdfUrl: bookPdfUrl,
      signedPdfUrl: _stringValue(data, ['signedPdfUrl', 'signed_pdf_url']),
      personalMessage: _stringValue(data, [
        'personalMessage',
        'message',
        'personal_message',
        'note',
        'requestMessage',
      ]),
      status: _stringValue(data, [
        'status',
        'requestStatus',
        'request_status',
        'state',
      ]),
      rejectionReason: _stringValue(data, [
        'rejectionReason',
        'rejection_reason',
      ]),
      authorMessage: _stringValue(data, ['authorMessage', 'author_message']),
      requestDate: _stringValue(data, [
        'requestDate',
        'createdAt',
        'created_at',
        'updatedAt',
        'updated_at',
      ]),
      feeAmount:
          num.tryParse(
            _stringValue(data, [
              'feeAmount',
              'fee_amount',
              'price',
              'totalAmount',
              'total_amount',
            ]),
          ) ??
          0,
      fromLibrary: _boolValue(data, ['fromLibrary', 'from_library']),
      isPaid: _boolValue(data, ['isPaid', 'is_paid', 'paid']),
      reader: readerData.isNotEmpty ? ReaderModel.fromJson(readerData) : null,
      author: authorData.isNotEmpty
          ? AuthorDetailModel.fromJson(authorData)
          : null,
      signaturePlacement: data['signaturePlacement'] != null
          ? SignaturePlacementModel.fromJson(
              _ensureMap(data['signaturePlacement']),
            )
          : null,
      bookId: _stringValue(data, [
        'bookId',
        'book_id',
      ], fallback: _stringValue(_ensureMap(nestedBook), ['id'])),
    );
  }

  static TrackingModel? fromResponse(dynamic response) {
    if (response is Map<String, dynamic>) {
      if (response.containsKey('data')) {
        return fromResponse(response['data']);
      }
      if (response.containsKey('request')) {
        return fromResponse(response['request']);
      }
      if (response.containsKey('autographRequest')) {
        return fromResponse(response['autographRequest']);
      }
      if (response.containsKey('tracking')) {
        return fromResponse(response['tracking']);
      }
      if (response.containsKey('item')) {
        return fromResponse(response['item']);
      }
      return TrackingModel.fromJson(response);
    }

    if (response is List && response.isNotEmpty) {
      return TrackingModel.fromJson(Map<String, dynamic>.from(response.first));
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

String _stringValue(
  Map<String, dynamic> data,
  List<String> keys, {
  String fallback = '',
}) {
  for (final key in keys) {
    final value = data[key];
    if (value != null) {
      final stringValue = value.toString().trim();
      if (stringValue.isNotEmpty && stringValue != 'null') {
        return stringValue;
      }
    }
  }
  return fallback;
}

bool _boolValue(
  Map<String, dynamic> data,
  List<String> keys, {
  bool fallback = false,
}) {
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

Map<String, dynamic> _ensureMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}
