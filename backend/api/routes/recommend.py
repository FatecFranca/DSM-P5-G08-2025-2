from flask import Blueprint, request, jsonify
from ..services.data_access import ArtifactStore
from ..services.recommender import rank_recommendations

bp = Blueprint("recommend", __name__)
store = ArtifactStore()

@bp.post("/recommend")
def recommend():
    if not store.has_all():
        return jsonify({"code": "ARTIFACTS_MISSING", "message": "Artefatos não encontrados. Rode o notebook de treino primeiro."}), 400
    payload = request.get_json(force=True, silent=True) or {}
    perfil = (payload.get("perfil") or {})
    top_n = int(payload.get("top_n", 5))
    filtros = payload.get("filtros") or {}
    df = store.load_universe()
    result = rank_recommendations(df, perfil, top_n=top_n, filtros=filtros)
    return jsonify(result)
