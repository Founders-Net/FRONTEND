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
      // ✅ فاليديشن واضحة برسالة مفهومة
      final title = state.title.trim();
      final desc = state.description.trim();
      final tags = state.selectedTags;

      String? validationMsg;
      if (title.isEmpty) {
        validationMsg = 'العنوان مطلوب';
      } else if (desc.isEmpty) {
        validationMsg = 'الوصف مطلوب';
      } else if (tags.isEmpty) {
        validationMsg = 'اختر وسمًا واحدًا على الأقل';
      }

      if (validationMsg != null) {
        emit(state.copyWith(
          isFailure: true,
          isSubmitting: false,
          isSuccess: false,
          errorMessage: validationMsg,
        ));
        return;
      }

      emit(state.copyWith(
        isSubmitting: true,
        isSuccess: false,
        isFailure: false,
        errorMessage: null,
      ));

      try {
        debugPrint('🔍 Title: ${state.title} (${state.title.length})');
        debugPrint('🔍 Description: ${state.description} (${state.description.length})');
        debugPrint('🔍 Tags: ${state.selectedTags}');

        await apiService.createPost(
          title: title,
          description: desc,
          tags: tags,
        );

        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: true,
          isFailure: false,
          errorMessage: null,
        ));
      } catch (e, st) {
        debugPrint('❌ createPost failed: $e\n$st');
        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: false,
          isFailure: true,          // ✅ مهم: فعّل حالة الفشل
          errorMessage: e.toString(), // ✅ اظهر رسالة مفيدة
        ));
      }
    });
  }
}
