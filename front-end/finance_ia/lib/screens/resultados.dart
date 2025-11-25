import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/recommendation.dart';
import '../components/bottom_nav.dart';
import '../services/auth_service.dart';
import '../services/token_service.dart';
import '../services/api_config.dart';

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
  bool refreshing = false;

  @override
  void initState() {
    super.initState();
    loadResults();
  }

  Future<void> loadResults() async {
    try {
      final isAuthenticated = await AuthService.isAuthenticated();
      if (!isAuthenticated) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, "/login");
        }
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString("investIA_profile");
      if (profileJson == null) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, "/dashboard");
        }
        return;
      }

      final resultsJson = prefs.getString("investIA_results");

      if (resultsJson == null) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, "/dashboard");
        }
        return;
      }

      final data = json.decode(resultsJson) as Map<String, dynamic>;

      if (mounted) {
        setState(() {
          recommendations = (data['items'] as List)
              .map((item) => Recommendation.fromMap(item))
              .toList();

          if (data['perfil'] is String) {
            profileMatch = {'perfil_tipo': data['perfil']};
          } else if (data['perfil'] is Map) {
            profileMatch = data['perfil'] as Map<String, dynamic>;
          } else {
            profileMatch = {
              'perfil_id': data['perfil_id'],
              'perfil_tipo': data['perfil_tipo'],
            };
          }

          loading = false;
          refreshing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Erro ao carregar resultados: $e';
          loading = false;
          refreshing = false;
        });
      }
    }
  }

  Future<void> _refreshRecommendations() async {
    setState(() {
      refreshing = true;
      error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString('investIA_profile');
      if (profileJson == null) {
        setState(() {
          error = 'Perfil não configurado';
          refreshing = false;
        });
        return;
      }

      final token = await TokenService.getToken();
      if (token == null) {
        setState(() {
          error = 'Sessão expirada';
          refreshing = false;
        });
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final payload = {'top_n': 10};
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}match'),
        headers: ApiConfig.authHeaders(token),
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        await prefs.setString('investIA_results', response.body);
        await loadResults();
      } else {
        setState(() {
          error = 'Erro ao atualizar (${response.statusCode})';
          refreshing = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Erro: $e';
        refreshing = false;
      });
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, "/dashboard");
            }
          },
        ),
        centerTitle: true,
        title: const Text(
          'Recomendações',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar recomendações',
            onPressed: refreshing ? null : _refreshRecommendations,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () async {
              await AuthService.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(active: "results"),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // PERFIL CARD
              Card(
                color: Theme.of(context).colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.15),
                        child: Icon(
                          Icons.trending_up,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Seu perfil",
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontSize: 12,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.7),
                                ),
                          ),
                          Text(
                            profileMatch['perfil_tipo'] ?? 'Investidor',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                          ),
                          if (refreshing) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const SizedBox(
                                  height: 14,
                                  width: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Atualizando...',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        fontSize: 11,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.6),
                                      ),
                                ),
                              ],
                            ),
                          ],
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
                                '${(e.value.probMatch * 100).toStringAsFixed(1)}%',
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
