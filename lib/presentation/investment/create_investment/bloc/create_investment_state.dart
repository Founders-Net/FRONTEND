import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

class CreateInvestmentState extends Equatable {
  final String title;
  final String description;
  final String country;
  final String investmentAmount; 
  final String paybackPeriodMonths; 
  final String status;
  final String additional;
  final Map<String, PlatformFile> documents;

  final bool isSubmitting;
  final bool submissionSuccess;
  final bool submissionFailure;

  const CreateInvestmentState({
    this.title = '',
    this.description = '',
    this.country = '',
    this.investmentAmount = '', // Default empty string
    this.paybackPeriodMonths = '', // Default empty string
    this.status = '',
    this.additional = '',
    this.documents = const {},
    this.isSubmitting = false,
    this.submissionSuccess = false,
    this.submissionFailure = false,
  });

  CreateInvestmentState copyWith({
    String? title,
    String? description,
    String? country,
    String? investmentAmount,
    String? paybackPeriodMonths,
    String? status,
    String? additional,
    Map<String, PlatformFile>? documents,
    bool? isSubmitting,
    bool? submissionSuccess,
    bool? submissionFailure,
  }) {
    return CreateInvestmentState(
      title: title ?? this.title,
      description: description ?? this.description,
      country: country ?? this.country,
      investmentAmount: investmentAmount ?? this.investmentAmount,
      paybackPeriodMonths: paybackPeriodMonths ?? this.paybackPeriodMonths,
      status: status ?? this.status,
      additional: additional ?? this.additional,
      documents: documents ?? this.documents,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submissionSuccess: submissionSuccess ?? this.submissionSuccess,
      submissionFailure: submissionFailure ?? this.submissionFailure,
    );
  }

  @override
  List<Object?> get props => [
        title,
        description,
        country,
        investmentAmount,
        paybackPeriodMonths,
        status,
        additional,
        documents,
        isSubmitting,
        submissionSuccess,
        submissionFailure,
      ];
}
