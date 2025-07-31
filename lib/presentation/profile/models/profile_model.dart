class ProfileModel {
  final int id;
  final String name;
  final String? avatarUrl;
  final String? companyName;
  final String? industry;
  final String? bio;
  final String? companyInfo;
  final bool isPartner;
  final List<int> userPartners; // ✅ مضاف جديد

  ProfileModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.companyName,
    this.industry,
    this.bio,
    this.companyInfo,
    this.isPartner = false,
    this.userPartners = const [], // ✅ default فارغة لو null
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    print('🔵 JSON FROM API: $json');

    return ProfileModel(
      id: json['id'],
      name: json['userName'] ?? 'Неизвестно',
      avatarUrl: json['userAvatar'],
      companyName: json['companyName'],
      industry: json['companyIndustry'],
      bio: json['userInfo'],
      companyInfo: json['companyInfo'],
      isPartner: json['isPartner'] ?? false,
      userPartners: List<int>.from(json['userPartners'] ?? []), // ✅ التحويل الصحيح
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
      'isPartner': isPartner,
      'userPartners': userPartners,
    };
  }
}
