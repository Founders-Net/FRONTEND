import 'package:equatable/equatable.dart';
import 'package:flutter_founders/models/user_profile.dart';

class SearchState extends Equatable {
  final bool isLoading;
  final String query;
  final List<UserProfile> profiles;
  final List<String> selectedCountries;
  final List<String> selectedMainTags;
  final List<String> selectedSubTags;
  final bool isFoundersOnly;
  final String? error;

  const SearchState({
    required this.isLoading,
    required this.query,
    required this.profiles,
    required this.selectedCountries,
    required this.selectedMainTags,
    required this.selectedSubTags,
    required this.isFoundersOnly,
    this.error,
  });

  factory SearchState.initial() => const SearchState(
        isLoading: false,
        query: '',
        profiles: [],
        selectedCountries: [],
        selectedMainTags: [],
        selectedSubTags: [],
        isFoundersOnly: false,
        error: null,
      );

  SearchState copyWith({
    bool? isLoading,
    String? query,
    List<UserProfile>? profiles,
    List<String>? selectedCountries,
    List<String>? selectedMainTags,
    List<String>? selectedSubTags,
    bool? isFoundersOnly,
    String? error,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      query: query ?? this.query,
      profiles: profiles ?? this.profiles,
      selectedCountries: selectedCountries ?? this.selectedCountries,
      selectedMainTags: selectedMainTags ?? this.selectedMainTags,
      selectedSubTags: selectedSubTags ?? this.selectedSubTags,
      isFoundersOnly: isFoundersOnly ?? this.isFoundersOnly,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        query,
        profiles,
        selectedCountries,
        selectedMainTags,
        selectedSubTags,
        isFoundersOnly,
        error,
      ];
}
