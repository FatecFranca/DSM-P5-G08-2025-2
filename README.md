
# DSM-P5-G08-2025-2 — InvestIA

Projeto completo de recomendação financeira, integrando backend em Python (API REST com machine learning) e front-end Flutter multiplataforma.

## 📦 Estrutura do Projeto
- **backend/** — API REST em Python para análise, recomendação e histórico financeiro
- **front-end/** — Aplicativo Flutter para interação do usuário com o sistema

## 🔗 Integração
O front-end se comunica com o backend via HTTP (REST), realizando autenticação, envio de perfil, consulta de recomendações e histórico.

## 🧠 Backend
API desenvolvida em Python, utilizando Flask, MongoDB Atlas e modelos de machine learning (MLP).

### Principais arquivos e pastas
- `run.py` — Inicializa o servidor da API
- `requirements.txt` — Lista de dependências
- `api/` — Lógica da API, rotas e serviços
- `artifacts/` — Modelos e dados utilizados
- `notebooks/` — Treinamento do modelo e coleta de dados

### Funcionalidades
- Autenticação de usuários (JWT)
- Cadastro e consulta de perfil financeiro
- Geração de recomendações personalizadas
- Histórico de recomendações
- Exportação de dados

### Como executar
1. Acesse a pasta `backend`
2. Instale as dependências:
	```bash
	pip install -r requirements.txt
	```
3. Configure o arquivo `.env` com as variáveis do MongoDB e JWT
4. Execute:
	```bash
	python run.py
	```

## 📱 Front-end
Aplicativo Flutter multiplataforma para interação com o sistema de recomendação financeira.

### Estrutura
- `lib/` — Código principal do app
  - `screens/` — Telas do aplicativo
  - `components/` — Widgets reutilizáveis
  - `models/` — Modelos de dados
  - `services/` — Serviços de integração
  - `theme/` — Estilos e temas
- Suporte para Android, iOS, Web, Linux, macOS, Windows

### Funcionalidades
- Visualização de recomendações
- Cadastro/edição de perfil
- Histórico de ações
- Autenticação de usuário

### Como executar
1. Acesse a pasta `front-end/finance_ia`
2. Instale as dependências:
	```bash
	flutter pub get
	```
3. Execute:
	```bash
	flutter run
	```

## ⚙️ Requisitos
- Python 3.8+ (backend)
- Flutter 3.0+ (front-end)

## 👥 Autores
- [FREDERICO PESSOA BARBOSA](https://github.com/Fredericobarbosa)
- [JORGE LUIZ PATROCINIO DOS SANTOS](https://github.com/jorgesantos001)
- [RAFAEL VICTOR REDOVAL DE SOUSA](https://github.com/rafaelVictor05)
- [YAGO RAPHAEL DE MELO MOURO](https://github.com/yagomouro)

---
Consulte os READMEs específicos em cada pasta para instruções detalhadas, exemplos de uso e informações técnicas.
