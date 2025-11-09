# api/app.py
import os
from flask import Flask
from flask_cors import CORS

from flask_jwt_extended import JWTManager
from flask_bcrypt import Bcrypt

from dotenv import load_dotenv
from pymongo import MongoClient

load_dotenv()

connection_string = os.getenv("MONGODB_URI")

if not connection_string:
    raise ValueError("MONGODB_URI não encontrada. Verifique seu arquivo .env")

# Conecta ao MongoDB
client = MongoClient(connection_string)
db = client["investia"]

users_collection = db["users"]
profiles_collection = db["profiles"]
assets_collection = db["assets"]
recommendations_history_collection = db["recommendations_history"]

print("Conectado ao MongoDB Atlas com sucesso!")

bcrypt = Bcrypt()
jwt = JWTManager()

def create_app():
    app = Flask(__name__)
    CORS(app)

    app.config["JWT_SECRET_KEY"] = os.getenv("JWT_SECRET_KEY", "super-secret-default-key-dev")

    bcrypt.init_app(app)
    jwt.init_app(app)

    from .routes.auth import bp as auth_bp   
    from .routes.history import bp as history_bp

    from .routes.health import bp as health_bp
    from .routes.universe import bp as universe_bp
    from .routes.profile import bp as profile_bp
    from .routes.recommend import bp as recommend_bp
    from .routes.trends import bp as trends_bp
    from .routes.export import bp as export_bp
    from .routes.match import bp as match_bp

    app.register_blueprint(health_bp)
    app.register_blueprint(universe_bp)
    app.register_blueprint(profile_bp, url_prefix="/profile")
    app.register_blueprint(recommend_bp)
    app.register_blueprint(trends_bp)
    app.register_blueprint(export_bp)
    app.register_blueprint(match_bp)
    app.register_blueprint(auth_bp, url_prefix="/auth")   
    app.register_blueprint(history_bp, url_prefix="/history") 
    return app


if __name__ == "__main__":
    app = create_app() 
    
    port = int(os.getenv("PORT", 8000))
    host = os.getenv("HOST", "0.0.0.0")
    app.run(host=host, port=port)
