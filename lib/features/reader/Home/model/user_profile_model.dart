
class UserProfile {
  final String? profilePicture;
  final String email;
  final String fullName;
  final String dateJoined;

  UserProfile({
    this.profilePicture,
    required this.email,
    required this.fullName,
    required this.dateJoined,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      profilePicture: json['profilePicture'], // null ho sakta hai
      email: json['email'] ?? "",
      fullName: json['fullName'] ?? "",
      dateJoined: json['dateJoined'] ?? "",
    );
  }
}