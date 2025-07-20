import 'package:flutter/material.dart';
import 'package:flutter_founders/models/post_model.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback onTap;

  const PostCard({super.key, required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasAvatar = post.userAvatar != null && post.userAvatar!.isNotEmpty;
    final companyName = post.companyName ?? '';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👤 Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white10,
                  backgroundImage:
                      (post.userAvatar != null &&
                          post.userAvatar!.startsWith('http') &&
                          !post.userAvatar!.contains('fake_url'))
                      ? NetworkImage(post.userAvatar!)
                      : null,
                  child:
                      (post.userAvatar == null ||
                          !post.userAvatar!.startsWith('http') ||
                          post.userAvatar!.contains('fake_url'))
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'InriaSans',
                        ),
                      ),
                      Text(
                        companyName,
                        style: const TextStyle(
                          color: Color(0xFFAF925D),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'InriaSans',
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      post.createdAt.split(' ').take(4).join(' '),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              post.content,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'InriaSans',
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: post.tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'InriaSans',
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
