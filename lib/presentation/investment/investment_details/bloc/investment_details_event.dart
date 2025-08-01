import 'package:flutter_founders/models/investment_model.dart';

abstract class InvestmentDetailsEvent {}

class LoadInvestmentDetailsEvent extends InvestmentDetailsEvent {
  final InvestmentModel investment;

  LoadInvestmentDetailsEvent(this.investment);
}

class ToggleLikeInvestmentEvent extends InvestmentDetailsEvent {
  final int postId;
  final bool isLiked;
  ToggleLikeInvestmentEvent({required this.postId, required this.isLiked});
}

class SetLikedStateEvent extends InvestmentDetailsEvent {
  final bool isLiked;
  SetLikedStateEvent({required this.isLiked});
}