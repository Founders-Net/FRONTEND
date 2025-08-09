class UserShort {
  final int id;
  final String userName;
  final String? userAvatar;
  final String? companyName;
  final String? companyIndustry;
  /*final List<String> countries;
  final List<String> mainTags;
  final List<String> subTags;
  final bool isFoundersOnly;*/
  final String? country;      
  final List<String> tags;

  UserShort({
    required this.id,
    required this.userName,
    this.userAvatar,
    this.companyName,
    this.companyIndustry,
    this.country,
    required this.tags,
    /*required this.countries,
    required this.mainTags,
    required this.subTags,
    required this.isFoundersOnly,*/

  });

  factory UserShort.fromJson(Map<String, dynamic> json) {
    return UserShort(
      id: json['id'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      country: json['country'],
      tags: List<String>.from(json['tags'] ?? []),
      companyName: json['companyName'],
      companyIndustry: json['companyIndustry'],
      /*countries: List<String>.from(json['countries'] ?? []),
      mainTags: List<String>.from(json['mainTags'] ?? []),
      subTags: List<String>.from(json['subTags'] ?? []),
      isFoundersOnly: json['isFoundersOnly'] ?? false,*/
    );
  }
}
