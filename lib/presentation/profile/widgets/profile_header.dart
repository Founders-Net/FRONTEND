import 'package:flutter/material.dart';
import 'package:flutter_founders/presentation/profile/models/profile_model.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileModel profile;
  final bool isMyProfile;

  const ProfileHeader({
    super.key,
    required this.profile,
    required this.isMyProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isMyProfile)
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Icon(Icons.edit, color: Colors.white70, size: 24),
                SizedBox(width: 12),
                Icon(Icons.settings, color: Colors.white70, size: 24),
              ],
            ),
          ),

        const SizedBox(height: 12),

        CircleAvatar(
          radius: 56,
          backgroundImage: profile.avatarUrl != null
              ? AssetImage(profile.avatarUrl!)
              : const AssetImage('assets/images/default_avatar.png'),
        ),

        const SizedBox(height: 12),

        Text(
          profile.name,
          style: GoogleFonts.inriaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 4),

        if (profile.companyName != null)
          Text(
            profile.companyName!,
            style: GoogleFonts.inriaSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFAF925D),
            ),
          ),

        if (profile.industry != null)
          Text(
            profile.industry!,
            style: GoogleFonts.inriaSans(fontSize: 12, color: Colors.white70),
          ),
      ],
    );
  }
}
