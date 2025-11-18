import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';
import '../components/bottom_nav.dart';
import '../services/auth_service.dart';
import '../services/api_config.dart';
import '../services/profile_service.dart';
import '../services/token_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  User? user;
  bool hasProfile = false;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString("investIA_user");

    if (!mounted) return;

    if (userData == null) {
      Navigator.pushReplacementNamed(context, "/login");
      return;
    }

    try {
      final userMap = jsonDecode(userData);
      setState(() {
        user = User(
          email: userMap['email'] ?? '',
          name: userMap['name'] ?? 'Usuário',
        );
      });

      // Check for profile locally first
      final localProfile = prefs.getString("investIA_profile");

      if (localProfile != null) {
        setState(() {
          hasProfile = true;
        });
      } else {
        // If no local profile, try to load from backend
        await _loadProfileFromBackend();
      }
    } catch (e) {
      // Se houver erro ao carregar dados, redirecionar para login
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  Future<void> _loadProfileFromBackend() async {
    try {
      final result = await ProfileService.getProfile();

      if (result['success']) {
        // Save profile locally for future use
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'investIA_profile',
          json.encode(result['profile']),
        );

        setState(() {
          hasProfile = true;
        });
      } else {
        // No profile found in backend
        setState(() {
          hasProfile = false;
        });
      }
    } catch (e) {
      // Error loading profile, assume no profile
      setState(() {
        hasProfile = false;
      });
    }
  }

  Future<void> _generateRecommendations() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if we already have results
      final hasResults = prefs.getString("investIA_results") != null;
      if (hasResults) {
        Navigator.pushNamed(context, "/resultados");
        return;
      }

      // Get profile data
      final profileData = prefs.getString("investIA_profile");
      if (profileData == null) {
        Navigator.pushNamed(context, "/questionario");
        return;
      }

      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Get authentication token
      final token = await TokenService.getToken();
      if (token == null) {
        if (mounted) Navigator.pop(context); // Hide loading
        Navigator.pushReplacementNamed(context, "/login");
        return;
      }

      final payload = {'top_n': 10};

      print('Sending to /match: ${jsonEncode(payload)}');

      // Call match endpoint (uses profile from backend)
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/match'),
        headers: ApiConfig.authHeaders(token),
        body: jsonEncode(payload),
      );

      // Hide loading
      if (mounted) Navigator.pop(context);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Save results and navigate
        await prefs.setString("investIA_results", response.body);
        if (mounted) {
          Navigator.pushNamed(context, "/resultados");
        }
      } else {
        // Show detailed error
        final errorData = json.decode(response.body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Erro ${response.statusCode}: ${errorData['message'] ?? 'Erro desconhecido'}',
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      // Hide loading if still showing
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final firstName = user!.name?.split(" ").first ?? "Usuário";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _logout();
            },
            tooltip: 'Sair',
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(active: "home"),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              // HEADER
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Olá, $firstName!",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Bem-vindo ao seu assistente financeiro",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              // QUICK ACTION
              hasProfile ? buildRecommendationsCard() : buildProfileCard(),

              const SizedBox(height: 16),

              // INFO SECTION
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Como funciona",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: ListView(
                  children: [
                    buildStepCard(
                      number: "1",
                      color: Colors.blue,
                      title: "Responda o questionário",
                      text:
                          "6 perguntas rápidas sobre seus objetivos e perfil de investimento",
                    ),
                    buildStepCard(
                      number: "2",
                      color: Colors.green,
                      title: "IA analisa milhares de ações",
                      text:
                          "Nosso algoritmo de machine learning processa seu perfil e encontra as melhores opções",
                    ),
                    buildStepCard(
                      number: "3",
                      color: Colors.orange,
                      title: "Receba recomendações",
                      text:
                          "Veja ações ranqueadas por compatibilidade com análise detalhada de cada uma",
                    ),

                    const SizedBox(height: 20),

                    // DISCLAIMER
                    Card(
                      color: Theme.of(context).colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Text(
                          "Aviso: Investimentos em ações envolvem riscos. As recomendações são baseadas em análise algorítmica e não garantem retorno. Consulte um profissional certificado.",
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontSize: 12,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.7),
                                height: 1.4,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------
  // COMPONENTES
  // -------------------------------

  Widget buildProfileCard() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Card(
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: colorScheme.primary,
              child: Icon(Icons.track_changes, color: colorScheme.onPrimary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Configure seu perfil",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Responda algumas perguntas para receber recomendações personalizadas de investimentos.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, "/questionario"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Começar agora"),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_right_alt, size: 18),
                      ],
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

  Widget buildRecommendationsCard() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Card(
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: colorScheme.secondary,
              child: Icon(Icons.auto_awesome, color: colorScheme.onSecondary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ver recomendações",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Veja as ações mais compatíveis com seu perfil de investidor.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.secondary,
                      foregroundColor: colorScheme.onSecondary,
                    ),
                    onPressed: () async {
                      await _generateRecommendations();
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Ver agora"),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_right_alt, size: 18),
                      ],
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

  Widget buildStepCard({
    required String number,
    required Color color,
    required String title,
    required String text,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withOpacity(0.15),
              child: Text(
                number,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    text,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.8),
                      fontSize: 13,
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
