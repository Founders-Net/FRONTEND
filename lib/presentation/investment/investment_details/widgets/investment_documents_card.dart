import 'package:flutter/material.dart';

class InvestmentDocumentsCard extends StatelessWidget {
  final String investmentTitle;
  final String? businessPlanUrl;
  final String? financialModelUrl;
  final String? presentationUrl;

  const InvestmentDocumentsCard({
    super.key,
    required this.investmentTitle,
    this.businessPlanUrl,
    this.financialModelUrl,
    this.presentationUrl,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];

    if (businessPlanUrl != null && businessPlanUrl!.isNotEmpty) {
      items.add(_buildDocChip('Бизнес-план'));
    } else {
      items.add(_buildFallback('бизнес-план'));
    }

    if (financialModelUrl != null && financialModelUrl!.isNotEmpty) {
      items.add(_buildDocChip('Финансовая модель'));
    } else {
      items.add(_buildFallback('финансовая модель'));
    }

    if (presentationUrl != null && presentationUrl!.isNotEmpty) {
      items.add(_buildDocChip('Презентация'));
    } else {
      items.add(_buildFallback('презентация'));
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Документы',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'InriaSans',
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Column(children: items),
        ],
      ),
    );
  }

  Widget _buildDocChip(String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: 'InriaSans',
        ),
      ),
    );
  }

  Widget _buildFallback(String docName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        'Для инвестиции $investmentTitle $docName отсутствует',
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 13,
          fontFamily: 'InriaSans',
        ),
      ),
    );
  }
}
