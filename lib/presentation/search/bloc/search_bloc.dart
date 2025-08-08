import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_founders/data/api/profile_api_service.dart';
import 'package:flutter_founders/models/user_profile.dart';
import 'package:flutter_founders/models/user_short.dart';
import 'search_event.dart';
import 'search_state.dart';

extension UserShortMapper on UserShort {
  UserProfile toProfileModel() {
    return UserProfile(
      id: id,
      userName: userName,
      companyName: companyName ?? '',
      userAvatar: userAvatar ?? '',
      companyIndustry: companyIndustry ?? '',
      tags: [],
      subTags: null,
      countryFlag: '🇷🇺', // Placeholder for now*/
    );
  }
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProfileApiService apiService;

  SearchBloc({required this.apiService}) : super(SearchState.initial()) {
    on<LoadInitialProfiles>(_onLoadInitial);
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchFiltersChanged>(_onFiltersChanged);
  }

  Future<void> _onLoadInitial(
      LoadInitialProfiles event, Emitter<SearchState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final results = await apiService.searchUsers();
      final profiles = results.map((u) => u.toProfileModel()).toList();
      emit(state.copyWith(isLoading: false, profiles: profiles));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onQueryChanged(
      SearchQueryChanged event, Emitter<SearchState> emit) async {
    emit(state.copyWith(isLoading: true, query: event.query));
    try {
      final results = await apiService.searchUsers(query: event.query);
      final profiles = results.map((u) => u.toProfileModel()).toList();
      emit(state.copyWith(isLoading: false, profiles: profiles));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onFiltersChanged(
  SearchFiltersChanged event, Emitter<SearchState> emit) async {
  emit(state.copyWith(
    isLoading: true,
    selectedCountries: event.countries,
    selectedMainTags: event.mainTags,
    selectedSubTags: event.subTags,
    isFoundersOnly: event.isFoundersOnly,
  ));

  try {
    final results = await apiService.searchUsers(query: state.query);

    final filtered = results.where((u) {
    final matchCountry = event.countries.isEmpty ||
        u.countries.any((c) => event.countries.contains(c));

    final matchMainTag = event.mainTags.isEmpty ||
        u.mainTags.any((tag) => event.mainTags.contains(tag));

    final matchSubTag = event.subTags.isEmpty ||
        u.subTags.any((sub) => event.subTags.contains(sub));

    final matchFounders = !event.isFoundersOnly || u.isFoundersOnly;

    return matchCountry && matchMainTag && matchSubTag && matchFounders;
  }).map((u) => u.toProfileModel()).toList();

    emit(state.copyWith(isLoading: false, profiles: filtered));
  } catch (e) {
    emit(state.copyWith(isLoading: false, error: e.toString()));
  }
}
}
