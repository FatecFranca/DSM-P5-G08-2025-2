import 'package:flutter/material.dart';

class ItemEtapa extends StatelessWidget {
  final String etapa;
  final String titulo;
  final String descricao;

  const ItemEtapa({
    super.key,
    required this.etapa,
    required this.titulo,
    required this.descricao,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF064C68);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔵 Círculo numerado da etapa
          CircleAvatar(
            radius: 20,
            backgroundColor: primaryColor,
            child: Text(
              etapa,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // 📝 Texto da etapa
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  descricao,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
