import 'package:equatable/equatable.dart';
import 'package:flutter_founders/models/user_profile.dart';
import 'package:flutter_founders/models/tag_item.dart';

class SearchState extends Equatable {
  final bool isLoading;
  final String query;
  final List<UserProfile> profiles;

  // Server-driven filters
  final String? country;               // single country; null => all
  final Set<String> selectedTags;      // flattened (main + sub)

  // Options for UI (from /api/tags)
  final List<TagItem> availableTags;   // e.g., [TagItem('IT',['Frontend','Backend']), ...]

  // Optional: last error (human friendly)
  final String? error;

  const SearchState({
    required this.isLoading,
    required this.query,
    required this.profiles,
    this.country,
    this.selectedTags = const {},
    this.availableTags = const [],
    this.error,
  });

  factory SearchState.initial() => const SearchState(
        isLoading: false,
        query: '',
        profiles: [],
        country: null,
        selectedTags: {},
        availableTags: [],
        error: null,
      );

  SearchState copyWith({
    bool? isLoading,
    String? query,
    List<UserProfile>? profiles,
    String? country,
    Set<String>? selectedTags,
    List<TagItem>? availableTags,
    String? error,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      query: query ?? this.query,
      profiles: profiles ?? this.profiles,
      country: country == '' ? null : (country ?? this.country),
      selectedTags: selectedTags ?? this.selectedTags,
      availableTags: availableTags ?? this.availableTags,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        query,
        profiles,
        country,
        selectedTags,
        availableTags,
        error,
      ];
}
