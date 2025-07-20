import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_founders/data/api/auth_api_service.dart';
import 'phone_input_event.dart';
import 'phone_input_state.dart';

class PhoneInputBloc extends Bloc<PhoneInputEvent, PhoneInputState> {
  final AuthApiService authApiService;

  PhoneInputBloc(this.authApiService) : super(PhoneInputInitial()) {
    on<PhoneNumberChanged>((event, emit) {
      emit(PhoneInputInitial());
    });

    on<SubmitPhoneNumber>((event, emit) async {
      final phone = event.phoneNumber.trim();

      if (phone.isEmpty || phone.length < 10) {
        emit(PhoneInputFailure("رقم الهاتف غير صالح"));
        return;
      }

      try {
        await authApiService.sendPhoneRequest(phone);
        emit(PhoneSubmitSuccess(phone, 'dummy-verification-id'));
      } catch (e) {
        emit(PhoneInputFailure(e.toString()));
      }
    });
  }
}
