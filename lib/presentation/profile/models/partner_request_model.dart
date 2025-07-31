// lib/models/partner_request_model.dart

class PartnerRequestModel {
  final int id;
  final int requesterId;
  final int recipientId;
  final String status;

  PartnerRequestModel({
    required this.id,
    required this.requesterId,
    required this.recipientId,
    required this.status,
  });

  factory PartnerRequestModel.fromJson(Map<String, dynamic> json) {
    return PartnerRequestModel(
      id: json['id'],
      requesterId: json['requesterId'],
      recipientId: json['recipientId'],
      status: json['status'],
    );
  }
}
