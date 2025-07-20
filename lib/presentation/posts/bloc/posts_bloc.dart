import 'package:flutter_bloc/flutter_bloc.dart';
import 'posts_event.dart';
import 'posts_state.dart';
import 'package:flutter_founders/data/api/posts_api_service.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsApiService apiService;

  PostsBloc(this.apiService) : super(PostsState.initial()) {
    on<LoadPostsEvent>(_onLoadPosts);
    on<LoadMorePostsEvent>(_onLoadMorePosts);
  }

  Future<void> _onLoadPosts(
    LoadPostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final posts = await apiService.fetchPosts(
        cursor: event.cursor,
        limit: event.limit,
      );
      print('📦 Posts emitted: ${posts.length}');

      emit(
        state.copyWith(
          posts: posts,
          isLoading: false,
          hasMore: posts.length >= event.limit,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadMorePosts(
    LoadMorePostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    if (state.isLoading || !state.hasMore) return;

    emit(state.copyWith(isLoading: true));

    try {
      final newPosts = await apiService.fetchPosts(
        cursor: state.posts.length,
        limit: event.limit,
      );

      emit(
        state.copyWith(
          posts: [...state.posts, ...newPosts],
          isLoading: false,
          hasMore: newPosts.length >= event.limit,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
