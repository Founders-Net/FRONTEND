import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object?> get props => [];
}

/// Load first page and then fetch available tags.
class LoadInitialProfiles extends SearchEvent {
  const LoadInitialProfiles();
}

/// Fetch /api/tags to populate the filter UI (main+sub shown in UI, flattened when applying).
class LoadAvailableTags extends SearchEvent {
  const LoadAvailableTags();
}

/// Live search query change (maps to `fio` on the API).
class SearchQueryChanged extends SearchEvent {
  final String query;
  const SearchQueryChanged(this.query);
  @override
  List<Object?> get props => [query];
}

/// Apply server-side filters: single country + flattened set of tags (main + sub).
class ApplyFilters extends SearchEvent {
  final String? country;          // null/empty => all countries
  final Set<String> selectedTags; // flattened (e.g., {"IT","Frontend","SEO"})
  const ApplyFilters({
    this.country,
    this.selectedTags = const {},
  });
  @override
  List<Object?> get props => [country, selectedTags];
}

/// Clear all filters and reload.
class ClearFilters extends SearchEvent {
  const ClearFilters();
}
