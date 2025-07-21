import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

abstract class CreateInvestmentEvent extends Equatable {
  const CreateInvestmentEvent();

  @override
  List<Object?> get props => [];
}

class SubmitInvestmentEvent extends CreateInvestmentEvent {}

class UpdateTextField extends CreateInvestmentEvent {
  final String fieldKey;
  final String value;

  const UpdateTextField({required this.fieldKey, required this.value});

  @override
  List<Object?> get props => [fieldKey, value];
}

class UpdateDocument extends CreateInvestmentEvent {
  final String key;
  final PlatformFile file;

  const UpdateDocument({required this.key, required this.file});

  @override
  List<Object?> get props => [key, file];
}
