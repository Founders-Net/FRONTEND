import 'package:flutter/material.dart';

class AdditionalInvestmentTextField extends StatefulWidget {
  const AdditionalInvestmentTextField({super.key});

  @override
  State<AdditionalInvestmentTextField> createState() => _AdditionalInvestmentTextFieldState();
}

class _AdditionalInvestmentTextFieldState extends State<AdditionalInvestmentTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Дополнительно',
            style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'InriaSans'),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _controller,
            maxLines: 4,
            style: const TextStyle(color: Colors.white, fontFamily: 'InriaSans'),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade900,
              hintText: 'Необязательное поле',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontFamily: 'InriaSans',
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
