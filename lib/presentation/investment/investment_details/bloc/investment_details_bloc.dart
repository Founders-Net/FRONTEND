import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'investment_details_event.dart';
import 'investment_details_state.dart';
import 'package:flutter_founders/data/api/investment_api_service.dart';

class InvestmentDetailsBloc extends Bloc<InvestmentDetailsEvent, InvestmentDetailsState> {
  final InvestmentApiService apiService;

  InvestmentDetailsBloc({required this.apiService}) : super(InvestmentDetailsState.initial()) {
  on<LoadInvestmentDetailsEvent>((event, emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final investment = await apiService.getInvestmentById(event.postId); // make sure you're using postId now
      emit(state.copyWith(
        isLoading: false,
        investment: investment,
        isLiked: investment.liked,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint('❌ Failed to load investment: $e');
    }
  });

    on<ToggleLikeInvestmentEvent>((event, emit) async {
      final currentlyLiked = state.isLiked;
      emit(state.copyWith(isLiked: !currentlyLiked));
      try {
        if (currentlyLiked) {
          await apiService.unlikeInvestment(event.postId);
          debugPrint('💔 Unliked investment ${event.postId}');
        } else {
          await apiService.likeInvestment(event.postId);
          debugPrint('❤️ Liked investment ${event.postId}');
        }
      } catch (e) {
        emit(state.copyWith(isLiked: currentlyLiked)); // ❌ Revert on error
        debugPrint('❌ Error toggling like: $e');
      }
    });

    on<SetLikedStateEvent>((event, emit) {
      emit(state.copyWith(isLiked: event.isLiked));
    });
  }
}
