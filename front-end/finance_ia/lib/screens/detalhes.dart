import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/trend_model.dart';
import '../components/detail_info_card.dart';
import '../components/back_button_header.dart';


class DetailScreen extends StatefulWidget {
  final String ticker;

  const DetailScreen({super.key, required this.ticker});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool loading = true;
  String? error;
  TrendModel? data;

  @override
  void initState() {
    super.initState();
    fetchTrends();
  }

  Future<void> fetchTrends() async {
    try {
      final url = Uri.parse("http://localhost:8000/trends?ticker=${widget.ticker}");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          data = TrendModel.fromJson(result);
        });
      } else {
        setState(() => error = "Erro ao buscar dados (${response.statusCode})");
      }
    } catch (e) {
      setState(() => error = "Erro de conexão com o servidor");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null || data == null) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(error ?? "Dados não encontrados",
                  style: const TextStyle(fontSize: 16, color: Colors.redAccent)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Voltar"),
              )
            ],
          ),
        ),
      );
    }

    final trend = data!;
    final rotulos = trend.rotulos;
    final janela = trend.janelaReferencia;

    Color getVolColor(String v) {
      switch (v) {
        case "baixa":
          return Colors.green.shade400;
        case "media":
          return Colors.orange.shade400;
        case "alta":
          return Colors.red.shade400;
        default:
          return Colors.grey;
      }
    }

    Color getLiqColor(String v) {
      switch (v) {
        case "baixa":
          return Colors.grey.shade300;
        case "media":
          return Colors.orange.shade400;
        case "alta":
          return Colors.green.shade400;
        default:
          return Colors.grey;
      }
    }

    IconData getTrendIcon(String t) {
      switch (t) {
        case "alta":
          return Icons.trending_up;
        case "baixa":
          return Icons.trending_down;
        default:
          return Icons.timeline;
      }
    }

    String getTrendLabel(String t) {
      switch (t) {
        case "alta":
          return "Alta";
        case "baixa":
          return "Baixa";
        default:
          return "Neutra";
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            BackButtonHeader(
              title: "Detalhes",
              onBack: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20),

            // HEADER TICKER
            Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      trend.ticker,
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Análise de tendências e características",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tendência recente
            Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Tendência recente",
                        style: TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(getTrendIcon(rotulos["tendencia_recente"]!),
                            color: getVolColor(rotulos["tendencia_recente"]!)),
                        const SizedBox(width: 6),
                        Text(
                          getTrendLabel(rotulos["tendencia_recente"]!),
                          style: TextStyle(
                              color: getVolColor(rotulos["tendencia_recente"]!),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Baseado nos últimos ${janela["ret_1m_dias"]} dias de negociação",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Volatilidade
            DetailInfoCard(
              title: "Volatilidade",
              description: rotulos["volatilidade"] == "baixa"
                  ? "Oscilações de preço menores e mais previsíveis."
                  : rotulos["volatilidade"] == "media"
                      ? "Oscilações de preço moderadas."
                      : "Oscilações maiores e menos previsíveis.",
              badgeLabel: rotulos["volatilidade"]!.toUpperCase(),
              badgeColor: getVolColor(rotulos["volatilidade"]!),
            ),

            // Liquidez
            DetailInfoCard(
              title: "Liquidez",
              description: rotulos["liquidez"] == "baixa"
                  ? "Menor volume de negociação, pode ser difícil comprar/vender."
                  : rotulos["liquidez"] == "media"
                      ? "Volume de negociação moderado."
                      : "Alto volume de negociação, fácil de comprar e vender.",
              badgeLabel: rotulos["liquidez"]!.toUpperCase(),
              badgeColor: getLiqColor(rotulos["liquidez"]!),
            ),

            // Janela de referência
            Card(
              elevation: 0.5,
              color: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Janela de referência",
                        style:
                            TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text("1 mês",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12)),
                            Text("${janela["ret_1m_dias"]} dias",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 13)),
                          ],
                        ),
                        Column(
                          children: [
                            const Text("3 meses",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12)),
                            Text("${janela["ret_3m_dias"]} dias",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 13)),
                          ],
                        ),
                        Column(
                          children: [
                            const Text("6 meses",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12)),
                            Text("${janela["ret_6m_dias"]} dias",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Disclaimer
            Card(
              color: Colors.grey.shade100,
              child: const Padding(
                padding: EdgeInsets.all(14),
                child: Text(
                  "Aviso: Estas análises são baseadas em dados históricos e não garantem resultados futuros. Faça sua própria pesquisa antes de investir.",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Voltar para resultados"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
