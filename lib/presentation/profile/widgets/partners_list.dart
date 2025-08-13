import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/partner_model.dart';
import '../other_profile_screen.dart';

class PartnersList extends StatelessWidget {
  final List<PartnerModel> partners;
  final VoidCallback? onReturnTrue; // ✅ جديد: إشعار الأب بالتحديث

  const PartnersList({super.key, required this.partners, this.onReturnTrue});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: partners.map((partner) {
        return Column(
          children: [
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OtherProfileScreen(userId: partner.id),
                  ),
                );
                if (result == true) {
                  // ✅ نبه الأب إنه يعمل ريفريش
                  onReturnTrue?.call();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: partner.userAvatar != null
                          ? NetworkImage(partner.userAvatar!)
                          : null,
                      child: partner.userAvatar == null
                          ? Text(
                              partner.userName.isNotEmpty
                                  ? partner.userName[0]
                                  : '?',
                              style: const TextStyle(color: Colors.white),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            partner.userName,
                            style: GoogleFonts.inriaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            partner.companyName ?? '',
                            style: GoogleFonts.inriaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFAF925D),
                            ),
                          ),
                          Text(
                            partner.companyIndustry ?? '',
                            style: GoogleFonts.inriaSans(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 1,
              color: Colors.white12,
              margin: const EdgeInsets.symmetric(vertical: 4),
            ),
          ],
        );
      }).toList(),
    );
  }
}
