abstract class InvestmentDetailsEvent {}

/*class LoadInvestmentDetailsEvent extends InvestmentDetailsEvent {
  final InvestmentModel investment;

  LoadInvestmentDetailsEvent(this.investment);
}*/

class LoadInvestmentDetailsEvent extends InvestmentDetailsEvent {
  final int postId;
  LoadInvestmentDetailsEvent({required this.postId});
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