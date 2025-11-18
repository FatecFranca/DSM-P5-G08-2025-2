import 'package:flutter/material.dart';
import 'screens/pagina_inicial.dart';
import 'screens/login.dart';
import 'screens/cadastro_usuario.dart';
import 'screens/questionario.dart';
import 'screens/review.dart';
import 'screens/dashboard.dart';
import 'screens/explorar.dart';
import 'screens/resultados.dart';
import 'screens/perfil.dart';
import 'screens/detalhes.dart';
import 'theme/app_theme.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool modoEscuro = false;
  String? initialRoute;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    final isAuthenticated = await AuthService.isAuthenticated();
    setState(() {
      initialRoute = isAuthenticated ? '/dashboard' : '/';
    });
  }

  void alternarTema() {
    setState(() {
      modoEscuro = !modoEscuro;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinanceIA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: modoEscuro ? ThemeMode.dark : ThemeMode.light,

      //
      // ✅ GERENCIAMENTO DE ROTAS COM ARGUMENTOS
      //
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => PaginaInicial(alternarTema: alternarTema),
            );
          case '/login':
            return MaterialPageRoute(builder: (context) => const LoginScreen());
          case '/cadastroUsuario':
            return MaterialPageRoute(
              builder: (context) => const CadastroScreen(),
            );
          case '/questionario':
            return MaterialPageRoute(
              builder: (context) => const QuestionnaireScreen(),
            );
          case '/review':
            return MaterialPageRoute(
              builder: (context) => const ReviewScreen(),
            );
          case '/resultados':
            return MaterialPageRoute(
              builder: (context) => const ResultsScreen(),
            );
          case '/dashboard':
            return MaterialPageRoute(
              builder: (context) => const DashboardScreen(),
            );
          case '/explorar':
            return MaterialPageRoute(
              builder: (context) => const ExploreScreen(),
            );
          case '/perfil':
            return MaterialPageRoute(
              builder: (context) => const ProfileScreen(),
            );
          case '/detalhes':
            final ticker =
                settings.arguments as String; // 👈 recebe o argumento
            return MaterialPageRoute(
              builder: (context) => DetailScreen(ticker: ticker),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => PaginaInicial(alternarTema: alternarTema),
            );
        }
      },

      initialRoute: initialRoute ?? '/',
    );
  }
}
