import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_posts_event.dart';
import 'create_posts_state.dart';
import 'package:flutter_founders/data/api/create_post_api_service.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final CreatePostApiService apiService;

  CreatePostBloc({required this.apiService})
    : super(CreatePostState.initial()) {
    on<TitleChanged>((event, emit) {
      emit(state.copyWith(title: event.title));
    });

    on<DescriptionChanged>((event, emit) {
      emit(state.copyWith(description: event.description));
    });

    on<TagsChanged>((event, emit) {
      emit(state.copyWith(selectedTags: event.tags));
    });

    on<SubmitPost>((event, emit) async {
      // ✅ تحقق من القيم قبل ما تبعت

      if (state.title.length < 30 ||
          state.description.length < 120 ||
          state.selectedTags.isEmpty) {
        emit(state.copyWith(isFailure: true, isSubmitting: false));
        return;
      }

      emit(
        state.copyWith(isSubmitting: true, isSuccess: false, isFailure: false),
      );

      try {
        // ✅ Debug prints
        debugPrint('🔍 Title: ${state.title} (${state.title.length})');
        debugPrint(
          '🔍 Description: ${state.description} (${state.description.length})',
        );
        debugPrint('🔍 Tags: ${state.selectedTags}');

        await apiService.createPost(
          title: state.title,
          description: state.description,
          tags: state.selectedTags,
        );

        emit(
          state.copyWith(
            isSubmitting: false,
            isSuccess: true,
            isFailure: false,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            isSubmitting: false,
            isSuccess: false,
            isFailure: false,
          ),
        );
      }
    });
  }
}
