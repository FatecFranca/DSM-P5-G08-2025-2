import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario_padrao.dart';
import '../models/perfil_padrao.dart';
import '../components/info_card.dart';
import '../components/sector_badge.dart';
import '../components/bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? user;
  ProfileModel? profile;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final userData = prefs.getString("financeIA_user");

    if (!mounted) return;
    if (userData == null) {
      Navigator.pushReplacementNamed(context, "/login");
      return;
    }

    user = UserModel.fromJson(jsonDecode(userData));

    final profileData = prefs.getString("financeIA_profile");
    if (profileData != null) {
      profile = ProfileModel.fromJson(jsonDecode(profileData));
    }

    setState(() => loading = false);
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("financeIA_user");
    await prefs.remove("financeIA_profile");

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, "/login");
  }

  String getLabel(String key, String value) {
    const labels = {
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
      "conforto_oscilacao": {
        "baixo": "Baixo conforto",
        "medio": "Conforto médio",
        "alto": "Alto conforto",
      },
      "pais": {"any": "Qualquer país", "BR": "Brasil", "US": "Estados Unidos"},
    };

    return labels[key]?[value] ?? value;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      bottomNavigationBar: const BottomNav(active: "profile"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Perfil",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // USER CARD
            Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue.shade50,
                      child: const Icon(
                        Icons.person,
                        size: 36,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user!.nome,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user!.email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            profile != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // título
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Perfil de Investimento",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, "/questionnaire"),
                            child: const Text("Editar"),
                          ),
                        ],
                      ),

                      Card(
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              InfoCard(
                                label: "Objetivo principal",
                                value: getLabel("objetivo", profile!.objetivo),
                              ),
                              InfoCard(
                                label: "Horizonte de investimento",
                                value: getLabel(
                                  "horizonte",
                                  profile!.horizonte,
                                ),
                              ),
                              InfoCard(
                                label: "Conforto com oscilações",
                                value: getLabel(
                                  "conforto_oscilacao",
                                  profile!.confortoOscilacao,
                                ),
                              ),
                              InfoCard(
                                label: "Aporte mensal",
                                value: profile!.aporteMensal > 0
                                    ? "R\$ ${profile!.aporteMensal.toStringAsFixed(2)}"
                                    : "Não definido",
                              ),
                              InfoCard(
                                label: "Preferência de país",
                                value: getLabel("pais", profile!.pais),
                              ),

                              if (profile!.setores.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 6),
                                    const Text(
                                      "Setores de interesse",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: profile!.setores
                                          .map((s) => SectorBadge(text: s))
                                          .toList(),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Card(
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.trending_up,
                              size: 46,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Perfil não configurado",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Complete o questionário para recomendações personalizadas.",
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 14),
                            ElevatedButton(
                              onPressed: () => Navigator.pushNamed(
                                context,
                                "/questionnaire",
                              ),
                              child: const Text("Configurar perfil"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: const Text("Sair da conta"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
