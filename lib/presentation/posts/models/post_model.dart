// lib/presentation/posts/models/post_model.dart
class PostModel {
  final int id;
  final String userName;
  final String companyName;
  final String content;
  final List<String> tags;
  final String userAvatar;
  final String createdAt;

  PostModel({
    required this.id,
    required this.userName,
    required this.companyName,
    required this.content,
    required this.tags,
    required this.userAvatar,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      userName: json['userName'] ?? '',
      companyName: json['companyName'] ?? '',
      content: json['content'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      userAvatar: json['userAvatar'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}
