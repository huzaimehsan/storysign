
class AuthorUserProfile {
  final String? profilePicture;
  final String email;
  final String fullName;
  final String dateJoined;

  AuthorUserProfile({
    this.profilePicture,
    required this.email,
    required this.fullName,
    required this.dateJoined,
  });

  factory AuthorUserProfile.fromJson(Map<String, dynamic> json) {
    return AuthorUserProfile(
      profilePicture: json['profilePicture'], // null ho sakta hai
      email: json['email'] ?? "",
      fullName: json['fullName'] ?? "",
      dateJoined: json['dateJoined'] ?? "",
    );
  }
}