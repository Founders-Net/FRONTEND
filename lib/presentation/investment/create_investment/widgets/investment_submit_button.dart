import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/create_investment_bloc.dart';
import '../bloc/create_investment_state.dart';
import '../bloc/create_investment_event.dart';

class InvestmentSubmitButton extends StatelessWidget {
  const InvestmentSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateInvestmentBloc, CreateInvestmentState>(
      listener: (context, state) {
        if (state.submissionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Инвестиция отправлена на модерацию ✅',
                style: TextStyle(fontFamily: 'InriaSans'),
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state.submissionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Пожалуйста, заполните все поля ✏️',
                style: TextStyle(fontFamily: 'InriaSans'),
              ),
              backgroundColor: Colors.red,
            ),
          );
          // ✅ reset submissionFailure after showing snackbar
          context.read<CreateInvestmentBloc>().emit(
                state.copyWith(submissionFailure: false),
              );
        }
      },
      builder: (context, state) {
        final isLoading = state.isSubmitting;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    context.read<CreateInvestmentBloc>().add(SubmitInvestmentEvent());
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFAF925D),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Text(
                    'Отправить на модерацию',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'InriaSans',
                    ),
                  ),
          ),
        );
      },
    );
  }
}
