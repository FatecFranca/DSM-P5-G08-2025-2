import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final String active;

  const BottomNav({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: active == "results" ? 1 : 0,
      onTap: (i) {},
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up),
          label: "Resultados",
        ),
      ],
    );
  }
}
