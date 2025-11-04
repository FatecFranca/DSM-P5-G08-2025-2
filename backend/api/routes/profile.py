from flask import Blueprint, request, jsonify

bp = Blueprint("profile", __name__)

def normalize(value, allowed):
    v = str(value).lower()
    return v if v in allowed else list(allowed)[0]

@bp.post("/profile")
def profile():
    data = request.get_json(force=True, silent=True) or {}
    objetivo = normalize(data.get("objetivo","equilibrio"), {"crescer aos poucos","equilibrio","crescer mais rapido"})
    conforto = normalize(data.get("conforto_oscilacao","medio"), {"baixo","medio","alto"})
    horizonte = normalize(data.get("horizonte","medio"), {"curto","medio","longo"})
    preferencias = data.get("preferencias") or {}
    pais = preferencias.get("pais","any")
    setores = preferencias.get("setores") or []
    perfil = {"objetivo": objetivo, "conforto_oscilacao": conforto, "horizonte": horizonte, "preferencias": {"pais": pais, "setores": setores}}
    return jsonify({"perfil": perfil})
