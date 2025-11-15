import 'package:flutter/material.dart';

class DetailBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const DetailBadge({
    super.key,
    required this.label,
    required this.color,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }
}
