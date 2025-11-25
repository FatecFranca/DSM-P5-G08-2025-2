import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNav extends StatelessWidget {
  final String active;

  const BottomNav({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: active == "profile"
          ? 2
          : (active == "explore" || active == "results" ? 1 : 0),
      onTap: (i) async {
        switch (i) {
          case 0:
            Navigator.pushReplacementNamed(context, "/dashboard");
            break;
          case 1:
            // Se já houver perfil configurado, vai direto para resultados
            final prefs = await SharedPreferences.getInstance();
            final profile = prefs.getString('investIA_profile');
            if (profile != null && profile.isNotEmpty) {
              // Se também já existirem resultados salvos, usa tela de resultados
              final results = prefs.getString('investIA_results');
              if (results != null && results.isNotEmpty) {
                Navigator.pushReplacementNamed(context, "/resultados");
                break;
              }
            }
            // Caso contrário, permanece fluxo padrão de explorar
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
