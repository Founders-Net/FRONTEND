class ProfileModel {
  final int id;
  final String name;
  final String? avatarUrl;
  final String? companyName;
  final String? industry;
  final String? bio;
  final String? companyInfo;
  final String? phone;
  final String? email;
  final bool? isPartner;
  final List<int>? userPartners;

  ProfileModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.companyName,
    this.industry,
    this.bio,
    this.companyInfo,
    this.phone,
    this.email,
    this.isPartner,
    this.userPartners,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['userName'] ?? '',
      avatarUrl: json['userAvatar'],
      companyName: json['companyName'],
      industry: json['companyIndustry'],
      bio: json['userInfo'],
      companyInfo: json['companyInfo'],
      phone: json['userPhone'],
      email: json['userEmail'],
      isPartner: json['isPartner'] ?? false,
      userPartners: (json['userPartners'] as List?)?.cast<int>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': name,
      'userAvatar': avatarUrl,
      'companyName': companyName,
      'companyIndustry': industry,
      'userInfo': bio,
      'companyInfo': companyInfo,
      'userPhone': phone,
      'userEmail': email,
      'isPartner': isPartner,
      'userPartners': userPartners,
    };
  }
}
