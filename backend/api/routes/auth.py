# api/routes/auth.py
from flask import Blueprint, request, jsonify
from flask_jwt_extended import create_access_token
from bson.objectid import ObjectId
import datetime

from ..app import bcrypt, users_collection

bp = Blueprint("auth", __name__)

@bp.post("/register")
def register():
    data = request.get_json(force=True, silent=True) or {}
    email = data.get("email")
    password = data.get("password")

    if not email or not password:
        return jsonify({"error": "Email e senha são obrigatórios"}), 400

    if not isinstance(password, str):
        return jsonify({"error": "Formato inválido. A senha deve ser uma string (texto)."}), 400

    if not isinstance(email, str):
        return jsonify({"error": "Formato inválido. O email deve ser uma string (texto)."}), 400
        
    if len(password) < 6:
        return jsonify({"error": "A senha deve ter pelo menos 6 caracteres"}), 400

    existing_user = users_collection.find_one({"email": email.lower()})
    if existing_user:
        return jsonify({"error": "Email já cadastrado"}), 409

    hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')
    
    user_data = {
        "email": email.lower(),
        "password": hashed_password,
        "created_at": datetime.datetime.now(datetime.timezone.utc)
    }
    result = users_collection.insert_one(user_data)

    return jsonify({
        "message": "Usuário criado com sucesso",
        "user_id": str(result.inserted_id)
    }), 201

@bp.post("/login")
def login():
    data = request.get_json(force=True, silent=True) or {}
    email = data.get("email")
    password = data.get("password")

    if not email or not password:
        return jsonify({"error": "Email e senha são obrigatórios"}), 400

    # Busca o usuário no banco
    user = users_collection.find_one({"email": email})

    # Verifica o usuário e a senha
    if user and bcrypt.check_password_hash(user["password"], password):
        access_token = create_access_token(
            identity=str(user["_id"]), 
            expires_delta=datetime.timedelta(days=1)
        )
        return jsonify(access_token=access_token), 200
    else:
        return jsonify({"error": "Email ou senha inválidos"}), 401