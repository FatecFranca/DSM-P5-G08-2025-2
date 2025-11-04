# api/routes/match.py
from flask import Blueprint, request, jsonify
import os, json
import pandas as pd
from joblib import load
from ..config import ARTIFACTS_DIR
from ..services.profile_encoder import derive_perfil_tipo, one_hot_perfil

bp = Blueprint("match", __name__)

MODEL_PATH = os.path.join(ARTIFACTS_DIR, "reco_model.joblib")
SCALER_PATH = os.path.join(ARTIFACTS_DIR, "reco_scaler.joblib")
FEATURES_CSV = os.path.join(ARTIFACTS_DIR, "universe_features.csv")
FEATURE_COLS_JSON = os.path.join(ARTIFACTS_DIR, "feature_cols.json")

@bp.post("/match")
def match():
    if not all(os.path.exists(p) for p in [MODEL_PATH, SCALER_PATH, FEATURES_CSV, FEATURE_COLS_JSON]):
        return jsonify({"error":"Artefatos do modelo não encontrados. Rode train_supervised.py"}), 400
    payload = request.get_json(force=True, silent=True) or {}
    perfil_id = str(payload.get("perfil_id","")).strip()
    perfil = payload.get("perfil") or {}
    if not perfil_id:
        return jsonify({"error":"perfil_id é obrigatório"}), 400
    perfil_tipo = derive_perfil_tipo(perfil)
    onehot = one_hot_perfil(perfil_tipo)
    df = pd.read_csv(FEATURES_CSV).fillna(0.0)
    with open(FEATURE_COLS_JSON,"r",encoding="utf-8") as f:
        feature_cols = json.load(f)
    for k in ["perfil_conservador","perfil_equilibrado","perfil_ousado"]:
        df[k] = onehot[k]
    X = df[feature_cols].values
    scaler = load(SCALER_PATH)
    model = load(MODEL_PATH)
    Xs = scaler.transform(X)
    prob = model.predict_proba(Xs)[:,1]
    df["prob_match"] = prob
    df = df.sort_values("prob_match", ascending=False)
    top_n = int(payload.get("top_n", 10))
    items = df.head(top_n)[["ticker","pais","ret_3m","ret_6m","vol_63","volavg_21","prob_match"]].to_dict(orient="records")
    return jsonify({"perfil_id": perfil_id, "perfil_tipo": perfil_tipo, "items": items})
