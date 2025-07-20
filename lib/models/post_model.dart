class PostModel {
  final int id;
  final int userId;
  final String userName;
  final String? userAvatar;
  final String? companyName;
  final String content;
  final List<String> tags;
  final String createdAt;

  PostModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    this.companyName,
    required this.content,
    required this.tags,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      companyName: json['companyName'],
      content: json['content'],
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: json['createdAt'],
    );
  }
}
