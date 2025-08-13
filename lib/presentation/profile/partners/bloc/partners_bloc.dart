import 'package:flutter/material.dart';
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

    // جديد
    on<LoadIncomingRequests>(_onLoadIncoming);
    on<LoadOutgoingRequests>(_onLoadOutgoing);
    on<RespondIncomingRequest>(_onRespondIncoming);

    // ✅ جديد: إلغاء الطلب الصادر
    on<CancelOutgoingRequest>(_onCancelOutgoing);
  }

  Future<void> _onLoadPartners(
    LoadPartners event,
    Emitter<PartnersState> emit,
  ) async {
    emit(state.copyWith(isLoadingPartners: true, errorPartners: null));
    try {
      final partners = await apiService.getPartners();
      emit(state.copyWith(partners: partners, isLoadingPartners: false));
    } catch (e) {
      debugPrint('❌ Error loading partners: $e');
      emit(
        state.copyWith(errorPartners: e.toString(), isLoadingPartners: false),
      );
    }
  }

  Future<void> _onSendRequest(
    SendPartnerRequest event,
    Emitter<PartnersState> emit,
  ) async {
    try {
      emit(state.copyWith(requestSent: false, error: null));
      await apiService.sendPartnerRequest(event.userId);
      // لا نعيد تحميل الشركاء الآن — الظهور بعد الموافقة
      emit(state.copyWith(requestSent: true, error: null));
    } catch (e) {
      debugPrint('❌ sendPartnerRequest error: $e');
      emit(state.copyWith(requestSent: false, error: e.toString()));
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
      emit(state.copyWith(errorPartners: e.toString()));
    }
  }

  // الوارد
  Future<void> _onLoadIncoming(
    LoadIncomingRequests event,
    Emitter<PartnersState> emit,
  ) async {
    emit(state.copyWith(isLoadingIncoming: true, errorIncoming: null));
    try {
      final list = await apiService.getIncomingRequests();
      emit(state.copyWith(incoming: list, isLoadingIncoming: false));
    } catch (e) {
      emit(
        state.copyWith(errorIncoming: e.toString(), isLoadingIncoming: false),
      );
    }
  }

  // الصادر
  Future<void> _onLoadOutgoing(
    LoadOutgoingRequests event,
    Emitter<PartnersState> emit,
  ) async {
    emit(state.copyWith(isLoadingOutgoing: true, errorOutgoing: null));
    try {
      final list = await apiService.getOutgoingRequests();
      emit(state.copyWith(outgoing: list, isLoadingOutgoing: false));
    } catch (e) {
      emit(
        state.copyWith(errorOutgoing: e.toString(), isLoadingOutgoing: false),
      );
    }
  }

  // الرد على الوارد
  Future<void> _onRespondIncoming(
    RespondIncomingRequest event,
    Emitter<PartnersState> emit,
  ) async {
    try {
      await apiService.respondToRequest(
        event.id,
        event.status,
      ); // "accepted" | "rejected"
      // بعد القبول: حدّث الوارد + الشركاء
      add(LoadIncomingRequests());
      if (event.status == 'accepted') {
        add(LoadPartners());
      }
    } catch (e) {
      debugPrint('❌ respondToRequest error: $e');
    }
  }

  // ✅ إلغاء الطلب الصادر
  Future<void> _onCancelOutgoing(
    CancelOutgoingRequest event,
    Emitter<PartnersState> emit,
  ) async {
    try {
      // ممكن نحط لودينج خفيف لو حابب، هنا بنصفّر الخطأ فقط
      emit(state.copyWith(errorOutgoing: null));
      await apiService.cancelOutgoingRequest(event.requestId);
      // بعد الإلغاء: حمّل الصادر من جديد
      add(LoadOutgoingRequests());
    } catch (e) {
      debugPrint('❌ cancelOutgoingRequest error: $e');
      emit(state.copyWith(errorOutgoing: e.toString()));
    }
  }
}
