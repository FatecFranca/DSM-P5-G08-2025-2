import 'package:flutter/material.dart';

class SectorBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor; // Nova propriedade para cor de fundo
  final Color textColor; // Nova propriedade para cor do texto

  const SectorBadge({
    super.key,
    required this.text,
    this.backgroundColor = Colors.grey, // Valor padrão
    this.textColor = Colors.black, // Valor padrão
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(text, style: TextStyle(fontSize: 13, color: textColor)),
    );
  }
}
