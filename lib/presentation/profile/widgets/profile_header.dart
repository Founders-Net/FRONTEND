import 'package:flutter/material.dart';
import 'package:flutter_founders/presentation/profile/edit_profile/edit_profile_page.dart';
import 'package:flutter_founders/presentation/profile/models/profile_model.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileModel profile;
  final bool isMyProfile;
  final VoidCallback? onProfileUpdated;

  const ProfileHeader({
    super.key,
    required this.profile,
    required this.isMyProfile,
    this.onProfileUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isMyProfile)
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white70, size: 24),
                  onPressed: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfilePage(profile: profile),
                      ),
                    );
                    debugPrint('🔄 Profile update result: $updated');
                    if (updated == true) {
                      onProfileUpdated?.call();
                    }
                  },
                ),
                const SizedBox(width: 12),
                const Icon(Icons.settings, color: Colors.white70, size: 24),
              ],
            ),
          ),
        const SizedBox(height: 12),

        // 👤 صورة البروفايل
        Center(
          child: CircleAvatar(
            radius: 56,
            backgroundImage:
                (profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty)
                ? NetworkImage(profile.avatarUrl!) as ImageProvider
                : const AssetImage('assets/images/image 1.png'),
          ),
        ),
        const SizedBox(height: 12),

        // 🧑‍💼 الاسم
        Center(
          child: Text(
            profile.name.isNotEmpty ? profile.name : 'Неизвестно',
            style: GoogleFonts.inriaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4),

        // 🏢 اسم الشركة
        Center(
          child: Text(
            (profile.companyName ?? 'Компания не указана'),
            style: GoogleFonts.inriaSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFAF925D),
            ),
          ),
        ),

        // 🧑‍🔧 مجال العمل (industry)
        if ((profile.industry ?? '').isNotEmpty)
          Center(
            child: Text(
              profile.industry!,
              style: GoogleFonts.inriaSans(fontSize: 12, color: Colors.white70),
            ),
          ),
      ],
    );
  }
}
