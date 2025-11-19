import 'package:flutter/material.dart';
import '../components/cartao_funcionalidade.dart';
import '../components/item_etapa.dart';
import '../components/botao_personalizado.dart';
import '../models/funcionalidade_modelo.dart';
import '../theme/app_theme.dart';

class PaginaInicial extends StatelessWidget {
  final VoidCallback alternarTema;

  const PaginaInicial({super.key, required this.alternarTema});

  @override
  Widget build(BuildContext context) {
    final funcionalidades = [
      FuncionalidadeModelo(
        titulo: 'Análise Rápida',
        descricao:
            'Responda um questionário simples e receba recomendações personalizadas em minutos.',
        icone: Icons.flash_on,
      ),
      FuncionalidadeModelo(
        titulo: 'Seguro e Confiável',
        descricao:
            'Suas informações são protegidas e as recomendações baseadas em dados reais do mercado.',
        icone: Icons.security,
      ),
      FuncionalidadeModelo(
        titulo: 'Perfil Personalizado',
        descricao:
            'Investimentos adequados ao seu perfil de risco e objetivos financeiros.',
        icone: Icons.bar_chart,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'InvestIA',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.corPrincipal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: alternarTema,
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Alternar tema',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Seção principal (Hero)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              child: Column(
                children: [
                  const Text(
                    'Seu Assistente Financeiro Inteligente',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Descubra as melhores opções de investimento personalizadas para o seu perfil. Deixe a inteligência artificial trabalhar por você.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      BotaoPersonalizado(
                        texto: 'Começar Agora',
                        aoPressionar: () {
                          Navigator.pushNamed(context, '/cadastro');
                        },
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          side: const BorderSide(
                            color: AppTheme.corPrincipal,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Já tenho conta',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.corPrincipal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: funcionalidades.map((f) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final largura = constraints.maxWidth;
                        return CartaoFuncionalidade(
                          funcionalidade: f,
                          isCompacto: largura < 500,
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            // Seção "Como Funciona"
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'Como Funciona',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24),
                  ItemEtapa(
                    etapa: '1',
                    titulo: 'Crie sua conta',
                    descricao:
                        'Cadastre-se gratuitamente em menos de 1 minuto.',
                  ),
                  ItemEtapa(
                    etapa: '2',
                    titulo: 'Responda o questionário',
                    descricao:
                        'Perguntas simples sobre seus objetivos e perfil de investidor.',
                  ),
                  ItemEtapa(
                    etapa: '3',
                    titulo: 'Receba recomendações',
                    descricao:
                        'A IA analisa seu perfil e sugere os melhores investimentos.',
                  ),
                ],
              ),
            ),

            // Seção CTA (chamada para ação)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.corPrincipal.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.corPrincipal.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Pronto para transformar seus investimentos?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Comece agora e descubra as melhores oportunidades do mercado.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 24),
                  BotaoPersonalizado(
                    texto: 'Criar Conta Gratuita',
                    aoPressionar: () {
                      Navigator.pushNamed(context, '/cadastro');
                    },
                  ),
                ],
              ),
            ),

            // Rodapé
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                '© 2025 InvestIA. Seu assistente financeiro inteligente.',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
