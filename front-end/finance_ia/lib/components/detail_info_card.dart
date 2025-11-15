import 'package:flutter/material.dart';
import 'detail_badge.dart';

class DetailInfoCard extends StatelessWidget {
  final String title;
  final String description;
  final String badgeLabel;
  final Color badgeColor;
  final Color badgeTextColor;

  const DetailInfoCard({
    super.key,
    required this.title,
    required this.description,
    required this.badgeLabel,
    required this.badgeColor,
    this.badgeTextColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                DetailBadge(
                  label: badgeLabel,
                  color: badgeColor,
                  textColor: badgeTextColor,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            )
          ],
        ),
      ),
    );
  }
}
