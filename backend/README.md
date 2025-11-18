# 📈 Investia — API

---

## 🚀 Visão Geral
API para recomendar ações a partir de um perfil de investidor iniciante. O frontend primeiro **cadastra o usuário e salva seu perfil** (6 perguntas). Em seguida, a API **usa esse perfil salvo** para gerar uma lista ranqueada de ações e a probabilidade de compatibilidade por papel.

O modelo usado é uma rede neural (MLP) treinada offline. Os dados de perfil de usuário, histórico e as features dos ativos são hospedados em um banco de dados na nuvem (**MongoDB Atlas**).

> ⚠️ **Aviso:** Este produto é puramente educativo e não constitui recomendação de investimento.

---

## 1) 📋 Requisitos

* Python 3.10+
* pip (gerenciador de pacotes)
* **MongoDB Atlas:** Uma conta (o tier gratuito M0 é suficiente)
* Rede com acesso ao Yahoo Finance (para a biblioteca `yfinance`)

### Dependências Principais
(Listadas em `requirements.txt`)
* `Flask`, `flask-cors`, `flask-jwt-extended`, `flask-bcrypt`
* `pymongo` (driver oficial do MongoDB)
* `pandas`, `numpy`, `scikit-learn`, `joblib`
* `yfinance`
* `python-dotenv`

---

## 2) 🔧 Configuração e Instalação

### 2.1) Instalação das Dependências

```bash
# 1. Navegue até a pasta do projeto (ex: 'backend')
cd backend

# 2. Crie e ative um ambiente virtual (venv)
python -m venv .venv

# macOSLinux
source .venvbinactivate

# Windows (PowerShell)
# Se a execução de scripts estiver bloqueada, execute primeiro:
# Set-ExecutionPolicy Unrestricted -Scope Process
.venvScriptsActivate.ps1

# 3. Instale as dependências
pip install -r requirements.txt
```

### 2.2) Configuração do Ambiente (`.env`)
Este projeto **exige** um banco de dados MongoDB Atlas e chaves de segurança.

1.  Crie um arquivo chamado `.env` na raiz da pasta `backend`.
2.  Adicione as seguintes variáveis a ele, substituindo os valores:

```ini
# .env

# 1. String de conexão do seu cluster MongoDB Atlas
# (Substitua <username>, <password> e <cluster-url>)
MONGODB_URI="mongodb+srv:<username>:<password>@<cluster-url>?retryWrites=true&w=majority"

# 2. Chave secreta para assinar os tokens de login (JWT)
# (Pode ser qualquer string longa e aleatória)
JWT_SECRET_KEY="SUA_CHAVE_SECRETA_LONGA_E_ALEATORIA_AQUI"

# 3. (Opcional) Porta da API
PORT=8000
```

---

## 3) 🧠 Treinamento e Coleta de Dados
O script de treino `supervised_train.ipynb` (localizado na pasta notebooks) tem duas funções principais:

1.  Treinar o modelo de ML e salvar os artefatos (`.joblib`) localmente na pasta `artifacts`.
2.  Buscar dados do Yahoo Finance e **popular a coleção `assets` no MongoDB Atlas**.

### O que o script gera:
* `reco_model.joblib` — O modelo MLP treinado.
* `reco_scaler.joblib` — O scaler (StandardScaler) para as features.
* `feature_cols.json` — Lista de colunas usadas na inferência.
* **No MongoDB:** Uma coleção `assets` populada com os dados e features de cada ação.

### Execução:
1.  Abra o notebook `supervised_train.ipynb`, dentro da pasta `notebooks`.
2.  Certifique-se que seu `.env` está configurado (o notebook também precisa dele para acessar o Mongo).
3.  Execute todas as células do notebook.

---

## 4) ⚡ Subir a API
Com o ambiente configurado e os artefatos treinados, você pode iniciar o servidor Flask.

### Pré-requisitos:
* O arquivo `.env` DEVE estar preenchido.
* Os artefatos de treino (`.joblib`, `.json`) precisam existir na pasta `artifacts`.

### Execução:
```bash
# A partir da pasta 'backend' (e com o .venv ativado)
python -m api.app

# Por padrão, a API rodará em: http:localhost:8000
```

---

## 5) 🔌 Endpoints da API
A API usa autenticação JWT (JSON Web Token).
* Rotas públicas (`auth*`) podem ser acessadas por todos.
* Rotas marcadas com 🛡️ **(Protegida)** exigem um *header* de autorização.

> * Após o login, armazene o `access_token` e envie-o em todas as chamadas futuras para rotas protegidas no *header* `Authorization`:
>
> `Authorization: Bearer <seu_token>`

### 5.1) Autenticação (`auth`)

#### `POST /auth/register`
Registra um novo usuário.
* **Body (JSON):**
    ```json
    {
      "name": "Nome do Usuário",
      "email": "usuario@email.com",
      "password": "senha_min_6_chars"
    }
    ```
* **Resposta (201 OK):**
    ```json
    {
      "message": "Usuário criado com sucesso",
      "user_id": "690fd5fad706e81bd993f1fb"
    }
    ```
* **Erros Comuns:**
    * `400`: Dados faltando ou inválidos (ex: nome muito curto, senha curta).
    * `409`: Email já cadastrado.

#### `POST /auth/login`
Autentica um usuário e retorna o token de acesso.
* **Body (JSON):**
    ```json
    {
      "email": "usuario@email.com",
      "password": "senha_min_6_chars"
    }
    ```
* **Resposta (200 OK):**
    ```json
    {
      "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
    }
    ```
* **Erros Comuns:**
    * `401`: Email ou senha inválidos.

---

### 5.2) Perfil do Usuário (`profile`)

#### `POST /profile` 🛡️ (Protegida)
Cria ou atualiza o perfil de investidor do usuário logado.
* **Body (JSON):**
    ```json
    {
      "objetivo": "equilibrio",
      "conforto_oscilacao": "medio",
      "horizonte": "longo",
      "preferencias": { "pais": "BR", "setores": [] }
    }
    ```
* **Mapeamento de Valores do Perfil:**
    * `objetivo`: "crescer aos poucos" | "equilibrio" | "crescer mais rapido"
    * `conforto_oscilacao`: "baixo" | "medio" | "alto"
    * `horizonte`: "curto" | "medio" | "longo"
* **Resposta (200 OK):**
    ```json
    {
      "perfil": { ... (o perfil que foi salvo) ... }
    }
    ```

#### `GET /profile` 🛡️ (Protegida)
Busca o perfil de investidor salvo do usuário logado.
* **Body:** Nenhum.
* **Resposta (200 OK):**
    ```json
    {
      "perfil": { ... (o perfil salvo) ... }
    }
    ```
* **Erros Comuns:**
    * `404`: Perfil não encontrado (usuário precisa enviar um `POST` primeiro).

---

### 5.3) Recomendação (`match`)

#### `POST /match` 🛡️ (Protegida)
Gera o ranking de ações **baseado no perfil salvo do usuário logado**. O resultado é salvo no histórico do usuário.
* **Body (JSON) (Opcional):**
    ```json
    {
      "top_n": 5
    }
    ```
* **Resposta (200 OK):**
    ```json
    {
      "perfil_id": "690fd5fad706e81bd993f1fb",
      "perfil_tipo": "equilibrado",
      "items": [
        {
          "ticker": "AAPL",
          "name": "Apple Inc.",
          "setor": "Technology",
          "pais": "US",
          "ret_3m": 0.0721,
          "ret_6m": 0.1543,
          "vol_63": 0.0198,
          "volavg_21": 54213871.0,
          "prob_match": 0.8412
        },
        { "...": "..." }
      ]
    }
    ```
* **Erros Comuns:**
    * `401`: Token JWT ausente ou inválido.
    * `404`: Perfil do usuário não encontrado (usuário deve salvar um perfil via `POST profile` primeiro).
    * `500`: Artefatos de ML não encontrados (precisa rodar o treino).

---

### 5.4) Histórico (`history`)

#### `GET /history` 🛡️ (Protegida)
Retorna uma lista das últimas 20 recomendações geradas para o usuário logado (o resultado da rota `match`).
* **Body:** Nenhum.
* **Resposta (200 OK):**
    ```json
    {
      "items": [
        {
          "timestamp": "2025-11-08T23:50:00.000Z",
          "perfil_usado": { "objetivo": "equilibrio", ... },
          "items": [ { "ticker": "AAPL", ... }, { "ticker": "MSFT", ... } ],
          "perfil_tipo_calculado": "equilibrado"
        },
        { "..." }
      ],
      "count": 2
    }
    ```

---

### 5.5) Endpoints Utilitários

#### `GET /health`
Verifica o status básico da API.
* **Resposta (200 OK):** `{ "status": "ok" }`

#### `GET /universe`
Lista o universo de papéis disponível para UI (autocomplete filtros), lido diretamente do MongoDB.
* **Resposta (200 OK):**
    ```json
    {
      "count": 28,
      "items": [
        { "ticker": "AAPL", "name": "Apple Inc", "setor": "Technology", "pais": "US" },
        { "ticker": "PETR4.SA", "name": "Petrobras PN", "setor": "Energy", "pais": "BR" }
      ]
    }
    ```

---

## 6) 🔑 Variáveis de Ambiente (Resumo)
O arquivo `.env` na raiz do backend deve conter:

* `MONGODB_URI`: **(Obrigatória)** String de conexão do MongoDB Atlas.
* `JWT_SECRET_KEY`: **(Obrigatória)** Chave secreta longa e aleatória para o JWT.
* `PORT`: **(Opcional)** Porta da API; default: `8000`.
* `HOST`: **(Opcional)** Host bind; default: `0.0.0.0`.

---

## 7) 🧪 Fluxo de Teste (cURL)
Fluxo para testar a API.

#### 1. Registrar um novo usuário
```bash
curl -Uri "http://localhost:8000/auth/register" -Method POST -ContentType "application/json" -Body '{"name":"Usuário Teste", "email":"teste@email.com", "password":"minhasenha123"}'
```
#### 2. Fazer login para pegar o token

```bash
curl -Uri "http://localhost:8000/auth/login" -Method POST -ContentType "application/json" -Body '{"email":"teste@email.com", "password":"minhasenha123"}'
```

#### 3. Salvar o token em uma variável (exemplo para terminal)
```bash
$TOKEN = "COLE_SEU_TOKEN_AQUI"
```
#### 4. Salvar o perfil do usuário
```bash
curl -Uri "http://localhost:8000/profile" -Method POST -Headers @{"Authorization"="Bearer $TOKEN"; "Content-Type"="application/json"} -Body '{"objetivo":"equilibrio", "conforto_oscilacao":"medio", "horizonte":"longo"}'
```
#### 5. Obter recomendações (match)
```bash
curl -Uri "http://localhost:8000/match" -Method POST -Headers @{"Authorization"="Bearer $TOKEN"; "Content-Type"="application/json"} -Body '{"top_n": 3}'
```
#### 6. Consultar o histórico
```bash
curl -Uri "http://localhost:8000/history" -Headers @{"Authorization"="Bearer $TOKEN"}
```
