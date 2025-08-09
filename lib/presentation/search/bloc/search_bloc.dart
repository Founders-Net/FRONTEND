import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_founders/data/api/profile_api_service.dart';
import 'package:flutter_founders/models/user_profile.dart';
import 'package:flutter_founders/models/user_short.dart';

import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProfileApiService apiService;

  SearchBloc({required this.apiService}) : super(SearchState.initial()) {
    on<LoadInitialProfiles>(_onLoadInitial);
    on<LoadAvailableTags>(_onLoadTags);
    on<SearchQueryChanged>(_onQueryChanged);
    on<ApplyFilters>(_onApplyFilters);
    on<ClearFilters>(_onClearFilters);
  }

  // --- Event handlers ---

  Future<void> _onLoadInitial(
    LoadInitialProfiles event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final results = await apiService.searchUsers(cursor: 0, limit: 50);
      final profiles = results.map(_mapShortToProfile).toList();
      emit(state.copyWith(isLoading: false, profiles: profiles));
      add(const LoadAvailableTags());
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadTags(
    LoadAvailableTags event,
    Emitter<SearchState> emit,
  ) async {
    // best-effort: don't block UI if tags fail to load
    try {
      final tags = await apiService.getAvailableTags();
      emit(state.copyWith(availableTags: tags));
    } catch (_) {}
  }

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, query: event.query, error: null));
    try {
      final results = await apiService.searchUsers(
        query: event.query,
        country: state.country,
        tags: state.selectedTags.toList(),
        cursor: 0,
        limit: 50,
      );
      emit(state.copyWith(
        isLoading: false,
        profiles: results.map(_mapShortToProfile).toList(),
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onApplyFilters(
    ApplyFilters event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      error: null,
      country: (event.country?.isEmpty ?? true) ? null : event.country,
      selectedTags: event.selectedTags,
    ));
    try {
      final results = await apiService.searchUsers(
        query: state.query,
        country: (event.country?.isEmpty ?? true) ? null : event.country,
        tags: event.selectedTags.toList(),
        cursor: 0,
        limit: 50,
      );
      emit(state.copyWith(
        isLoading: false,
        profiles: results.map(_mapShortToProfile).toList(),
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onClearFilters(
    ClearFilters event,
    Emitter<SearchState> emit,
  ) {
    // Clear locally first for instant UI response
    emit(state.copyWith(country: null, selectedTags: const {}));
    // Then re-query server with cleared filters
    add(SearchQueryChanged(state.query));
  }

  // --- Mapping ---

  UserProfile _mapShortToProfile(UserShort u) {
    // Adapt this to your final UserProfile fields.
    // Expected modern fields: id, userName, userAvatar, companyName, companyIndustry, tags, country
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
}
