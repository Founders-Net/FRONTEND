import 'package:flutter_bloc/flutter_bloc.dart';
import 'investment_event.dart';
import 'investment_state.dart';
import 'package:flutter_founders/data/api/investment_api_service.dart';

class InvestmentBloc extends Bloc<InvestmentEvent, InvestmentState> {
  final InvestmentApiService investmentApiService;

  InvestmentBloc({required this.investmentApiService}) : super(InvestmentInitial()) {
    on<LoadInvestments>(_onLoadInvestments);
    on<LoadInvestmentById>(_onLoadInvestmentById);
    on<CreateInvestment>(_onCreateInvestment);
    on<DeleteInvestment>(_onDeleteInvestment);
  }

  Future<void> _onLoadInvestments(LoadInvestments event, Emitter<InvestmentState> emit) async {
    emit(InvestmentLoading());
    try {
      final investments = await investmentApiService.getInvestments(
        cursor: event.cursor,
        limit: event.limit,
      );
      emit(InvestmentsLoaded(investments));
    } catch (e) {
      emit(InvestmentError('Failed to load investments'));
    }
  }

  Future<void> _onLoadInvestmentById(LoadInvestmentById event, Emitter<InvestmentState> emit) async {
    emit(InvestmentLoading());
    try {
      final investment = await investmentApiService.getInvestmentById(event.id);
      emit(InvestmentLoaded(investment));
    } catch (e) {
      emit(InvestmentError('Failed to load investment'));
    }
  }

  Future<void> _onCreateInvestment(CreateInvestment event, Emitter<InvestmentState> emit) async {
  emit(InvestmentLoading());
  try {
    final result = await investmentApiService.createInvestment(
      title: event.title,
      description: event.description,
      investmentAmount: event.investmentAmount,
      paybackPeriodMonths: event.paybackPeriodMonths,
      country: event.country,
      businessPlanUrl: event.businessPlanUrl,
      financialModelUrl: event.financialModelUrl,
      presentationUrl: event.presentationUrl,
    );
    final investmentId = result.data['investmentId']; 
    if (investmentId != null) {
      emit(InvestmentCreated(investmentId));
    } else {
      emit(InvestmentError('Investment created but ID not returned.'));
    }
  } catch (e) {
    emit(InvestmentError('Failed to create investment'));
  }
}

  Future<void> _onDeleteInvestment(DeleteInvestment event, Emitter<InvestmentState> emit) async {
    emit(InvestmentLoading());
    try {
      await investmentApiService.deleteInvestment(event.id);
      emit(InvestmentDeleted());
    } catch (e) {
      emit(InvestmentError('Failed to delete investment'));
    }
  }
}
