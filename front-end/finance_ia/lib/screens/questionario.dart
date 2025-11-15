import 'package:flutter/material.dart';
import '../models/questionario_dados.dart';
import '../components/questionario_header.dart';
import '../components/questionario_card.dart';
import '../components/questionario_opcao.dart';
import '../components/checkbox_opcao.dart';
import '../components/barra_progresso.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  int step = 1;
  final int totalSteps = 6;

  QuestionnaireData data = QuestionnaireData();

  static const setores = [
    "Tecnologia",
    "Financeiro",
    "Energia",
    "Saúde",
    "Consumo",
    "Indústria",
    "Telecomunicações",
    "Materiais",
  ];

  void next() {
    if (step < totalSteps) {
      setState(() => step++);
    } else {
      Navigator.pushNamed(context, "/review");
    }
  }

  void back() {
    if (step > 1) {
      setState(() => step--);
    } else {
      Navigator.pushNamed(context, "/dashboard");
    }
  }

  bool canProceed() {
    switch (step) {
      case 1:
        return data.objetivo.isNotEmpty;
      case 2:
        return data.horizonte.isNotEmpty;
      case 3:
        return data.confortoOscilacao.isNotEmpty;
      case 5:
        return data.pais.isNotEmpty;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = step / totalSteps;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              QuestionHeader(onBack: back, step: step, totalSteps: totalSteps),
              const SizedBox(height: 20),
              ProgressBar(value: progress),
              const SizedBox(height: 20),

              // ---------------------
              // STEP CARDS
              // ---------------------
              if (step == 1)
                QuestionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Qual é o seu objetivo principal?",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      RadioOption(
                        value: "crescer aos poucos",
                        groupValue: data.objetivo,
                        title: "Crescer aos poucos",
                        subtitle: "Crescimento moderado com segurança",
                        onChanged: (v) => setState(() => data.objetivo = v),
                      ),
                      RadioOption(
                        value: "equilibrio",
                        groupValue: data.objetivo,
                        title: "Equilíbrio",
                        subtitle: "Balancear risco e retorno",
                        onChanged: (v) => setState(() => data.objetivo = v),
                      ),
                      RadioOption(
                        value: "crescer mais rapido",
                        groupValue: data.objetivo,
                        title: "Crescer mais rápido",
                        subtitle: "Aceitar risco por maior retorno",
                        onChanged: (v) => setState(() => data.objetivo = v),
                      ),
                    ],
                  ),
                ),

              if (step == 2)
                QuestionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Qual é o horizonte de investimento?",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      RadioOption(
                        value: "curto",
                        groupValue: data.horizonte,
                        title: "Curto prazo",
                        subtitle: "Até 2 anos",
                        onChanged: (v) => setState(() => data.horizonte = v),
                      ),
                      RadioOption(
                        value: "medio",
                        groupValue: data.horizonte,
                        title: "Médio prazo",
                        subtitle: "2 a 5 anos",
                        onChanged: (v) => setState(() => data.horizonte = v),
                      ),
                      RadioOption(
                        value: "longo",
                        groupValue: data.horizonte,
                        title: "Longo prazo",
                        subtitle: "Mais de 5 anos",
                        onChanged: (v) => setState(() => data.horizonte = v),
                      ),
                    ],
                  ),
                ),

              if (step == 3)
                QuestionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Como você lida com oscilações?",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      RadioOption(
                        value: "baixo",
                        groupValue: data.confortoOscilacao,
                        title: "Baixo conforto",
                        subtitle: "Prefiro estabilidade",
                        onChanged: (v) =>
                            setState(() => data.confortoOscilacao = v),
                      ),
                      RadioOption(
                        value: "medio",
                        groupValue: data.confortoOscilacao,
                        title: "Conforto médio",
                        subtitle: "Aceito alguma variação",
                        onChanged: (v) =>
                            setState(() => data.confortoOscilacao = v),
                      ),
                      RadioOption(
                        value: "alto",
                        groupValue: data.confortoOscilacao,
                        title: "Alto conforto",
                        subtitle: "Aceito variações grandes",
                        onChanged: (v) =>
                            setState(() => data.confortoOscilacao = v),
                      ),
                    ],
                  ),
                ),

              if (step == 4)
                QuestionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Aporte mensal",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Valor em R\$",
                        ),
                        onChanged: (v) => setState(() {
                          data.aporteMensal = double.tryParse(v) ?? 0;
                        }),
                      ),
                    ],
                  ),
                ),

              if (step == 5)
                QuestionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Preferência de país",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      RadioOption(
                        value: "any",
                        groupValue: data.pais,
                        title: "Qualquer país",
                        subtitle: "Sem preferência específica",
                        onChanged: (v) => setState(() => data.pais = v),
                      ),
                      RadioOption(
                        value: "BR",
                        groupValue: data.pais,
                        title: "Brasil",
                        subtitle: "Apenas mercado brasileiro",
                        onChanged: (v) => setState(() => data.pais = v),
                      ),
                      RadioOption(
                        value: "US",
                        groupValue: data.pais,
                        title: "Estados Unidos",
                        subtitle: "Apenas ações americanas",
                        onChanged: (v) => setState(() => data.pais = v),
                      ),
                    ],
                  ),
                ),

              if (step == 6)
                QuestionCard(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: setores
                        .map(
                          (s) => CheckboxOption(
                            label: s,
                            checked: data.setores.contains(s),
                            onToggle: () {
                              setState(() {
                                if (data.setores.contains(s)) {
                                  data.setores.remove(s);
                                } else {
                                  data.setores.add(s);
                                }
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: canProceed() ? next : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  step == totalSteps ? "Revisar respostas" : "Continuar",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
