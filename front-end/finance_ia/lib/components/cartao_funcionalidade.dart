import 'package:flutter/material.dart';
import '../models/funcionalidade_modelo.dart';

class CartaoFuncionalidade extends StatelessWidget {
  final FuncionalidadeModelo funcionalidade;
  final bool isCompacto;

  const CartaoFuncionalidade({
    super.key,
    required this.funcionalidade,
    this.isCompacto = false,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF064C68);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: primaryColor.withValues(alpha:0.2),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment:
              isCompacto ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Icon(
              funcionalidade.icone,
              size: isCompacto ? 36 : 48,
              color: primaryColor, // ✅ Usa a cor #064C68
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    funcionalidade.titulo,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primaryColor, // ✅ Aplica a cor ao título
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    funcionalidade.descricao,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
