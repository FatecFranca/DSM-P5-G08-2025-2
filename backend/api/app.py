# api/app.py
import os
from flask import Flask
from flask_cors import CORS
from .routes.health import bp as health_bp
from .routes.universe import bp as universe_bp
from .routes.profile import bp as profile_bp
from .routes.recommend import bp as recommend_bp
from .routes.trends import bp as trends_bp
from .routes.export import bp as export_bp
from .routes.match import bp as match_bp


def create_app():
    app = Flask(__name__)
    CORS(app)
    app.register_blueprint(health_bp)
    app.register_blueprint(universe_bp)
    app.register_blueprint(profile_bp)
    app.register_blueprint(recommend_bp)
    app.register_blueprint(trends_bp)
    app.register_blueprint(export_bp)
    app.register_blueprint(match_bp)
    return app


app = create_app()

if __name__ == "__main__":
    port = 8000
    host = "0.0.0.0"
    app.run(host=host, port=port)
