from flask import Blueprint, request, jsonify
import pandas as pd
import joblib
import json
import os
from ..config import ARTIFACTS_DIR

bp = Blueprint("analyze", __name__)

MODEL_PATH = os.path.join(ARTIFACTS_DIR, "model.joblib")
UNIVERSE_PATH = os.path.join(ARTIFACTS_DIR, "universe.csv")
CLUSTER_MAP_PATH = os.path.join(ARTIFACTS_DIR, "cluster_map.json")

@bp.post("/analyze")
def analyze():
    if not all(os.path.exists(p) for p in [MODEL_PATH, UNIVERSE_PATH, CLUSTER_MAP_PATH]):
        return jsonify({"error": "Modelo ou artefatos não encontrados. Rode o treino primeiro."}), 400

    data = request.get_json(force=True, silent=True) or {}
    perfil_id = str(data.get("perfil_id", ""))
    perfil_tipo = str(data.get("perfil_tipo", "")).lower()

    if not perfil_id or not perfil_tipo:
        return jsonify({"error": "Campos obrigatórios: perfil_id, perfil_tipo"}), 400

    model = joblib.load(MODEL_PATH)
    cluster_map = json.load(open(CLUSTER_MAP_PATH, "r", encoding="utf-8"))
    df = pd.read_csv(UNIVERSE_PATH)

    perfil_map_inv = {v.lower(): k for k, v in cluster_map.items()}
    cluster_match = perfil_map_inv.get(perfil_tipo)
    if cluster_match is None:
        return jsonify({"error": f"Perfil '{perfil_tipo}' não encontrado no modelo."}), 400

    df_match = df[df["cluster"] == int(cluster_match)]
    df_other = df[df["cluster"] != int(cluster_match)]

    result = {
        "perfil_id": perfil_id,
        "perfil_tipo": perfil_tipo,
        "recomendadas": df_match[["ticker", "name", "setor", "pais"]].to_dict(orient="records"),
        "nao_recomendadas": df_other[["ticker", "name", "setor", "pais"]].head(10).to_dict(orient="records"),
        "total_recomendadas": len(df_match)
    }
    return jsonify(result)
