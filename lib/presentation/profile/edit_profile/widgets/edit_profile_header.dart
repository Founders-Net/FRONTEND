// lib/presentation/profile/edit_profile/widgets/edit_profile_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_founders/presentation/profile/models/profile_model.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileHeader extends StatelessWidget {
  final ProfileModel profile;

  const EditProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context,).pop(),
            ),
            const SizedBox(width: 8),
            
          ],
        ),
        const SizedBox(height: 12),
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 56,
                backgroundImage: profile.avatarUrl != null
                    ? NetworkImage(profile.avatarUrl!)
                    : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
              ),
              const SizedBox(height: 8),
              Text(
                profile.name,
                style: GoogleFonts.inriaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (profile.companyName != null) ...[
                const SizedBox(height: 4),
                Text(
                  profile.companyName!,
                  style: GoogleFonts.inriaSans(
                    fontSize: 14,
                    color: const Color(0xFF808080),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
