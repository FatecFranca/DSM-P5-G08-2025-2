import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/combinar_resultados.dart';
import '../components/resultado_card.dart';
import '../components/bottom_nav1.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  MatchResults? results;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadResults();
  }

  Future<void> loadResults() async {
    final prefs = await SharedPreferences.getInstance();

    final user = prefs.getString("financeIA_user");

    if (!mounted) return;

    if (user == null) {
      Navigator.pushReplacementNamed(context, "/login");
      return;
    }

    final res = prefs.getString("financeIA_results");

    if (res != null) {
      setState(() {
        results = MatchResults.fromMap(jsonDecode(res));
        loading = false;
      });
    } else {
      final profile = prefs.getString("financeIA_profile");
      if (profile == null) {
        Navigator.pushReplacementNamed(context, "/questionnaire");
      } else {
        Navigator.pushReplacementNamed(context, "/review");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading || results == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      bottomNavigationBar: const BottomNav(active: "results"),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // HEADER
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pushReplacementNamed(context, "/dashboard"),
                  ),
                  const Spacer(),
                  const Text("Recomendações",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 14),

              // PERFIL CARD
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(Icons.trending_up, color: Colors.blue),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Seu perfil",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                          Text(
                            results!.perfilTipo,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  children: [
                    Text(
                      "Top ${results!.items.length} ações para você",
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 8),

                    ...results!.items.asMap().entries.map(
                      (e) => ResultCard(
                        item: e.value,
                        index: e.key,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/detail",
                            arguments: e.value.ticker,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // DISCLAIMER
                    Card(
                      color: Colors.grey.shade200,
                      child: const Padding(
                        padding: EdgeInsets.all(14),
                        child: Text(
                          "Importante: As probabilidades indicam compatibilidade com seu perfil, não garantia de retorno. Rentabilidade passada não garante resultados futuros.",
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
}
