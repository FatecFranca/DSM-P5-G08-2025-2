import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/questionario_dados.dart';
import '../components/review_card.dart';
import '../components/review_header.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_config.dart';
import '../services/token_service.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  QuestionnaireData? data;
  bool loading = false;
  String error = "";

  static const labels = {
    "objetivo": {
      "crescer aos poucos": "Crescer aos poucos",
      "equilibrio": "Equilíbrio",
      "crescer mais rapido": "Crescer mais rápido",
    },
    "horizonte": {
      "curto": "Curto prazo (até 2 anos)",
      "medio": "Médio prazo (2-5 anos)",
      "longo": "Longo prazo (5+ anos)",
    },
    "conforto": {
      "baixo": "Baixo conforto",
      "medio": "Conforto médio",
      "alto": "Alto conforto",
    },
    "pais": {"any": "Qualquer país", "BR": "Brasil", "US": "Estados Unidos"},
  };

  @override
  void initState() {
    super.initState();
    loadStoredData();
  }

  Future<void> loadStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString("investIA_profile");

    if (!mounted) return;

    if (jsonStr == null) {
      Navigator.pushReplacementNamed(context, "/questionario");
      return;
    }

    setState(() {
      data = QuestionnaireData.fromMap(jsonDecode(jsonStr));
    });
  }

  Future<void> submit() async {
    if (data == null) return;

    setState(() {
      loading = true;
      error = "";
    });

    try {
      final token = await TokenService.getToken();
      if (token == null) {
        setState(() {
          error = "Token de autenticação não encontrado. Faça login novamente.";
          loading = false;
        });
        return;
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/match'),
        headers: ApiConfig.authHeaders(token),
        body: jsonEncode({"top_n": 10}),
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("investIA_results", response.body);

        if (!mounted) return;

        Navigator.pushNamedAndRemoveUntil(
          context,
          "/resultados",
          (route) => false,
        );
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Erro ao gerar recomendações');
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ReviewHeader(
                onBack: () {
                  Navigator.pushReplacementNamed(context, "/questionario");
                },
              ),

              const SizedBox(height: 20),

              ReviewCard(
                label: "Objetivo principal",
                value: labels["objetivo"]![data!.objetivo] ?? "",
              ),

              ReviewCard(
                label: "Horizonte de investimento",
                value: labels["horizonte"]![data!.horizonte] ?? "",
              ),

              ReviewCard(
                label: "Conforto com oscilações",
                value: labels["conforto"]![data!.confortoOscilacao] ?? "",
              ),

              ReviewCard(
                label: "Aporte mensal",
                value: data!.aporteMensal > 0
                    ? "R\$ ${data!.aporteMensal.toStringAsFixed(2)}"
                    : "Não definido",
              ),

              ReviewCard(
                label: "Preferência de país",
                value: labels["pais"]![data!.pais] ?? "",
              ),

              ReviewCard(
                label: "Setores de interesse",
                value: data!.setores.isEmpty
                    ? "Todos os setores"
                    : data!.setores.join(", "),
              ),

              const SizedBox(height: 20),

              Card(
                color: Theme.of(context).colorScheme.surfaceContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Ao continuar, você concorda que as recomendações são geradas por algoritmo e não constituem aconselhamento financeiro.",
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              if (error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(error, style: const TextStyle(color: Colors.red)),
                ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: loading ? null : submit,
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Gerar recomendações"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
