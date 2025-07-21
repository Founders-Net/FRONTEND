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
      emit(state.copyWith(
        isLoading: false,
        investment: event.investment,
        isLiked: false,
      ));
    });

    on<ToggleLikeInvestmentEvent>((event, emit) async {
      try {
        if (event.isLiked) {
          await apiService.unlikeInvestment(event.investmentId);
          emit(state.copyWith(isLiked: false));
        } else {
          await apiService.likeInvestment(event.investmentId);
          emit(state.copyWith(isLiked: true));
        }
      } catch (_) {
        // Handle error silently or emit error state
      }
    });

    on<SetLikedStateEvent>((event, emit) {
      emit(state.copyWith(isLiked: event.isLiked));
    });
  }
}