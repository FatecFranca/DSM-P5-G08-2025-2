# Recomendador de Ações — API (README)

## Visão Geral
API para recomendar ações a partir de um perfil de investidor iniciante. O frontend envia um perfil simples (6 perguntas) e a API responde com uma lista ranqueada de ações e a probabilidade de compatibilidade por papel. O modelo usado é uma rede neural (MLP) treinada offline, que combina o perfil do usuário e métricas históricas dos ativos.

> Aviso: este produto é educativo e não constitui recomendação de investimento.

## 1) Requisitos
- Python 3.10+
- pip
- Rede com acesso ao Yahoo Finance (biblioteca yfinance)

Dependências principais (já listadas em requirements.txt):
- Flask, flask-cors
- pandas, numpy, scikit-learn, joblib
- yfinance
- python-dotenv (opcional)

---

## 2) Instalação
```bash
# 1) entrar na pasta do projeto
cd stock_recommender_simple

# 2) criar e ativar venv
python -m venv .venv
# macOS/Linux
source .venv/bin/activate
# Windows (PowerShell)
#..venvScriptsActivate.ps1

# 3) instalar dependências
pip install -r requirements.txt
```

---

## 3) Treino do Modelo Supervisionado (MLP)
O treinamento gera artefatos consumidos pela API:
- artifacts/reco_model.joblib — modelo MLP
- artifacts/reco_scaler.joblib — scaler para features
- artifacts/feature_cols.json — colunas usadas na inferência
- artifacts/universe_features.csv — features finais por ticker

Execute:
bash
python train_supervised.py


Observações:
- O script baixa cotações do Yahoo, calcula métricas (ex.: ret_3m, ret_6m, vol_63, volavg_21) e sintetiza rótulos para aprendizado.
- Se o Yahoo falhar temporariamente (rate-limit/rede), rode novamente. Opcionalmente, reduza a lista de tickers no script para validar o pipeline.

---

## 4) Subir a API
```bash
# a partir da raiz do projeto
python -m api.app
# por padrão: http://localhost:8000


# Alterar porta/host:
bash
# macOS/Linux
PORT=8080 HOST=0.0.0.0 python -m api.app
# Windows (PowerShell)
$env:PORT=8080; $env:HOST="0.0.0.0"; python -m api.app

# Pré-requisito: os artefatos do treino precisam existir em artifacts/.
```

---

## 5) Endpoints e Exemplos

### 5.1 GET /health
Verifica o status básico da API.

Exemplo de resposta
```json
{ "status": "ok", "version": "1.0.0" }
```

---

### 5.2 GET /universe
Lista o universo de papéis disponível para UI (autocomplete/filtros).

Exemplo de resposta
```json
{
    "count": 4,
 "items": [
    { "ticker": "AAPL", "name": "Apple Inc", "setor": "Technology", "pais": "US" },
 { "ticker": "MSFT", "name": "Microsoft Corp", "setor": "Technology", "pais": "US" },
 { "ticker": "PETR4.SA", "name": "Petrobras PN", "setor": "Energy", "pais": "BR" },
 { "ticker": "VALE3.SA", "name": "Vale ON", "setor": "Materials", "pais": "BR" }
 ]
}
```


Erros: 400 se artefatos ausentes.

---

### 5.3 POST /match
Gera ranking de ações por probabilidade de compatibilidade com o perfil do usuário, usando a rede neural treinada.

Request (JSON)
```json
{
    "perfil_id": "user_123",
 "perfil": {
    "objetivo": "equilibrio",
 "conforto_oscilacao": "medio",
 "horizonte": "medio",
 "aporte_mensal": 500,
 "preferencias": { "pais": "any", "setores": [] }
 },
 "top_n": 5
}
```


Exemplo de respostas válidas do payload
```json
{
    "perfil_id": "abc-001",
 "perfil": {
    "objetivo": "crescer aos poucos",
 "conforto_oscilacao": "baixo",
 "horizonte": "curto",
 "aporte_mensal": 200,
 "preferencias": { "pais": "BR", "setores": ["Financeiro","Energia"] }
 },
 "top_n": 10
}
```

```json
{
    "perfil_id": "xyz-999",
 "perfil": {
    "objetivo": "crescer mais rapido",
 "conforto_oscilacao": "alto",
 "horizonte": "longo",
 "aporte_mensal": 0,
 "preferencias": { "pais": "US", "setores": ["Tech"] }
 },
 "top_n": 3
}
```

Response (200 OK)
```json
{
    "perfil_id": "user_123",
 "perfil_tipo": "equilibrado",
 "items": [
    {
    "ticker": "AAPL",
 "pais": "US",
 "ret_3m": 0.0721,
 "ret_6m": 0.1543,
 "vol_63": 0.0198,
 "volavg_21": 54213871.0,
 "prob_match": 0.8412
 },
 {
    "ticker": "MSFT",
 "pais": "US",
 "ret_3m": 0.0613,
 "ret_6m": 0.1211,
 "vol_63": 0.0172,
 "volavg_21": 34501981.0,
 "prob_match": 0.8267
 }
 ]
}
```

Erros comuns
```json
{ "error": "Artefatos do modelo não encontrados. Rode train_supervised.py" }
```

```json
{ "error": "perfil_id é obrigatório" }
```


---

### 5.4 GET /trends?ticker=XYZ
Rótulos simples para a UI.

Exemplo de chamada

GET /trends?ticker=AAPL


Response (200 OK)
```json
{
    "ticker": "AAPL",
 "rotulos": {
    "volatilidade": "media",
 "liquidez": "alta",
 "tendencia_recente": "alta"
 },
 "janela_referencia": {
    "ret_1m_dias": 21,
 "ret_3m_dias": 63,
 "ret_6m_dias": 126
 }
}
```

Erros
```json
{ "code": "BAD_REQUEST", "message": "Parâmetro 'ticker' é obrigatório." }
```

```json
{ "code": "NOT_FOUND", "message": "Ticker não encontrado no universo." }
```


---

### 5.5 (Opcional) GET /export?type=derived&format=csv
Exporta o CSV do universo derivado para compartilhamento.

Erros
```json
{ "code": "NOT_FOUND", "message": "Arquivo não encontrado." }
```


---

## 6) Mapeamento do Perfil → Payload
- perfil_id: string gerada no cliente (UUID)
- perfil.objetivo: "crescer aos poucos" | "equilibrio" | "crescer mais rapido"
- perfil.conforto_oscilacao: "baixo" | "medio" | "alto"
- perfil.horizonte: "curto" | "medio" | "longo"
- perfil.aporte_mensal: número ≥ 0 (opcional; usar 0 se ausente)
- perfil.preferencias.pais: "any" | "BR" | "US" (default "any")
- perfil.preferencias.setores: array de strings (pode ser vazio)
- top_n: número (default 5–10)

---

## 7) Variáveis de Ambiente
- ARTIFACTS_DIR (opcional) — caminho dos artefatos; default: ./artifacts
- PORT (opcional) — porta da API; default: 8000
- HOST (opcional) — host bind; default: 0.0.0.0

Exemplo:
bash
# macOS/Linux
export ARTIFACTS_DIR=artifacts
export PORT=8000
export HOST=0.0.0.0
python -m api.app


---

## 8) Testes Rápidos (cURL)
```bash
curl http://localhost:8000/health

curl http://localhost:8000/universe

curl -X POST http://localhost:8000/match 
 -H "Content-Type: application/json" 
 -d '{
    "perfil_id":"user_123",
 "perfil":{
    "objetivo":"equilibrio",
 "conforto_oscilacao":"medio",
 "horizonte":"medio",
 "aporte_mensal":500,
 "preferencias":{"pais":"any","setores":[]}
 },
 "top_n":5
 }'

curl "http://localhost:8000/trends?ticker=AAPL"
```