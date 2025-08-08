class InvestmentModel {
  final int id;
  final int userId;
  final String? userName;
  final String? userAvatar;
  final String? userInfo;
  final String title;
  final String description;
  final int investmentAmount;
  final int paybackPeriodMonths;
  final String country;
  final String? businessPlanUrl;
  final String? financialModelUrl;
  final String? presentationUrl;
  final String status;
  final int? likesCount;
  final int? commentsCount;
  final String createdAt;
  final bool liked;

  InvestmentModel({
    required this.id,
    required this.userId,
    this.userName,
    this.userAvatar,
    this.userInfo,
    required this.title,
    required this.description,
    required this.investmentAmount,
    required this.paybackPeriodMonths,
    required this.country,
    required this.businessPlanUrl,
    required this.financialModelUrl,
    required this.presentationUrl,
    required this.status,
    this.likesCount,
    this.commentsCount,
    required this.createdAt,
    this.liked = false,
  });

factory InvestmentModel.fromJson(Map<String, dynamic> json) {
  return InvestmentModel(
    id: json['id'] as int,
    userId: json['userId'] as int,
    userName: json['userName'],
    userAvatar: json['userAvatar'],
    userInfo: json['userInfo'],
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    investmentAmount: num.tryParse(json['investmentAmount'].toString())?.toInt() ?? 0,
    paybackPeriodMonths: num.tryParse(json['paybackPeriodMonths'].toString())?.toInt() ?? 0,
    country: json['country'] ?? '',
    businessPlanUrl: json['businessPlanUrl'],
    financialModelUrl: json['financialModelUrl'],
    presentationUrl: json['presentationUrl'],
    status: json['status'] ?? '',
    likesCount: json['likesCount'] != null ? int.tryParse(json['likesCount'].toString()) : null,
    commentsCount: json['commentsCount'] != null ? int.tryParse(json['commentsCount'].toString()) : null,
    createdAt: json['createdAt'] ?? '',
    liked: json['isLiked'] ?? false,
  );
}
}
