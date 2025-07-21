// lib/presentation/investment/investment_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_founders/presentation/investment/bloc/investment_bloc.dart';
import 'package:flutter_founders/data/api/investment_api_service.dart';
import 'package:flutter_founders/presentation/investment/bloc/investment_event.dart';
import 'package:flutter_founders/presentation/investment/widgets/investment_page_content.dart';

class InvestmentPage extends StatelessWidget {
  const InvestmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InvestmentBloc(investmentApiService: InvestmentApiService())..add(LoadInvestments()),
      child: const InvestmentPageContent(),
    );
  }
}
