import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_founders/models/investment_model.dart';
import 'package:flutter_founders/presentation/investment/investment_details/bloc/investment_details_bloc.dart';
import 'package:flutter_founders/presentation/investment/investment_details/bloc/investment_details_event.dart';
import 'package:flutter_founders/presentation/investment/investment_details/bloc/investment_details_state.dart';

class InvestmentHeader extends StatelessWidget {
  final InvestmentModel model;

  const InvestmentHeader({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          model.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'InriaSans',
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 23, 23, 23),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoRow(label: 'Объём привлекаемых средств', value: '${model.investmentAmount} ₽'),
              const SizedBox(height: 14),
              _InfoRow(label: 'Срок окупаемости', value: '${model.paybackPeriodMonths} мес.'),
              const SizedBox(height: 14),
              _InfoRow(label: 'Страна реализации', value: model.country),
              const SizedBox(height: 14),
              _FileBlock(
                label: 'Бизнес-план',
                fileName: (model.businessPlanUrl != null && model.businessPlanUrl!.isNotEmpty)
                    ? 'Документ загружен'
                    : 'Документ отсутствует',
              ),
              const SizedBox(height: 14),
              _FileBlock(
                label: 'Финансовая модель',
                fileName: (model.financialModelUrl != null && model.financialModelUrl!.isNotEmpty)
                    ? 'Документ загружен'
                    : 'Документ отсутствует',
              ),
              const SizedBox(height: 14),
              _FileBlock(
                label: 'Презентация',
                fileName: (model.presentationUrl != null && model.presentationUrl!.isNotEmpty)
                    ? 'Документ загружен'
                    : 'Документ отсутствует',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _LikeButton(postId: model.id),
            const _IconButton(icon: Icons.bookmark_border),
          ],
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.white, fontFamily: 'InriaSans')),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'InriaSans')),
      ],
    );
  }
}

class _FileBlock extends StatelessWidget {
  final String label;
  final String fileName;

  const _FileBlock({required this.label, required this.fileName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'InriaSans')),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 137, 136, 136),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            fileName,
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;

  const _IconButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: SizedBox(
          width: 25,
          height: 25,
          child: Icon(
            icon,
            color: Colors.white,
            size: 33,
          ),
        ),
      ),
    );
  }
}

class _LikeButton extends StatelessWidget {
  final int postId; 

  const _LikeButton({required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvestmentDetailsBloc, InvestmentDetailsState>(
      builder: (context, state) {
        final isLiked = state.isLiked;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              context.read<InvestmentDetailsBloc>().add(
                ToggleLikeInvestmentEvent(
                  postId: postId,  
                  isLiked: isLiked,
                ),
              );
            },
            child: SizedBox(
              width: 25,
              height: 25,
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : Colors.white,
                size: 33,
              ),
            ),
          ),
        );
      },
    );
  }
}
