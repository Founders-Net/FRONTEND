import 'package:equatable/equatable.dart';
import 'package:flutter_founders/presentation/profile/models/partner_model.dart';
import 'package:flutter_founders/presentation/profile/models/partner_request_model.dart';

class PartnersState extends Equatable {
  // الشركاء الحاليين
  final bool isLoadingPartners;
  final List<PartnerModel> partners;
  final String? errorPartners;

  // الطلبات الواردة
  final bool isLoadingIncoming;
  final List<PartnerRequestModel> incoming;
  final String? errorIncoming;

  // الطلبات الصادرة
  final bool isLoadingOutgoing;
  final List<PartnerRequestModel> outgoing;
  final String? errorOutgoing;

  // نتيجة إرسال طلب
  final bool requestSent;
  final String? error; // عام (لو محتاجه)

  const PartnersState({
    this.isLoadingPartners = false,
    this.partners = const [],
    this.errorPartners,
    this.isLoadingIncoming = false,
    this.incoming = const [],
    this.errorIncoming,
    this.isLoadingOutgoing = false,
    this.outgoing = const [],
    this.errorOutgoing,
    this.requestSent = false,
    this.error,
  });

  factory PartnersState.initial() => const PartnersState();

  PartnersState copyWith({
    bool? isLoadingPartners,
    List<PartnerModel>? partners,
    String? errorPartners,
    bool? isLoadingIncoming,
    List<PartnerRequestModel>? incoming,
    String? errorIncoming,
    bool? isLoadingOutgoing,
    List<PartnerRequestModel>? outgoing,
    String? errorOutgoing,
    bool? requestSent,
    String? error,
  }) {
    return PartnersState(
      isLoadingPartners: isLoadingPartners ?? this.isLoadingPartners,
      partners: partners ?? this.partners,
      errorPartners: errorPartners,
      isLoadingIncoming: isLoadingIncoming ?? this.isLoadingIncoming,
      incoming: incoming ?? this.incoming,
      errorIncoming: errorIncoming,
      isLoadingOutgoing: isLoadingOutgoing ?? this.isLoadingOutgoing,
      outgoing: outgoing ?? this.outgoing,
      errorOutgoing: errorOutgoing,
      requestSent: requestSent ?? this.requestSent,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        isLoadingPartners,
        partners,
        errorPartners,
        isLoadingIncoming,
        incoming,
        errorIncoming,
        isLoadingOutgoing,
        outgoing,
        errorOutgoing,
        requestSent,
        error,
      ];
}
