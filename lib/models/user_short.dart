// lib/models/user_short.dart
class UserShort {
  final int id;
  final String userName;
  final String? userAvatar;
  final String? companyName;
  final String? companyIndustry;

  UserShort({
    required this.id,
    required this.userName,
    this.userAvatar,
    this.companyName,
    this.companyIndustry,
  });

  factory UserShort.fromJson(Map<String, dynamic> json) {
    return UserShort(
      id: json['id'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      companyName: json['companyName'],
      companyIndustry: json['companyIndustry'],
    );
  }
}
