import 'package:equatable/equatable.dart';

class CodeVerificationState extends Equatable {
  final String code;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;
  final String userStatus;

  const CodeVerificationState({
    required this.code,
    required this.isSubmitting,
    required this.isSuccess,
    required this.userStatus,
    this.errorMessage,
  });

  factory CodeVerificationState.initial() {
    return const CodeVerificationState(
      code: '',
      isSubmitting: false,
      isSuccess: false,
      userStatus: '',
      errorMessage: null,
    );
  }

  CodeVerificationState copyWith({
    String? code,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    String? userStatus,
  }) {
    return CodeVerificationState(
      code: code ?? this.code,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      userStatus: userStatus ?? this.userStatus,
    );
  }

  @override
  List<Object?> get props => [
    code,
    isSubmitting,
    isSuccess,
    userStatus,
    errorMessage,
  ];
}
