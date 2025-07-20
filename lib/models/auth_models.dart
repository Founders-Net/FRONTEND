// lib/models/auth_models.dart
class SmsRequest {
  final String fio;
  final String phone;

  SmsRequest({required this.fio, required this.phone});

  Map<String, dynamic> toJson() => {
        "fio": fio,
        "phone": phone,
      };
}

class SmsConfirmRequest {
  final String phone;
  final String code;

  SmsConfirmRequest({required this.phone, required this.code});

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "code": code,
      };
}

class SmsConfirmResponse {
  final String token;
  final String userStatus;

  SmsConfirmResponse({required this.token, required this.userStatus});

  factory SmsConfirmResponse.fromJson(Map<String, dynamic> json) {
    return SmsConfirmResponse(
      token: json['token'],
      userStatus: json['userStatus'],
    );
  }
}
