// lib/presentation/profile/other_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_founders/presentation/profile/bloc/profile_bloc.dart';
import 'package:flutter_founders/presentation/profile/bloc/profile_event.dart';
import 'package:flutter_founders/presentation/profile/bloc/profile_state.dart';
import 'package:flutter_founders/presentation/profile/partners/bloc/partners_bloc.dart';
import 'package:flutter_founders/presentation/profile/widgets/partners_summary_button.dart';
import 'package:flutter_founders/presentation/profile/widgets/profile_header.dart';
import 'package:flutter_founders/presentation/profile/widgets/section_card.dart';
import 'package:flutter_founders/presentation/profile/widgets/add_partner_button.dart';
import 'package:flutter_founders/presentation/profile/widgets/report_user_label.dart';
import 'package:flutter_founders/data/api/profile_api_service.dart';
import 'package:flutter_founders/data/api/partners_api_service.dart';
import 'package:google_fonts/google_fonts.dart';

class OtherProfileScreen extends StatelessWidget {
  final int userId;

  const OtherProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              ProfileBloc(ProfileApiService())..add(LoadUserProfile(userId)),
        ),
        BlocProvider(create: (_) => PartnersBloc(PartnersApiService())),
      ],
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              } else if (state is ProfileLoaded) {
                final profile = state.profile;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileHeader(profile: profile, isMyProfile: false),
                      const SizedBox(height: 24),

                      PartnersSummaryButton(
                        count: profile.userPartners?.length ?? 0,
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'О себе',
                        style: GoogleFonts.inriaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF808080),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SectionCard(content: profile.bio ?? ''),
                      const SizedBox(height: 16),

                      Text(
                        'О компании',
                        style: GoogleFonts.inriaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF808080),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SectionCard(content: profile.companyInfo ?? ''),
                      const SizedBox(height: 24),

                      // ✅ تعديل هنا: عند نجاح الإضافة نرجع true
                      AddPartnerButton(
                        userId: userId,
                        onSuccess: () {
                          Navigator.pop(context, true);
                        },
                      ),
                      const SizedBox(height: 12),

                      const ReportUserLabel(),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              } else if (state is ProfileError) {
                return Center(
                  child: Text(
                    'Ошибка: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
