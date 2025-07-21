import 'package:equatable/equatable.dart';
import 'package:flutter_founders/models/investment_model.dart';

class InvestmentDetailsState extends Equatable {
  final bool isLoading;
  final InvestmentModel? investment;
  final bool isLiked;

  const InvestmentDetailsState({
    required this.isLoading,
    this.investment,
    this.isLiked = false,
  });

  factory InvestmentDetailsState.initial() {
    return const InvestmentDetailsState(isLoading: true);
  }

  InvestmentDetailsState copyWith({
    bool? isLoading,
    InvestmentModel? investment,
    bool? isLiked,
  }) {
    return InvestmentDetailsState(
      isLoading: isLoading ?? this.isLoading,
      investment: investment ?? this.investment,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  List<Object?> get props => [isLoading, investment ?? '', isLiked];
}