// lib/presentation/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_founders/presentation/profile/bloc/profile_bloc.dart';
import 'package:flutter_founders/presentation/profile/bloc/profile_event.dart';
import 'package:flutter_founders/presentation/profile/bloc/profile_state.dart';
import 'package:flutter_founders/presentation/profile/bloc/partners_bloc.dart';
import 'package:flutter_founders/presentation/profile/bloc/partners_event.dart';
import 'package:flutter_founders/presentation/profile/bloc/partners_state.dart';
import 'package:flutter_founders/presentation/profile/widgets/profile_header.dart';
import 'package:flutter_founders/presentation/profile/widgets/section_card.dart';
import 'package:flutter_founders/presentation/profile/widgets/partners_list.dart';
import 'package:flutter_founders/data/api/profile_api_service.dart';
import 'package:flutter_founders/data/api/partners_api_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              ProfileBloc(ProfileApiService())..add(LoadCurrentProfile()),
        ),
        BlocProvider(
          create: (_) =>
              PartnersBloc(PartnersApiService())..add(LoadPartners()),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileLoaded) {
                print("📣 Listener got new profile: ${state.profile.toJson()}");
              }
            },
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                } else if (state is ProfileLoaded) {
                  final profile = state.profile;
                  print("✅ UI got profile: ${profile.toJson()}");

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileHeader(
                          key: ValueKey(profile.toJson().toString()),
                          profile: profile,
                          isMyProfile: true,
                          onProfileUpdated: () {
                            context.read<ProfileBloc>().add(
                              LoadCurrentProfile(),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        // زر "Добавить компанию"
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFAF925D),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              // TODO: show bottom sheet to add company
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  'Добавить компанию',
                                  style: GoogleFonts.inriaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
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
                        const SizedBox(height: 16),
                        Text(
                          'Партнёры',
                          style: GoogleFonts.inriaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF808080),
                          ),
                        ),
                        const SizedBox(height: 8),
                        BlocBuilder<PartnersBloc, PartnersState>(
                          builder: (context, state) {
                            if (state.isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            } else if (state.error != null) {
                              return SectionCard(
                                content: 'Ошибка при загрузке партнёров',
                              );
                            } else if (state.partners.isEmpty) {
                              return const SectionCard(
                                content: 'Нет партнёров',
                              );
                            } else {
                              return PartnersList(partners: state.partners);
                            }
                          },
                        ),
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
      ),
    );
  }
}
