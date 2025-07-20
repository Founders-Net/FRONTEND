// lib/models/create_post_request.dart
class CreatePostRequest {
  final String title;
  final String content;
  final List<String> tags;

  CreatePostRequest({
    required this.title,
    required this.content,
    required this.tags,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'tags': tags,
      };
}
