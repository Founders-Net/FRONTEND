import 'package:equatable/equatable.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object?> get props => [];
}

class LoadPostsEvent extends PostsEvent {
  final int cursor;
  final int limit;

  const LoadPostsEvent({this.cursor = 0, this.limit = 10});

  @override
  List<Object?> get props => [cursor, limit];
}

class LoadMorePostsEvent extends PostsEvent {
  final int cursor;
  final int limit;

  const LoadMorePostsEvent({this.cursor = 0, this.limit = 10});

  @override
  List<Object?> get props => [cursor, limit];
}
