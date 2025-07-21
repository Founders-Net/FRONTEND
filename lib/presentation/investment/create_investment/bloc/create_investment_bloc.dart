import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_founders/data/api/investment_api_service.dart';
import 'package:flutter_founders/presentation/investment/create_investment/bloc/create_investment_event.dart';
import 'package:flutter_founders/presentation/investment/create_investment/bloc/create_investment_state.dart';

class CreateInvestmentBloc extends Bloc<CreateInvestmentEvent, CreateInvestmentState> {
  final InvestmentApiService investmentApiService;

  CreateInvestmentBloc({required this.investmentApiService}) : super(const CreateInvestmentState()) {
    on<SubmitInvestmentEvent>(_onSubmitInvestment);
    on<UpdateTextField>(_onUpdateTextField);
    on<UpdateDocument>(_onUpdateDocument);
  }

  Future<void> _onSubmitInvestment(
    SubmitInvestmentEvent event,
    Emitter<CreateInvestmentState> emit,
  ) async {
    emit(state.copyWith(
      isSubmitting: true,
      submissionSuccess: false,
      submissionFailure: false,
    ));

    try {
      final response = await investmentApiService.createInvestment(
        title: state.title,
        description: state.description,
        investmentAmount: int.tryParse(state.investmentAmount) ?? 0,
        paybackPeriodMonths: int.tryParse(state.paybackPeriodMonths) ?? 0, 
        country: state.country,
        businessPlanUrl: state.documents['doc1']?.path ?? '',
        financialModelUrl: state.documents['doc2']?.path ?? '',
        presentationUrl: state.documents['doc3']?.path ?? '',
      );

      final statusMsg = response.data['statusMsg'];
      final message = response.data['message'] ?? 'Unknown response';

      if (response.statusCode == 200 && statusMsg == 'success') {
        emit(state.copyWith(
          isSubmitting: false,
          submissionSuccess: true,
          submissionFailure: false,
        ));
      } else {
        emit(state.copyWith(
          isSubmitting: false,
          submissionSuccess: false,
          submissionFailure: true,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        submissionSuccess: false,
        submissionFailure: true,
      ));
    }
  }

  void _onUpdateTextField(UpdateTextField event, Emitter<CreateInvestmentState> emit) {
    switch (event.fieldKey) {
      case 'title':
        emit(state.copyWith(title: event.value));
        break;
      case 'description':
        emit(state.copyWith(description: event.value));
        break;
      case 'country':
        emit(state.copyWith(country: event.value));
        break;
      case 'status':
        emit(state.copyWith(status: event.value));
        break;
      case 'additional':
        emit(state.copyWith(additional: event.value));
        break;
      case 'investmentAmount':
        /*final parsed = int.tryParse(event.value);
        if (parsed != null) {*/
        emit(state.copyWith(investmentAmount: event.value)); 
        //}
        break;
      case 'paybackPeriodMonths':
        /*final parsed = int.tryParse(event.value);
        if (parsed != null) {*/
          emit(state.copyWith(paybackPeriodMonths: event.value));
        //}
        break;
    }
  }

  void _onUpdateDocument(UpdateDocument event, Emitter<CreateInvestmentState> emit) {
    final updatedDocs = Map<String, PlatformFile>.from(state.documents);
    updatedDocs[event.key] = event.file;
    emit(state.copyWith(documents: updatedDocs));
  }
}
