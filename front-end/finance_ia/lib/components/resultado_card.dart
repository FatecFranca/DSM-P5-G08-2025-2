import 'package:flutter/material.dart';
import '../models/match_item.dart';

class ResultCard extends StatelessWidget {
  final MatchItem item;
  final int index;
  final VoidCallback onTap;

  const ResultCard({
    super.key,
    required this.item,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final NumberFormat = (double n) => (n * 100).toStringAsFixed(1);

    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        child: Text("${index + 1}"),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.ticker,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(item.pais,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600)),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${(item.probMatch * 100).toStringAsFixed(0)}%",
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      const Text(
                        "compatibilidade",
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 8),
              Divider(),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _metric("Ret. 3m", NumberFormat(item.ret3m),
                      item.ret3m >= 0 ? Colors.green : Colors.red),
                  _metric("Ret. 6m", NumberFormat(item.ret6m),
                      item.ret6m >= 0 ? Colors.green : Colors.red),
                  _metric("Volatilidade",
                      NumberFormat(item.vol63), Colors.black),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metric(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 11, color: Colors.grey)),
        Text(
          "$value%",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
