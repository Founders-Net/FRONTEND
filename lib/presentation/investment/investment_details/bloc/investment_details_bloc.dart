import 'package:flutter_bloc/flutter_bloc.dart';
import 'investment_details_event.dart';
import 'investment_details_state.dart';
import 'package:flutter_founders/data/api/investment_api_service.dart';

class InvestmentDetailsBloc extends Bloc<InvestmentDetailsEvent, InvestmentDetailsState> {
  final InvestmentApiService apiService;

  InvestmentDetailsBloc({required this.apiService}) : super(InvestmentDetailsState.initial()) {
    on<LoadInvestmentDetailsEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      await Future.delayed(const Duration(milliseconds: 500)); 

      bool isLiked = event.investment.likesCount != null && event.investment.likesCount! > 0;
      
      emit(state.copyWith(
        isLoading: false,
        investment: event.investment,
        isLiked: isLiked, 
      ));
    });

    on<ToggleLikeInvestmentEvent>((event, emit) async {
      final currentlyLiked = state.isLiked;
      try {
        if (currentlyLiked) {
          await apiService.unlikeInvestment(event.postId);
          print('💔 Unliked investment ${event.postId}');
        } else {
          await apiService.likeInvestment(event.postId);
          print('❤️ Liked investment ${event.postId}');
        }
        emit(state.copyWith(isLiked: !currentlyLiked)); 
      } catch (e) {
        print('❌ Error toggling like: $e');
      }
    });

    on<SetLikedStateEvent>((event, emit) {
      emit(state.copyWith(isLiked: event.isLiked));
    });
  }
}
