class ProfileModel {
  final int id;
  final String name;
  final String? avatarUrl;
  final String? companyName;
  final String? industry;
  final String? bio;
  final String? companyInfo;
  final bool isPartner;

  ProfileModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.companyName,
    this.industry,
    this.bio,
    this.companyInfo,
    this.isPartner = false,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    print('🔵 JSON FROM API: $json'); // <-- ده هيطبع كل البيانات الراجعة

    return ProfileModel(
      id: json['id'],
      name: json['userName'] ?? 'Неизвестно',
      avatarUrl: json['avatarUrl'],
      companyName: json['companyName'],
      industry: json['industry'],
      bio: json['bio'],
      companyInfo: json['companyInfo'],
      isPartner: json['isPartner'] ?? false,
    );
  }

  toJson() {}
}
