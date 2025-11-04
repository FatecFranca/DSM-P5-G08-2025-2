from flask import Blueprint, jsonify

bp = Blueprint("health", __name__)

@bp.get("/health")
@bp.get("/")
def health():
    return jsonify({"status": "ok", "version": "1.0.0"})
