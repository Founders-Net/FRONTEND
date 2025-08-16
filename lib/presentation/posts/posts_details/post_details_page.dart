// lib/presentation/posts/post_details_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_founders/models/post_model.dart';
import 'widgets/posts_header.dart';
import 'widgets/posts_tags.dart';
import 'widgets/posts_description_card.dart';
import 'widgets/posts_user_company_info.dart';
import 'widgets/action_buttons_row.dart';

// إضافات لجلب بروفايل الكاتب:
import 'package:flutter_founders/presentation/profile/models/profile_model.dart';
import 'package:flutter_founders/data/api/profile_api_service.dart';

class PostDetailsPage extends StatelessWidget {
  final PostModel post;

  const PostDetailsPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final createdTime = _formatCreatedAt(post.createdAt);

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
              company: post.companyName ?? '',      // ✅ null-safe
              avatarUrl: post.userAvatar ?? '',     // ✅ null-safe
              time: createdTime,
            ),
            const SizedBox(height: 16),

            PostDescriptionCard(description: post.content),
            const SizedBox(height: 2),

            PostTags(tags: post.tags),
            const SizedBox(height: 10),

            const ActionButtonsRow(),
            const SizedBox(height: 16),

            // ✅ معلومات المستخدم/الشركة دايناميك من الـ API حسب userId
            FutureBuilder<ProfileModel>(
              future: ProfileApiService().getUserProfileById(post.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _AuthorSkeleton();
                }
                if (snapshot.hasError) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'خطأ في تحميل بيانات البروفايل: ${snapshot.error}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontFamily: 'InriaSans',
                      ),
                    ),
                  );
                }

                final author = snapshot.data!;
                return PostUserCompanyInfo(
                  userInfo: author.bio ?? '',                              // ✅ null-safe
                  companyName: author.companyName ?? post.companyName ?? '', // ✅ null-safe
                  companyInfo: author.companyInfo ?? '',                   // ✅ null-safe
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatCreatedAt(String createdAt) {
    try {
      final parts = createdAt.split(' ');
      if (parts.length >= 4) return parts.take(4).join(' ');
      return createdAt;
    } catch (_) {
      return createdAt;
    }
  }
}

class _AuthorSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget skel() => Container(
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(12),
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Информация о пользователе',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontFamily: 'InriaSans',
          ),
        ),
        const SizedBox(height: 8),
        skel(),
        const SizedBox(height: 16),
        const Text(
          'Информация о компании',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontFamily: 'InriaSans',
          ),
        ),
        const SizedBox(height: 8),
        skel(),
      ],
    );
  }
}
