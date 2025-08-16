// lib/presentation/posts/create_posts/bloc/create_posts_state.dart
import 'package:equatable/equatable.dart';

class CreatePostState extends Equatable {
  final String title;
  final String description;
  final List<String> selectedTags;

  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  /// رسالة خطأ اختيارية
  final String? errorMessage;

  const CreatePostState({
    required this.title,
    required this.description,
    required this.selectedTags,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFailure,
    this.errorMessage, // اختياري
  });

  factory CreatePostState.initial() => const CreatePostState(
        title: '',
        description: '',
        selectedTags: <String>[],
        isSubmitting: false,
        isSuccess: false,
        isFailure: false,
        errorMessage: null,
      );

  CreatePostState copyWith({
    String? title,
    String? description,
    List<String>? selectedTags,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? errorMessage, // تقدر تمرّر null لمسح الرسالة
  }) {
    return CreatePostState(
      title: title ?? this.title,
      description: description ?? this.description,
      selectedTags: selectedTags ?? this.selectedTags,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      errorMessage: errorMessage, // لو ما اتبعتش هتبقى null افتراضيًا
    );
  }

  @override
  List<Object?> get props => [
        title,
        description,
        selectedTags,
        isSubmitting,
        isSuccess,
        isFailure,
        errorMessage,
      ];
}
