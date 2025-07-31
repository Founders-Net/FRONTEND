// lib/presentation/profile/bloc/partners_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_founders/data/api/partners_api_service.dart';
import 'package:flutter_founders/presentation/profile/models/partner_model.dart';
import 'partners_event.dart';
import 'partners_state.dart';

class PartnersBloc extends Bloc<PartnersEvent, PartnersState> {
  final PartnersApiService apiService;

  PartnersBloc(this.apiService) : super(PartnersState.initial()) {
    on<LoadPartners>(_onLoadPartners);
    on<SendPartnerRequest>(_onSendRequest);
    on<DeletePartner>(_onDeletePartner);
  }

  Future<void> _onLoadPartners(
    LoadPartners event,
    Emitter<PartnersState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final partners = await apiService.getPartners();
      emit(state.copyWith(partners: partners, isLoading: false));
    } catch (e) {
      print('❌ Error loading partners: $e');
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onSendRequest(
    SendPartnerRequest event,
    Emitter<PartnersState> emit,
  ) async {
    try {
      await apiService.sendPartnerRequest(event.userId);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onDeletePartner(
    DeletePartner event,
    Emitter<PartnersState> emit,
  ) async {
    try {
      await apiService.deletePartner(event.userId);
      final updated = List<PartnerModel>.from(state.partners)
        ..removeWhere((p) => p.id == event.userId);
      emit(state.copyWith(partners: updated));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
