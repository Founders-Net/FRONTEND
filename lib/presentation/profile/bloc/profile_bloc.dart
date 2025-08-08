import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_founders/data/api/profile_api_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileApiService apiService;

  ProfileBloc(this.apiService) : super(ProfileInitial()) {
    on<LoadCurrentProfile>(_onLoadCurrentProfile);
    on<LoadUserProfile>(_onLoadUserProfile);
  }

  Future<void> _onLoadCurrentProfile(
    LoadCurrentProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileInitial());
    emit(ProfileLoading());
    try {
      debugPrint('🔄 Loading current profile...');
      final profile = await apiService.getMyProfile();
      debugPrint('✅ Current profile loaded: ${profile.toJson()}');
      emit(ProfileLoaded(profile));
    } catch (e) {
      debugPrint('❌ Error loading current profile: $e');
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      debugPrint('🔄 Loading profile for user ID: ${event.userId}');
      final profile = await apiService.getUserProfileById(event.userId);
      debugPrint('✅ User profile loaded: ${profile.toJson()}');
      emit(ProfileLoaded(profile));
    } catch (e) {
      debugPrint('❌ Error loading user profile: $e');
      emit(ProfileError(e.toString()));
    }
  }
}
