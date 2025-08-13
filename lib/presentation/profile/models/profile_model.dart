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

  // ✅ الحقول الجديدة
  final String country; // الدولة
  final List<String> tags; // التاجات

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

    // ✅ قيم افتراضية
    this.country = "Россия",
    this.tags = const ["IT"],
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
      country: json['country'] ?? "Россия",
      tags: (json['tags'] as List?)?.cast<String>() ?? ["IT"],
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
      'country': country,
      'tags': tags,
    };
  }
}
