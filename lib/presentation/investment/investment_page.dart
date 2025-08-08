import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_founders/presentation/investment/bloc/investment_bloc.dart';
import 'package:flutter_founders/presentation/investment/bloc/investment_event.dart';
import 'package:flutter_founders/data/api/investment_api_service.dart';
import 'package:flutter_founders/presentation/investment/widgets/investment_page_content.dart';

class InvestmentPage extends StatefulWidget {
  const InvestmentPage({super.key});

  @override
  State<InvestmentPage> createState() => _InvestmentPageState();
}

class _InvestmentPageState extends State<InvestmentPage> {
  late InvestmentBloc _investmentBloc;

  @override
  void initState() {
    super.initState();
    _investmentBloc = InvestmentBloc(investmentApiService: InvestmentApiService());
    _investmentBloc.add(const LoadInvestments());
  }

  @override
  void dispose() {
    _investmentBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _investmentBloc,
      child: const InvestmentPageContent(),
    );
  }
}
