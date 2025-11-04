from flask import Blueprint, jsonify, current_app
from ..services.data_access import ArtifactStore

bp = Blueprint("universe", __name__)
store = ArtifactStore()

@bp.get("/universe")
def universe():
    if not store.has_all():
        return jsonify({"code": "ARTIFACTS_MISSING", "message": "Artefatos não encontrados. Rode o notebook de treino primeiro."}), 400
    df = store.load_universe()
    cols = ["ticker","name","setor","pais"]
    out = df[cols].to_dict(orient="records")
    return jsonify({"count": len(out), "items": out})
