import 'package:flutter/material.dart';

class LogoHeader extends StatelessWidget {
  const LogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFF064C68),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.trending_up,
            size: 28,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          "FinanceIA",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
