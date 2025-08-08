// ✅ lib/presentation/auth/code_verification/bloc/code_verification_bloc.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'code_verification_event.dart';
import 'code_verification_state.dart';
import '../../../../data/api/auth_api_service.dart';

class CodeVerificationBloc
    extends Bloc<CodeVerificationEvent, CodeVerificationState> {
  final AuthApiService authApiService;
  final String phoneNumber;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  CodeVerificationBloc({
    required this.authApiService,
    required this.phoneNumber,
  }) : super(CodeVerificationState.initial()) {
    on<CodeChanged>((event, emit) {
      emit(state.copyWith(code: event.code, errorMessage: null));
    });

    on<SubmitCode>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, errorMessage: null));
      try {
        final result = await authApiService.confirmCode(
          phoneNumber,
          event.smsCode,
        );
        final token = result['token'];

        debugPrint("🟢 Token from server: $token");
        await secureStorage.write(key: 'auth_token', value: token);
        debugPrint("🔥 TOKEN FOR POSTMAN: $token");

        final reRead = await secureStorage.read(key: 'auth_token');
        debugPrint("🔁 Token re-read after saving: $reRead");

        // ✅❌ لا ترسل sendRegisterRequest() هنا

        emit(
          state.copyWith(
            isSubmitting: false,
            isSuccess: true,
            userStatus: result['userStatus'] ?? '',
          ),
        );
      } catch (e) {
        debugPrint("❌ Error during code verification: $e");
        emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
      }
    });
  }
}
