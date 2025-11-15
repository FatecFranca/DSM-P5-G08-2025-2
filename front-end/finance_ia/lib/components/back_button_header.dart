import 'package:flutter/material.dart';

class BackButtonHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const BackButtonHeader({
    super.key,
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back),
        ),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(width: 40),
      ],
    );
  }
}
