// lib/presentation/profile/bloc/partners_state.dart

import 'package:equatable/equatable.dart';
import 'package:flutter_founders/presentation/profile/models/partner_model.dart';

class PartnersState extends Equatable {
  final bool isLoading;
  final List<PartnerModel> partners;
  final String? error;

  const PartnersState({
    required this.isLoading,
    required this.partners,
    this.error,
  });

  factory PartnersState.initial() => const PartnersState(
        isLoading: false,
        partners: [],
        error: null,
      );

  PartnersState copyWith({
    bool? isLoading,
    List<PartnerModel>? partners,
    String? error,
  }) {
    return PartnersState(
      isLoading: isLoading ?? this.isLoading,
      partners: partners ?? this.partners,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, partners, error];
}
