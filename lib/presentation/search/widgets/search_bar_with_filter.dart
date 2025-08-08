import 'package:flutter/material.dart';

class SearchBarWithFilter extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onFilterPressed;
  final ValueChanged<String>? onChanged; // ✅ NEW


  const SearchBarWithFilter({
    super.key,
    required this.controller,
    required this.onFilterPressed,
    this.onChanged, // ✅ NEW

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 79, 76, 76),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Color(0xFFE7E2E2)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: onChanged,
                      decoration: const InputDecoration(
                        hintText: 'Поиск',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 236, 229, 229),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white, fontFamily: 'InriaSans',),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.tune,
                color: Color.fromARGB(255, 236, 229, 229)),
            onPressed: onFilterPressed,
          ),
        ],
      ),
    );
  }
}
