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