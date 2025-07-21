import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_founders/presentation/investment/bloc/investment_bloc.dart';
import 'package:flutter_founders/presentation/investment/bloc/investment_state.dart';
import 'package:flutter_founders/models/investment_model.dart';
import 'package:flutter_founders/presentation/investment/widgets/investment_card.dart';

class InvestmentPageContent extends StatelessWidget {
  const InvestmentPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvestmentBloc, InvestmentState>(
      builder: (context, state) {
        if (state is InvestmentLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is InvestmentsLoaded) {
          final investments = state.investments;

          if (investments.isEmpty) {
            return const Center(child: Text('Нет доступных инвестиций.'));
          }

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: investments.length,
            itemBuilder: (context, index) {
              final investment = investments[index];
              return InvestmentCard(investment: investment);
            },
          );
        } else if (state is InvestmentError) {
          return Center(child: Text('Ошибка: ${state.message}'));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
