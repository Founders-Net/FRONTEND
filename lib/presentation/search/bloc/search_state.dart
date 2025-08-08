import 'package:equatable/equatable.dart';
import 'package:flutter_founders/models/user_profile.dart';

class SearchState extends Equatable {
  final bool isLoading;
  final String query;
  final List<UserProfile> profiles;
  final List<String> selectedTags;
  final List<String> selectedCountries;
  final String? error;

  const SearchState({
    required this.isLoading,
    required this.query,
    required this.profiles,
    required this.selectedTags,
    required this.selectedCountries,
    this.error,
  });

  factory SearchState.initial() => const SearchState(
        isLoading: false,
        query: '',
        profiles: [],
        selectedTags: [],
        selectedCountries: [],
        error: null,
      );

  SearchState copyWith({
    bool? isLoading,
    String? query,
    List<UserProfile>? profiles,
    List<String>? selectedTags,
    List<String>? selectedCountries,
    String? error,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      query: query ?? this.query,
      profiles: profiles ?? this.profiles,
      selectedTags: selectedTags ?? this.selectedTags,
      selectedCountries: selectedCountries ?? this.selectedCountries,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, query, profiles, selectedTags, selectedCountries, error];
}

