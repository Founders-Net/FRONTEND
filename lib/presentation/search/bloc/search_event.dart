import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchFiltersChanged extends SearchEvent {
  final List<String> tags;
  final List<String> countries;

  const SearchFiltersChanged({required this.tags, required this.countries});

  @override
  List<Object?> get props => [tags, countries];
}

class LoadInitialProfiles extends SearchEvent {
  @override
  List<Object?> get props => [];
}