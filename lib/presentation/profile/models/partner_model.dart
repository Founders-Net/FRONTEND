// lib/models/partner_model.dart

class PartnerModel {
  final int id;
  final String userName;
  final String? userAvatar;
  final String? companyName;
  final String? companyIndustry;

  PartnerModel({
    required this.id,
    required this.userName,
    this.userAvatar,
    this.companyName,
    this.companyIndustry,
  });

  factory PartnerModel.fromJson(Map<String, dynamic> json) {
    return PartnerModel(
      id: json['id'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      companyName: json['companyName'],
      companyIndustry: json['companyIndustry'],
    );
  }
}
