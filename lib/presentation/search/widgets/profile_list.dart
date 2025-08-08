import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_founders/models/user_profile.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_state.dart';
import 'profile_card.dart';

class ProfileList extends StatelessWidget {
  const ProfileList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.error != null) {
          return Center(
            child: Text(
              state.error!,
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else {
          final List<UserProfile>? profiles = state.profiles;

          if (profiles == null || profiles.isEmpty) {
            return const Center(
              child: Text(
                'Ничего не найдено',
                style: TextStyle(color: Colors.grey, fontFamily: 'InriaSans'),
              ),
            );
          }

          return ListView.builder(
            itemCount: profiles.length,
            padding: const EdgeInsets.only(bottom: 80),
            itemBuilder: (context, index) {
              return ProfileCard(profile: profiles[index]);
            },
          );
        }
      },
    );
  }
}
