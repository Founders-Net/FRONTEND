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

  // ✅ Helper to format amount like "1000" → "1000.00"
  String normalizeAmount(String value) {
    final cleaned = value.replaceAll(',', '.').trim();
    final parsed = double.tryParse(cleaned);
    return parsed != null ? parsed.toStringAsFixed(2) : '';
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

    final normalizedAmount = normalizeAmount(state.investmentAmount);

    // Fail early if the amount is invalid or empty fields exist
    if (normalizedAmount.isEmpty ||
        state.title.trim().isEmpty ||
        state.description.trim().isEmpty ||
        state.country.trim().isEmpty ||
        state.paybackPeriodMonths.trim().isEmpty) {
      emit(state.copyWith(
        isSubmitting: false,
        submissionFailure: true,
      ));
      return;
    }

    try {
      final response = await investmentApiService.createInvestment(
        title: state.title.trim(),
        description: state.description.trim(),
        investmentAmount: normalizedAmount,
        paybackPeriodMonths: state.paybackPeriodMonths.trim(),
        country: state.country.trim(),
        businessPlanUrl: state.documents['doc1']?.path ?? '',
        financialModelUrl: state.documents['doc2']?.path ?? '',
        presentationUrl: state.documents['doc3']?.path ?? '',
      );

      final success = response.statusCode == 200 || response.statusCode == 201;
      final hasId = response.data['investmentId'] != null;

      if (success && hasId) {
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
        emit(state.copyWith(investmentAmount: event.value));
        break;
      case 'paybackPeriodMonths':
        emit(state.copyWith(paybackPeriodMonths: event.value));
        break;
    }
  }

  void _onUpdateDocument(UpdateDocument event, Emitter<CreateInvestmentState> emit) {
    final updatedDocs = Map<String, PlatformFile>.from(state.documents);
    updatedDocs[event.key] = event.file;
    emit(state.copyWith(documents: updatedDocs));
  }
}
