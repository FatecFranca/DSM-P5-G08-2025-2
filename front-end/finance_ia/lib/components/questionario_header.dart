import 'package:flutter/material.dart';

class QuestionHeader extends StatelessWidget {
  final VoidCallback onBack;
  final int step;
  final int totalSteps;

  const QuestionHeader({
    super.key,
    required this.onBack,
    required this.step,
    required this.totalSteps,
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
        Text(
          "Pergunta $step de $totalSteps",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(width: 40),
      ],
    );
  }
}
