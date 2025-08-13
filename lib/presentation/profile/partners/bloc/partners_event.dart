import 'package:equatable/equatable.dart';

abstract class PartnersEvent extends Equatable {
  const PartnersEvent();
  @override
  List<Object?> get props => [];
}

class LoadPartners extends PartnersEvent {}

class SendPartnerRequest extends PartnersEvent {
  final int userId;
  const SendPartnerRequest(this.userId);
  @override
  List<Object?> get props => [userId];
}

class DeletePartner extends PartnersEvent {
  final int userId;
  const DeletePartner(this.userId);
  @override
  List<Object?> get props => [userId];
}

// ✅ جديد
class LoadIncomingRequests extends PartnersEvent {}

class LoadOutgoingRequests extends PartnersEvent {}

class RespondIncomingRequest extends PartnersEvent {
  final int id;
  final String status; // "accepted" | "rejected"
  const RespondIncomingRequest({required this.id, required this.status});

  @override
  List<Object?> get props => [id, status];
}

class CancelOutgoingRequest extends PartnersEvent {
  final int requestId;
  const CancelOutgoingRequest(this.requestId);

  @override
  List<Object?> get props => [requestId];
}
