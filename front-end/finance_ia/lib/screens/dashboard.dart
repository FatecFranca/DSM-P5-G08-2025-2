import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario.dart';
import '../components/botao_nav.dart';

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

    final userData = prefs.getString("financeIA_user");
    if (userData == null) {
      Navigator.pushReplacementNamed(context, "/login");
      return;
    }

    setState(() {
      user = User.fromMap(jsonDecode(userData));
    });

    final profile = prefs.getString("financeIA_profile");
    setState(() {
      hasProfile = profile != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final firstName = user!.name.split(" ").first;

    return Scaffold(
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
                        fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Bem-vindo ao seu assistente financeiro",
                    style:
                        TextStyle(fontSize: 14, color: Colors.grey.shade600),
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
                      color: Colors.grey.shade600),
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
                      color: Colors.grey.shade200,
                      child: const Padding(
                        padding: EdgeInsets.all(14),
                        child: Text(
                          "Aviso: Investimentos em ações envolvem riscos. As recomendações são baseadas em análise algorítmica e não garantem retorno. Consulte um profissional certificado.",
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey, height: 1.4),
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
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.track_changes, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Configure seu perfil",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text(
                    "Responda algumas perguntas para receber recomendações personalizadas de investimentos.",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, "/questionnaire"),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Começar agora"),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_right_alt, size: 18),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildRecommendationsCard() {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.green,
              child: const Icon(Icons.auto_awesome, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Ver recomendações",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text(
                    "Veja as ações mais compatíveis com seu perfil de investidor.",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () =>
                        Navigator.pushNamed(context, "/results"),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Ver agora"),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_right_alt, size: 18),
                      ],
                    ),
                  )
                ],
              ),
            )
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                    color: color, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    text,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
