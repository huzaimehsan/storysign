class HelpSupportModel {
  final String email;
  final String phone;
  final String supportUrl;

  HelpSupportModel({
    required this.email,
    required this.phone,
    required this.supportUrl,
  });

  factory HelpSupportModel.fromJson(Map<String, dynamic> json) {
    return HelpSupportModel(
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