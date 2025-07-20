class RequestModel {
  final int id;
  final String? userName;
  final String? userAvatar;
  final String? companyName;
  final String? content;
  final List<String>? tags;
  final int? likesCount;
  final int? commentsCount;
  final String createdAt;

  const RequestModel({
    required this.id,
    this.userName,
    this.userAvatar,
    this.companyName,
    this.content,
    this.tags,
    this.likesCount,
    this.commentsCount,
    required this.createdAt,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      companyName: json['companyName'],
      content: json['content'],
      tags: List<String>.from(json['tags'] ?? []),
      likesCount: json['likesCount'],
      commentsCount: json['commentsCount'],
      createdAt: json['createdAt'],
    );
  }
}
