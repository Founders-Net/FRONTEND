// lib/models/register_status.dart
class RegisterStatusResponse {
  final String message;

  RegisterStatusResponse({required this.message});

  factory RegisterStatusResponse.fromJson(Map<String, dynamic> json) {
    return RegisterStatusResponse(
      message: json['message'],
    );
  }
}
