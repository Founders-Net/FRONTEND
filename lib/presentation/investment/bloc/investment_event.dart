import 'package:equatable/equatable.dart';

abstract class InvestmentEvent extends Equatable {
  const InvestmentEvent();

  @override
  List<Object?> get props => [];
}

class LoadInvestments extends InvestmentEvent {
  final int cursor;
  final int limit;

  const LoadInvestments({this.cursor = 0, this.limit = 10});

  @override
  List<Object?> get props => [cursor, limit];
}

class LoadInvestmentById extends InvestmentEvent {
  final int id;

  const LoadInvestmentById(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateInvestment extends InvestmentEvent {
  final String title;
  final String description;
  final int investmentAmount;
  final int paybackPeriodMonths;
  final String country;
  final String businessPlanUrl;
  final String financialModelUrl;
  final String presentationUrl;


  const CreateInvestment({
    required this.title,
    required this.description,
    required this.investmentAmount,
    required this.paybackPeriodMonths,
    required this.country,
    required this.businessPlanUrl,
    required this.financialModelUrl,
    required this.presentationUrl
  });

  @override
  List<Object?> get props => [title, description, investmentAmount, paybackPeriodMonths, country];
}

class DeleteInvestment extends InvestmentEvent {
  final int id;

  const DeleteInvestment(this.id);

  @override
  List<Object?> get props => [id];
}
