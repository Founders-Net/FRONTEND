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
  final List<String> countries;
  final List<String> mainTags;
  final List<String> subTags;
  final bool isFoundersOnly;

  const SearchFiltersChanged({
    required this.countries,
    required this.mainTags,
    required this.subTags,
    required this.isFoundersOnly,
  });

  @override
  List<Object?> get props => [
        countries,
        mainTags,
        subTags,
        isFoundersOnly,
      ];
}

class LoadInitialProfiles extends SearchEvent {
  @override
  List<Object?> get props => [];
}
