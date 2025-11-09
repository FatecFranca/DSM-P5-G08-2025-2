# api/routes/history.py
from flask import Blueprint, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from bson.objectid import ObjectId

from ..app import recommendations_history_collection

bp = Blueprint("history", __name__)

@bp.get("") # Rota GET /history
@jwt_required()
def get_history():
    user_id = get_jwt_identity()
    
    # Busca todos os históricos do usuário, ordenado do mais novo para o mais antigo
    cursor = recommendations_history_collection.find(
        {"user_id": ObjectId(user_id)},
        {"_id": 0, "user_id": 0} 
    ).sort("timestamp", -1).limit(20)

    history_list = list(cursor)
    
    return jsonify({"items": history_list, "count": len(history_list)})