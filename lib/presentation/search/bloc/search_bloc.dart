import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_founders/data/api/search_api_service.dart';
import 'package:flutter_founders/models/user_profile.dart';
import 'package:flutter_founders/models/user_short.dart';

import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchApiService apiService;

  SearchBloc({required this.apiService}) : super(SearchState.initial()) {
    on<LoadInitialProfiles>(_onLoadInitial);
    on<LoadAvailableTags>(_onLoadTags);
    on<SearchQueryChanged>(_onQueryChanged);
    on<ApplyFilters>(_onApplyFilters);
    on<ClearFilters>(_onClearFilters);
  }

  // ---------- Helpers ----------

  /// Map the API "short" user to your UI profile model.
  UserProfile _mapShortToProfile(UserShort u) {
    return UserProfile(
      id: u.id,
      userName: u.userName,
      userAvatar: u.userAvatar,
      companyName: u.companyName,
      companyIndustry: u.companyIndustry,
      tags: u.tags,
      country: u.country,
    );
  }

  /// Single, spec-accurate search call (GET /api/users/?cursor&limit&fio?&country?&tags?[])
  Future<List<UserShort>> _search({
    String? query,
    String? country,
    List<String>? tags,
    int cursor = 0,
    int limit = 50,
  }) {
    return apiService.searchUsers(
      query: (query ?? '').trim().isEmpty ? null : query!.trim(), // maps to `fio`
      country: (country ?? '').trim().isEmpty ? null : country!.trim(),
      tags: (tags ?? []).where((t) => t.trim().isNotEmpty).toList(), // sent as tags[]=...
      cursor: cursor,
      limit: limit,
    );
  }

  String _humanizeError(Object e) {
    if (e is! Exception) return 'Unexpected error, please try again.';
    // Keep it short for UI; Dio errors are already logged inside the service.
    return 'An error occurred in the search. Check the filters and try again.';
  }

  // ---------- Event handlers ----------

  Future<void> _onLoadInitial(
    LoadInitialProfiles event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final results = await _search(cursor: 0, limit: 50);
      final profiles = results.map(_mapShortToProfile).toList();
      emit(state.copyWith(isLoading: false, profiles: profiles));
      // Populate tags for the filter UI (best-effort)
      add(const LoadAvailableTags());
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: _humanizeError(e)));
    }
  }

  Future<void> _onLoadTags(
    LoadAvailableTags event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final tags = await apiService.getAvailableTags(); // returns List<TagItem>
      emit(state.copyWith(availableTags: tags));
    } catch (_) {
      // ignore tag errors; don’t block the page
    }
  }

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, query: event.query, error: null));
    try {
      final results = await _search(
        query: event.query,
        country: state.country,
        tags: state.selectedTags.toList(),
        cursor: 0,
        limit: 50,
      );
      emit(
        state.copyWith(
          isLoading: false,
          profiles: results.map(_mapShortToProfile).toList(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: _humanizeError(e)));
    }
  }

  Future<void> _onApplyFilters(
    ApplyFilters event,
    Emitter<SearchState> emit,
  ) async {
    final normalizedCountry =
        (event.country?.trim().isEmpty ?? true) ? null : event.country!.trim();

    emit(
      state.copyWith(
        isLoading: true,
        error: null,
        country: normalizedCountry,
        selectedTags: event.selectedTags,
      ),
    );

    try {
      final results = await _search(
        query: state.query,
        country: normalizedCountry,
        tags: event.selectedTags.toList(),
        cursor: 0,
        limit: 50,
      );
      emit(
        state.copyWith(
          isLoading: false,
          profiles: results.map(_mapShortToProfile).toList(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: _humanizeError(e)));
    }
  }

  void _onClearFilters(ClearFilters event, Emitter<SearchState> emit) {
    // Clear locally…
    final cleared = state.copyWith(country: null, selectedTags: const {});
    emit(cleared);
    // …then re-run search with no filters
    add(SearchQueryChanged(cleared.query));
  }
}
