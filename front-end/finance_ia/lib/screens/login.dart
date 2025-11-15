import 'package:flutter/material.dart';
import '../components/auth_input.dart';
import '../components/logo_header.dart';
import '../components/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  void handleLogin() {
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, preencha todos os campos.")),
      );
      return;
    }

    // Aqui você pode implementar autenticação real ou salvar no SharedPreferences
    debugPrint("Login com: $email | $senha");

    // Navegar para o dashboard
    Navigator.pushNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFE6EEF1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // 🔙 Cabeçalho com botão voltar
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        tooltip: 'Voltar',
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // LOGO + TÍTULO
                  const LogoHeader(),

                  const SizedBox(height: 30),

                  // CARD DO FORMULÁRIO
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Bem-vindo",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Entre para começar a investir com inteligência",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 24),

                          // EMAIL
                          AuthInput(
                            controller: emailController,
                            label: "Email",
                            hint: "seu@email.com",
                          ),
                          const SizedBox(height: 16),

                          // SENHA
                          AuthInput(
                            controller: senhaController,
                            label: "Senha",
                            hint: "Digite sua senha",
                            obscure: true,
                          ),
                          const SizedBox(height: 28),

                          // BOTÃO ENTRAR
                          PrimaryButton(
                            label: "Entrar",
                            onPressed: handleLogin,
                          ),

                          const SizedBox(height: 24),

                          Text(
                            "Ao entrar, você concorda com nossos termos de uso e política de privacidade",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
