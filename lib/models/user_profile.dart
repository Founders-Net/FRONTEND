// lib/models/user_profile.dart
class UserProfile {
  final int id;
  final String userName;
  final String? userAvatar;
  final String? userInfo;
  final List<int>? userPartners;
  final String? companyName;
  final String? companyIndustry;
  final String? companyInfo;
  final List<String> tags;
  final List<String>? subTags;
  final String countryFlag;


  UserProfile({
    required this.id,
    required this.userName,
    this.userAvatar,
    this.userInfo,
    this.userPartners,
    this.companyName,
    this.companyIndustry,
    this.companyInfo,
    required this.tags,
    this.subTags,
    required this.countryFlag,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      userInfo: json['userInfo'],
      userPartners: json['userPartners'] != null
          ? List<int>.from(json['userPartners'])
          : null,
      companyName: json['companyName'],
      companyIndustry: json['companyIndustry'],
      companyInfo: json['companyInfo'],
      tags: [],
      subTags: null,
      countryFlag: '🇷🇺',
    );
  }
}