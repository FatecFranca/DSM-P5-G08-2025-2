import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final String active;

  const BottomNav({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: active == "profile" ? 2 : 0,
      onTap: (i) {
        // implementação depende das rotas usadas
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Explorar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}
