import os
from flask import Blueprint, request, send_file, jsonify
from ..services.data_access import ArtifactStore

bp = Blueprint("export", __name__)
store = ArtifactStore()

@bp.get("/export")
def export():
    if not store.has_all():
        return jsonify({"code": "ARTIFACTS_MISSING", "message": "Artefatos não encontrados. Rode o notebook de treino primeiro."}), 400
    t = request.args.get("type","derived")
    if t != "derived":
        return jsonify({"code": "BAD_REQUEST", "message": "Apenas type=derived está disponível no MVP."}), 400
    path = store.universe_csv
    if not os.path.exists(path):
        return jsonify({"code": "NOT_FOUND", "message": "Arquivo não encontrado."}), 404
    return send_file(path, as_attachment=True, download_name="universe.csv", mimetype="text/csv")
