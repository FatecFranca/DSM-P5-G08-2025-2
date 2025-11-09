# api/routes/match.py
from flask import Blueprint, request, jsonify
import os, json
import pandas as pd
from joblib import load
from ..config import ARTIFACTS_DIR
from ..services.profile_encoder import derive_perfil_tipo, one_hot_perfil

from flask_jwt_extended import jwt_required, get_jwt_identity
from bson.objectid import ObjectId
import datetime
from ..app import profiles_collection, assets_collection, recommendations_history_collection


bp = Blueprint("match", __name__)

MODEL_PATH = os.path.join(ARTIFACTS_DIR, "reco_model.joblib")
SCALER_PATH = os.path.join(ARTIFACTS_DIR, "reco_scaler.joblib")
FEATURE_COLS_JSON = os.path.join(ARTIFACTS_DIR, "feature_cols.json")

@bp.post("/match")
@jwt_required()
def match():
    
    if not all(os.path.exists(p) for p in [MODEL_PATH, SCALER_PATH, FEATURE_COLS_JSON]):
        return jsonify({"error":"Artefatos de ML (.joblib, .json) não encontrados. Rode train_supervised.py"}), 400

    user_id = get_jwt_identity() 

    perfil_doc = profiles_collection.find_one({"user_id": ObjectId(user_id)})
    if not perfil_doc:
        return jsonify({"error": "Perfil não encontrado. Salve um perfil primeiro via POST /profile."}), 404
    
    payload = request.get_json(force=True, silent=True) or {}
    top_n = int(payload.get("top_n", 10))

    perfil_tipo = derive_perfil_tipo(perfil_doc) 
    onehot = one_hot_perfil(perfil_tipo)

    cursor = assets_collection.find({}, {"_id": 0})
    assets_list = list(cursor)
    if not assets_list:
        return jsonify({"error": "Universo de ativos não encontrado no DB. Rode o notebook de treino."}), 500
    
    df = pd.DataFrame(assets_list).fillna(0.0)

    with open(FEATURE_COLS_JSON,"r",encoding="utf-8") as f:
        feature_cols = json.load(f)
    
    scaler = load(SCALER_PATH)
    model = load(MODEL_PATH)

    for k in ["perfil_conservador","perfil_equilibrado","perfil_ousado"]:
        df[k] = onehot[k]
    
    X = df[feature_cols].values
    
    Xs = scaler.transform(X)
    prob = model.predict_proba(Xs)[:,1]
    df["prob_match"] = prob
    df = df.sort_values("prob_match", ascending=False)

    output_cols = ["ticker", "name", "setor", "pais", "ret_3m", "ret_6m", "vol_63", "volavg_21", "prob_match"]
    final_cols = [col for col in output_cols if col in df.columns] 
    items_recomendados = df.head(top_n)[final_cols].to_dict(orient="records")

    perfil_doc.pop("_id", None) 
    perfil_doc.pop("user_id", None)

    history_entry = {
        "user_id": ObjectId(user_id),
        "timestamp": datetime.datetime.now(datetime.timezone.utc),
        "perfil_usado": perfil_doc, 
        "items": items_recomendados,
        "perfil_tipo_calculado": perfil_tipo
    }
    recommendations_history_collection.insert_one(history_entry)

    return jsonify({
        "perfil_id": user_id,
        "perfil_tipo": perfil_tipo, 
        "items": items_recomendados
    })