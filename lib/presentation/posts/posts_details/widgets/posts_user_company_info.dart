import 'package:flutter/material.dart';
import 'posts_description_card.dart';

class PostUserCompanyInfo extends StatelessWidget {
  final String userInfo; // نبذة المستخدم
  final String companyName; // اسم الشركة (اختياري)
  final String companyInfo; // نبذة الشركة (اختياري)

  const PostUserCompanyInfo({
    super.key,
    required this.userInfo,
    required this.companyName,
    required this.companyInfo,
  });

  bool _hasText(String s) => s.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final hasUserInfo = _hasText(userInfo);
    final hasCompanyInfo = _hasText(companyInfo);
    final hasCompanyName = _hasText(companyName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasUserInfo) ...[
          const Text(
            'Информация о пользователе',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: 'InriaSans',
            ),
          ),
          const SizedBox(height: 8),
          PostDescriptionCard(description: userInfo),
          const SizedBox(height: 16),
        ],

        if (hasCompanyInfo || hasCompanyName) ...[
          const Text(
            'Информация о компании',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: 'InriaSans',
            ),
          ),
          const SizedBox(height: 8),
          if (hasCompanyName)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Text(
                companyName,
                style: const TextStyle(
                  color: Color(0xFFAF925D),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'InriaSans',
                ),
              ),
            ),
          if (hasCompanyInfo) PostDescriptionCard(description: companyInfo),
        ],
      ],
    );
  }
}
