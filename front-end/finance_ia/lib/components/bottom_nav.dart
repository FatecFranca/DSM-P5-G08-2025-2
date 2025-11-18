import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final String active;

  const BottomNav({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: active == "profile" ? 2 : (active == "explore" ? 1 : 0),
      onTap: (i) {
        switch (i) {
          case 0:
            Navigator.pushReplacementNamed(context, "/dashboard");
            break;
          case 1:
            Navigator.pushReplacementNamed(context, "/explorar");
            break;
          case 2:
            Navigator.pushReplacementNamed(context, "/perfil");
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explorar'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }
}
