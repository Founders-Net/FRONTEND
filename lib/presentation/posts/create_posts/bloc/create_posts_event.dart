// create_posts_event.dart
import 'package:equatable/equatable.dart';

abstract class CreatePostEvent extends Equatable {
  const CreatePostEvent();

  @override
  List<Object?> get props => [];
}

class TitleChanged extends CreatePostEvent {
  final String title;
  const TitleChanged(this.title);

  @override
  List<Object?> get props => [title];
}

class DescriptionChanged extends CreatePostEvent {
  final String description;
  const DescriptionChanged(this.description);

  @override
  List<Object?> get props => [description];
}

class TagsChanged extends CreatePostEvent {
  final List<String> tags;
  const TagsChanged(this.tags);

  @override
  List<Object?> get props => [tags];
}

class SubmitPost extends CreatePostEvent {}