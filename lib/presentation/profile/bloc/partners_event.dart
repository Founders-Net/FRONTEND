// lib/presentation/profile/bloc/partners_event.dart

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
