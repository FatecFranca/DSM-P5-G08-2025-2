# api/routes/profile.py
from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from bson.objectid import ObjectId
import datetime

from ..app import profiles_collection

bp = Blueprint("profile", __name__)

def normalize(value, allowed):
    v = str(value).lower()
    return v if v in allowed else list(allowed)[0]

@bp.post("")  
@jwt_required() 
def save_profile():
    user_id = get_jwt_identity()
    
    data = request.get_json(force=True, silent=True) or {}
    
    objetivo = normalize(data.get("objetivo","equilibrio"), {"crescer aos poucos","equilibrio","crescer mais rapido"})
    conforto = normalize(data.get("conforto_oscilacao","medio"), {"baixo","medio","alto"})
    horizonte = normalize(data.get("horizonte","medio"), {"curto","medio","longo"})
    preferencias = data.get("preferencias") or {}
    pais = preferencias.get("pais","any")
    setores = preferencias.get("setores") or []
    
    perfil = {
        "user_id": ObjectId(user_id),
        "objetivo": objetivo, 
        "conforto_oscilacao": conforto, 
        "horizonte": horizonte, 
        "preferencias": {"pais": pais, "setores": setores},
        "updated_at": datetime.datetime.now(datetime.timezone.utc)
    }

    profiles_collection.update_one(
        {"user_id": ObjectId(user_id)}, # Filtro
        {"$set": perfil},               # Dados
        upsert=True
    )
    
    perfil.pop("_id", None)
    perfil.pop("user_id", None)
    
    return jsonify({"perfil": perfil}), 200

@bp.get("")  
@jwt_required()
def get_profile():
    user_id = get_jwt_identity()
    
    perfil = profiles_collection.find_one(
        {"user_id": ObjectId(user_id)},
        {"_id": 0, "user_id": 0} 
    )

    if not perfil:
        return jsonify({"error": "Perfil não encontrado. Envie um POST para criar."}), 404
        
    return jsonify({"perfil": perfil}), 200