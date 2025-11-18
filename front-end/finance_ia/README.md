# Front-end — InvestIA

Aplicativo Flutter multiplataforma para interação com o sistema de recomendação financeira.
## 📦 Estrutura do Projeto
- `lib/` — Código principal do app
	- `screens/` — Telas do aplicativo (ex: página inicial, perfil, recomendações, histórico)
	- `components/` — Widgets reutilizáveis (botões, cards, etc.)
	- `models/` — Modelos de dados (ex: usuário, recomendação)
	- `services/` — Serviços de integração (ex: chamadas à API backend)
	- `theme/` — Definições de tema e estilos
- `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/` — Suporte multiplataforma
- `pubspec.yaml` — Dependências do projeto
## 🚀 Como Executar
1. Instale o Flutter: https://docs.flutter.dev/get-started/install
2. Instale as dependências:
	```bash
	flutter pub get
	```
3. Execute o app:
	```bash
	flutter run
	```

## 🗺️ Navegação
O app utiliza navegação por rotas nomeadas, facilitando a transição entre telas como:
- Página Inicial
- Tela de Perfil do Usuário
- Tela de Recomendações
- Tela de Histórico

## 🔗 Integração com Backend
O front-end se comunica com a API Python via HTTP (REST), utilizando o pacote `http` do Flutter. As principais integrações são:
- Autenticação de usuário (login, registro)
- Envio e consulta de perfil
- Recebimento de recomendações
- Consulta de histórico

## 🖼️ Principais Telas
- **Página Inicial:** Apresenta resumo do perfil e atalhos para recomendações
- **Perfil:** Formulário para cadastro/edição do perfil financeiro
- **Recomendações:** Lista ranqueada de ações recomendadas
- **Histórico:** Exibe recomendações anteriores e detalhes

## 🛠️ Dependências Principais
- `flutter` — Framework principal
- `http` — Requisições REST
- `provider` — Gerenciamento de estado
- `shared_preferences` — Armazenamento local simples

## 👩‍💻 Desenvolvimento
- Para adicionar novas telas, crie arquivos em `lib/screens/`
- Para novos widgets, utilize `lib/components/`
- Serviços de integração devem ficar em `lib/services/`
- Modelos de dados em `lib/models/`

## 📝 Testes
Testes de widgets podem ser adicionados em `test/widget_test.dart`.

## ⚠️ Observações
- Certifique-se de que o backend esteja rodando e acessível para autenticação e recomendações.
- As variáveis de ambiente e endpoints da API podem ser configurados em arquivos de serviço.

## 📚 Documentação
Consulte o README principal para visão geral do projeto e o README do backend para detalhes da API.

Para mais informações sobre Flutter, acesse a [documentação oficial](https://docs.flutter.dev/).

# Front-end — InvestIA

Aplicativo Flutter multiplataforma para interação com o sistema de recomendação financeira.

## 📦 Estrutura do Projeto
- `lib/` — Código principal do app
  - `screens/` — Telas do aplicativo (ex: página inicial, perfil, recomendações, histórico)
  - `components/` — Widgets reutilizáveis (botões, cards, etc.)
  - `models/` — Modelos de dados (ex: usuário, recomendação)
  - `services/` — Serviços de integração (ex: chamadas à API backend)
  - `theme/` — Definições de tema e estilos
- `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/` — Suporte multiplataforma
- `pubspec.yaml` — Dependências do projeto

## 🚀 Como Executar
1. Instale o Flutter: https://docs.flutter.dev/get-started/install
2. Instale as dependências:
	```bash
	flutter pub get
	```
3. Execute o app:
	```bash
	flutter run
	```

## 🗺️ Navegação
O app utiliza navegação por rotas nomeadas, facilitando a transição entre telas como:
- Página Inicial
- Tela de Perfil do Usuário
- Tela de Recomendações
- Tela de Histórico

## 🔗 Integração com Backend
O front-end se comunica com a API Python via HTTP (REST), utilizando o pacote `http` do Flutter. As principais integrações são:
- Autenticação de usuário (login, registro)
- Envio e consulta de perfil
- Recebimento de recomendações
- Consulta de histórico

## 🖼️ Principais Telas
- **Página Inicial:** Apresenta resumo do perfil e atalhos para recomendações
- **Perfil:** Formulário para cadastro/edição do perfil financeiro
- **Recomendações:** Lista ranqueada de ações recomendadas
- **Histórico:** Exibe recomendações anteriores e detalhes

## 🛠️ Dependências Principais
- `flutter` — Framework principal
- `http` — Requisições REST
- `provider` — Gerenciamento de estado
- `shared_preferences` — Armazenamento local simples

## 👩‍💻 Desenvolvimento
- Para adicionar novas telas, crie arquivos em `lib/screens/`
- Para novos widgets, utilize `lib/components/`
- Serviços de integração devem ficar em `lib/services/`
- Modelos de dados em `lib/models/`

## 📝 Testes
Testes de widgets podem ser adicionados em `test/widget_test.dart`.

## ⚠️ Observações
- Certifique-se de que o backend esteja rodando e acessível para autenticação e recomendações.
- As variáveis de ambiente e endpoints da API podem ser configurados em arquivos de serviço.

## 📚 Documentação
Consulte o README principal para visão geral do projeto e o README do backend para detalhes da API.

Para mais informações sobre Flutter, acesse a [documentação oficial](https://docs.flutter.dev/).