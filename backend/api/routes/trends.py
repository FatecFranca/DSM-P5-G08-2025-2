from flask import Blueprint, request, jsonify
from ..services.data_access import ArtifactStore

bp = Blueprint("trends", __name__)
store = ArtifactStore()

@bp.get("/trends")
def trends():
    if not store.has_all():
        return jsonify({"code": "ARTIFACTS_MISSING", "message": "Artefatos não encontrados. Rode o notebook de treino primeiro."}), 400
    ticker = request.args.get("ticker")
    if not ticker:
        return jsonify({"code": "BAD_REQUEST", "message": "Parâmetro 'ticker' é obrigatório."}), 400
    df = store.load_universe()
    sub = df[df["ticker"].str.upper() == ticker.upper()].copy()
    if sub.empty:
        return jsonify({"code": "NOT_FOUND", "message": "Ticker não encontrado no universo."}), 404
    r = sub.iloc[0]
    return jsonify({
        "ticker": r["ticker"],
        "rotulos": {
            "volatilidade": r.get("vol_label","media"),
            "liquidez": r.get("liq_label","media"),
            "tendencia_recente": r.get("trend_label","estavel")
        },
        "janela_referencia": {"ret_1m_dias": 21, "ret_3m_dias": 63, "ret_6m_dias": 126}
    })
