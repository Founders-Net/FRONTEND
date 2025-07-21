import 'package:equatable/equatable.dart';
import 'package:flutter_founders/models/investment_model.dart';

abstract class InvestmentState extends Equatable {
  const InvestmentState();

  @override
  List<Object?> get props => [];
}

class InvestmentInitial extends InvestmentState {}

class InvestmentLoading extends InvestmentState {}

class InvestmentsLoaded extends InvestmentState {
  final List<InvestmentModel> investments;

  const InvestmentsLoaded(this.investments);

  @override
  List<Object?> get props => [investments];
}

class InvestmentLoaded extends InvestmentState {
  final InvestmentModel investment;

  const InvestmentLoaded(this.investment);

  @override
  List<Object?> get props => [investment];
}

class InvestmentCreated extends InvestmentState {
  final int investmentId;

  const InvestmentCreated(this.investmentId);

  @override
  List<Object?> get props => [investmentId];
}

class InvestmentDeleted extends InvestmentState {}

class InvestmentError extends InvestmentState {
  final String message;

  const InvestmentError(this.message);

  @override
  List<Object?> get props => [message];
}
