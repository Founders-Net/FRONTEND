import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../partners/bloc/partners_bloc.dart';
import '../partners/bloc/partners_event.dart';
import '../partners/bloc/partners_state.dart';

class AddPartnerButton extends StatelessWidget {
  final int userId;
  final VoidCallback? onSuccess;

  const AddPartnerButton({
    super.key,
    required this.userId,
    this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PartnersBloc, PartnersState>(
      listener: (context, state) {
        if (state.error != null) {
          debugPrint('❌ Partner request error: ${state.error}');
        } else if (state.requestSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Запрос отправлен. Ожидается подтверждение партнёра',
              ),
            ),
          );
          if (onSuccess != null) {
            onSuccess!();
          } else {
            Navigator.pop(context, true);
          }
        }
      },
      builder: (context, state) {
        return Center(
          child: SizedBox(
            width: 300,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ElevatedButton(
                onPressed: () {
                  context.read<PartnersBloc>().add(SendPartnerRequest(userId));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAF925D),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Добавить в партнёры',
                  style: GoogleFonts.inriaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
