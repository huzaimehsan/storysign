class AuthorProfileModel {
  String? profilePicture;
  String? fullName;
  String? email;
  String? bio;
  String? dateJoined;
  String? activePlanName;
  int? totalSignedAutographs;
  bool? isSubscribed;

  AuthorProfileModel({
    this.profilePicture,
    this.fullName,
    this.email,
    this.bio,
    this.dateJoined,
    this.activePlanName,
    this.totalSignedAutographs,
    this.isSubscribed,
  });

  // JSON se Model banane ke liye (fromJson)
  factory AuthorProfileModel.fromJson(Map<String, dynamic> json) {
    return AuthorProfileModel(
      profilePicture: json['profilePicture'],
      fullName: json['fullName'],
      email: json['email'],
      bio: json['bio'],
      dateJoined: json['dateJoined'],
      activePlanName: json['activePlanName'],
      totalSignedAutographs: json['totalSignedAutographs'],
      isSubscribed: json['isSubscribed'],
    );
  }

  // Model ko wapas JSON mein convert karne ke liye (toJson)
  Map<String, dynamic> toJson() {
    return {
      'profilePicture': profilePicture,
      'fullName': fullName,
      'email': email,
      'bio': bio,
      'dateJoined': dateJoined,
      'activePlanName': activePlanName,
      'totalSignedAutographs': totalSignedAutographs,
      'isSubscribed': isSubscribed,
    };
  }
}