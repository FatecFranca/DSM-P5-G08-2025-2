import 'package:flutter/material.dart';
import '../models/usuario_padrao.dart';
import '../components/auth_input.dart';
import '../components/error_message.dart';
import '../components/logo_header.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarSenhaController = TextEditingController();

  String erro = '';

  void handleSubmit() {
    setState(() => erro = '');

    final nome = nomeController.text.trim();
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();
    final confirmarSenha = confirmarSenhaController.text.trim();

    if (nome.isEmpty || email.isEmpty || senha.isEmpty || confirmarSenha.isEmpty) {
      setState(() => erro = "Por favor, preencha todos os campos");
      return;
    }

    if (senha != confirmarSenha) {
      setState(() => erro = "As senhas não coincidem");
      return;
    }

    if (senha.length < 6) {
      setState(() => erro = "A senha deve ter pelo menos 6 caracteres");
      return;
    }

    final novoUsuario = UserModel(nome: nome, email: email, senha: senha);
    debugPrint("Usuário cadastrado: ${novoUsuario.toJson()}");

    // Redireciona para questionário
    Navigator.pushNamed(context, '/questionnaire');
  }

  @override
  Widget build(BuildContext context) {
    final corPrimaria = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Criar Conta"),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                const LogoHeader(),
                const SizedBox(height: 20),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Criar Conta",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Preencha os dados abaixo para começar sua jornada financeira",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 20),

                        AuthInput(controller: nomeController, label: "Nome Completo"),
                        const SizedBox(height: 10),
                        AuthInput(controller: emailController, label: "Email"),
                        const SizedBox(height: 10),
                        AuthInput(controller: senhaController, label: "Senha", obscure: true),
                        const SizedBox(height: 10),
                        AuthInput(controller: confirmarSenhaController, label: "Confirmar Senha", obscure: true),

                        ErrorMessage(message: erro),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: handleSubmit,
                            child: const Text("Criar Conta"),
                          ),
                        ),
                        const SizedBox(height: 16),

                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/login'),
                          child: Text(
                            "Já tem uma conta? Faça login",
                            style: TextStyle(color: corPrimaria),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                TextButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/'),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Voltar para o início"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
