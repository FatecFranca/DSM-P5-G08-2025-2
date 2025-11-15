import 'package:flutter/material.dart';
import 'screens/pagina_inicial.dart';
import 'screens/login.dart';
import 'screens/cadastroUsuario.dart';
import 'screens/questionario.dart';
import 'screens/dashboard.dart';
import 'screens/review.dart';
import 'screens/resultados.dart';
import 'screens/perfil.dart';
import 'screens/detalhes.dart';
import 'theme/app_theme.dart';

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

      // ROTAS 
      routes: {
        '/': (context) => PaginaInicial(alternarTema: alternarTema),
        '/login': (context) => const LoginScreen(),
        '/cadastroUsuario': (context) => const CadastroScreen(),
        '/questionario': (context) => const QuestionnaireScreen(),
        '/review': (context) => const ReviewScreen(),
        '/resultados': (context) => const ResultsScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/perfil': (context) => const ProfileScreen(),
        '/detalhes': (context) => const DetailScreen(),

      },

      initialRoute: '/',
    );
  }
}
