import 'package:flutter/material.dart';
import 'package:flutter_founders/models/investment_model.dart';
import 'package:flutter_founders/presentation/investment/investment_details/investment_details.dart';
import 'package:flutter_founders/presentation/investment/models/details_investment_model.dart';

class InvestmentCard extends StatelessWidget {
  final InvestmentModel investment;

  const InvestmentCard({
    super.key,
    required this.investment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          final detailsModel = DetailsInvestmentModel(
            title: investment.title,
            amount: '${investment.investmentAmount.toStringAsFixed(0)} ₽',
            period: '${investment.paybackPeriodMonths} мес.',
            location: investment.country,
            description: investment.description,
            businessPlanUrl: investment.businessPlanUrl,
            financialModelUrl: investment.financialModelUrl,
            presentationUrl: investment.presentationUrl,
        
            managerName: investment.userName ?? 'Без имени',
            managerImage: investment.userAvatar ?? '',
            managerTags: investment.userInfo?.split(',') ?? [],
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => InvestmentDetailsPage(investment: detailsModel),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                investment.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'InriaSans',
                ),
              ),
              const SizedBox(height: 12),

              // Info rows
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Объём привлекаемых средств',
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'InriaSans',
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${investment.investmentAmount.toStringAsFixed(0)} ₽',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'InriaSans',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Срок окупаемости',
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'InriaSans',
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${investment.paybackPeriodMonths} месяцев',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'InriaSans',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Страна реализации',
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'InriaSans',
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    investment.country,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'InriaSans',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Status tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: investment.status == 'approved' ? Colors.green : Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  investment.status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'InriaSans',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
