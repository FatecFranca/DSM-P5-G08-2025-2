import 'package:flutter/material.dart';

class BotaoPersonalizado extends StatelessWidget {
  final String texto;
  final VoidCallback aoPressionar;

  const BotaoPersonalizado({
    super.key,
    required this.texto,
    required this.aoPressionar,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF064C68);

    return ElevatedButton(
      onPressed: aoPressionar,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor, // ✅ Cor principal (#064C68)
        foregroundColor: Colors.white, // ✅ Texto branco
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4, // Leve sombra
        shadowColor: primaryColor.withValues(alpha:0.4),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
