class PartnerModel {
  final int id; // ✅ أضفنا الـ id هنا
  final String name;
  final String company;
  final String subtitle;
  final String avatarUrl;

  const PartnerModel({
    required this.id, // ✅ مطلوب عند الإنشاء
    required this.name,
    required this.company,
    required this.subtitle,
    required this.avatarUrl,
  });
}
