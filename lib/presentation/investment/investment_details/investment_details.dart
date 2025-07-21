import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_founders/models/investment_model.dart';
import 'package:flutter_founders/presentation/investment/investment_details/bloc/investment_details_state.dart';
import 'widgets/investment_header.dart';
import 'widgets/investment_manager_info.dart';
import 'widgets/investment_description_card.dart';
import 'widgets/investment_action_buttons_row.dart';
import 'bloc/investment_details_bloc.dart';
import 'bloc/investment_details_event.dart';
import 'package:flutter_founders/data/api/investment_api_service.dart';

class InvestmentDetailsPage extends StatelessWidget {
  final InvestmentModel investment;

  const InvestmentDetailsPage({super.key, required this.investment});

  @override
  Widget build(BuildContext context) {
    debugPrint('🔄 Building InvestmentDetailsPage for ID: ${investment.id}');
    return BlocProvider(
      create: (_) {
        debugPrint('🚀 Creating InvestmentDetailsBloc and loading investment...');
        return InvestmentDetailsBloc(apiService: InvestmentApiService())
          ..add(LoadInvestmentDetailsEvent(investment));
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Инвестиция',
            style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'InriaSans'),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<InvestmentDetailsBloc, InvestmentDetailsState>(
            builder: (context, state) {
              debugPrint('📦 BlocBuilder rebuild: isLoading=${state.isLoading}, isLiked=${state.isLiked}');
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              final investment = state.investment!;
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InvestmentHeader(model: investment),
                    const SizedBox(height: 24),

                    InvestmentManagerInfo(
                      name: investment.userName ?? 'Без имени',
                      imageUrl: investment.userAvatar ?? '',
                      tags: investment.userInfo != null
                          ? investment.userInfo!.split(',')
                          : [],
                    ),
                    const SizedBox(height: 24),

                    InvestmentDescriptionCard(description: investment.description),
                    const SizedBox(height: 24),
                    const SizedBox(height: 32),
                    const InvestmentActionButtonsRow(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
