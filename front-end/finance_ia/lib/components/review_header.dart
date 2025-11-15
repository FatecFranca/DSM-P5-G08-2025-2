import 'package:flutter/material.dart';

class ReviewHeader extends StatelessWidget {
  final VoidCallback onBack;

  const ReviewHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back),
        ),
        const Spacer(),
        const Text(
          "Revisar respostas",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        const SizedBox(width: 48),
      ],
    );
  }
}
