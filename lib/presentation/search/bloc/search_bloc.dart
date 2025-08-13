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

  // ------------------ Helpers ------------------

  /// يجرب أكتر من ترميز لـ tags علشان نتفادى 400 من السيرفر
  Future<List<UserShort>> _searchWithFallbacks({
    String? query,
    String? country,
    List<String>? tags,
    int cursor = 0,
    int limit = 50,
  }) async {
    Object? lastError;

    for (final enc in const ['csv', 'array', 'brackets']) {
      try {
        final res = await apiService.searchUsers(
          query: query,
          country: country, // ممكن تبقى null → الـ service هيحط default
          tags: tags, // ممكن تبقى [] → الـ service هيحط default
          cursor: cursor,
          limit: limit,
          tagsEncoding: enc, // جرّب ترميزات مختلفة
          // تقدر تغيّر الافتراضيات هنا لو الباك إند طلب قيم حقيقية
          defaultCountry: 'ALL',
          defaultTags: const ['ALL'],
        );
        return res;
      } catch (e) {
        lastError = e;
        // جرّب encoding تاني
      }
    }

    // لو كل المحاولات فشلت
    throw lastError ?? Exception('Unknown search error');
  }

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

  // ------------------ Event handlers ------------------

  Future<void> _onLoadInitial(
    LoadInitialProfiles event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final results = await _searchWithFallbacks(cursor: 0, limit: 50);
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
    // best-effort: لو فشل ما نوقفش الـ UI
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
      final results = await _searchWithFallbacks(
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
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onApplyFilters(
    ApplyFilters event,
    Emitter<SearchState> emit,
  ) async {
    final normalizedCountry = (event.country?.isEmpty ?? true)
        ? null
        : event.country;

    emit(
      state.copyWith(
        isLoading: true,
        error: null,
        country: normalizedCountry,
        selectedTags: event.selectedTags,
      ),
    );

    try {
      final results = await _searchWithFallbacks(
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
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onClearFilters(ClearFilters event, Emitter<SearchState> emit) {
    // امسح محليًا أولًا
    emit(state.copyWith(country: null, selectedTags: const {}));
    // ثم اعمل بحث من غير فلاتر (هيتحط defaults في الـ service)
    add(SearchQueryChanged(state.query));
  }
}
