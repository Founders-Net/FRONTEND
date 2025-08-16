import 'package:equatable/equatable.dart';
import '../../../models/post_model.dart';

class PostsState extends Equatable {
  final List<PostModel> posts;
  final bool isLoading;
  final String? error;
  final bool hasMore;

  const PostsState({
    required this.posts,
    required this.isLoading,
    this.error,
    required this.hasMore,
  });

  factory PostsState.initial() =>
      const PostsState(posts: [], isLoading: false, error: null, hasMore: true);

  // ✅ copyWith يدعم مسح error لما نمرر null
  PostsState copyWith({
    List<PostModel>? posts,
    bool? isLoading,
    Object? error = _sentinel,
    bool? hasMore,
  }) {
    return PostsState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _sentinel) ? this.error : error as String?,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props => [posts, isLoading, error, hasMore];
}
