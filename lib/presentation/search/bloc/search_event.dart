import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

/// Load first page of users (and usually followed by LoadAvailableTags)
class LoadInitialProfiles extends SearchEvent {
  const LoadInitialProfiles();
}

/// Fetch /api/tags to populate the filter UI (main+sub shown in UI, flattened when applying)
class LoadAvailableTags extends SearchEvent {
  const LoadAvailableTags();
}

/// Live search query change
class SearchQueryChanged extends SearchEvent {
  final String query;
  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

/// Apply server-side filters: one country + flattened set of tags (main + sub)
class ApplyFilters extends SearchEvent {
  final String? country;              // null/empty => all countries
  final Set<String> selectedTags;     // flattened (e.g., {"IT","Frontend","SEO"})

  const ApplyFilters({
    this.country,
    this.selectedTags = const {},
  });

  @override
  List<Object?> get props => [country, selectedTags];
}

/// Clear all filters
class ClearFilters extends SearchEvent {
  const ClearFilters();
}

//
// --- Temporary compatibility shim ---
// Keeps old dispatch sites working until you switch to ApplyFilters.
// Replace usages in FilterBottomSheet to dispatch `ApplyFilters` instead.
//
class SearchFiltersChanged extends ApplyFilters {
  SearchFiltersChanged({
    required List<String> countries,
    required List<String> mainTags,
    required List<String> subTags,
    required bool isFoundersOnly, // ignored
  }) : super(
          country: countries.isEmpty ? null : countries.first,
          selectedTags: {...mainTags, ...subTags},
        );
}

