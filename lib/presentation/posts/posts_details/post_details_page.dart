import 'package:flutter/material.dart';
import 'package:flutter_founders/models/post_model.dart';
import 'widgets/posts_header.dart';
import 'widgets/posts_tags.dart';
import 'widgets/posts_description_card.dart';
import 'widgets/posts_user_company_info.dart';
import 'widgets/action_buttons_row.dart';

class PostDetailsPage extends StatelessWidget {
  final PostModel post;

  const PostDetailsPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Зопрос',
          style: TextStyle(color: Colors.white, fontFamily: 'InriaSans'),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostHeader(
              name: post.userName,
              company: post.companyName ?? '',
              avatarUrl: post.userAvatar ?? '',
              time: post.createdAt.split(' ').take(4).join(' '),
            ),
            const SizedBox(height: 16),

            PostDescriptionCard(description: post.content),
            const SizedBox(height: 2),

            PostTags(tags: post.tags),
            const SizedBox(height: 10),

            const ActionButtonsRow(),
            const SizedBox(height: 16),

            const PostUserCompanyInfo(), // Placeholder - يمكنك ربطه لاحقًا
          ],
        ),
      ),
    );
  }
}
