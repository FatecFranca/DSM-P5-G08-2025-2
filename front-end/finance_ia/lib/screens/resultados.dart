import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recommendation.dart';
import '../components/bottom_nav.dart';
import '../services/auth_service.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  List<Recommendation> recommendations = [];
  Map<String, dynamic> profileMatch = {};
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadResults();
  }

  Future<void> loadResults() async {
    try {
      // Check if user is authenticated
      final isAuthenticated = await AuthService.isAuthenticated();
      if (!isAuthenticated) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, "/login");
        }
        return;
      }

      // Get results from SharedPreferences (saved by review screen)
      final prefs = await SharedPreferences.getInstance();
      final resultsJson = prefs.getString("financeIA_results");

      if (resultsJson == null) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, "/questionario");
        }
        return;
      }

      final data = json.decode(resultsJson) as Map<String, dynamic>;

      if (mounted) {
        setState(() {
          recommendations = (data['items'] as List)
              .map((item) => Recommendation.fromMap(item))
              .toList();
          profileMatch = {
            'perfil_id': data['perfil_id'],
            'perfil_tipo': data['perfil_tipo'],
          };
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Erro de conexão: $e';
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Erro ao carregar recomendações',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    loading = true;
                    error = null;
                  });
                  loadResults();
                },
                child: Text('Tentar Novamente'),
              ),
            ],
          ),
        ),
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
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, "/dashboard"),
                  ),
                  const Spacer(),
                  const Text(
                    "Recomendações",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
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
                        child: const Icon(
                          Icons.trending_up,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Seu perfil",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            profileMatch['tipo'] ?? 'Investidor',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  children: [
                    Text(
                      "Top ${recommendations.length} recomendações para você",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),

                    ...recommendations.asMap().entries.map(
                      (e) => Card(
                        margin: EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green.shade100,
                            child: Text(
                              '${e.key + 1}',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            e.value.ticker,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.value.name),
                              Text(
                                '${e.value.setor} • ${e.value.pais}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.trending_up, color: Colors.green),
                              Text(
                                '${(e.value.score * 100).toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              "/detalhes",
                              arguments: e.value.ticker,
                            );
                          },
                        ),
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
                            fontSize: 12,
                            color: Colors.grey,
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
}
