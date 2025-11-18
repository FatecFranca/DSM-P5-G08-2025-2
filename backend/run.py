#!/usr/bin/env python3
"""
Script para executar o servidor Flask.
"""
import os
import sys

# Adiciona o diretório atual ao PYTHONPATH
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from api.app import create_app

if __name__ == "__main__":
    app = create_app()
    
    port = int(os.getenv("PORT", 8000))
    host = os.getenv("HOST", "0.0.0.0")
    
    print(f"Iniciando servidor Flask em http://{host}:{port}")
    app.run(host=host, port=port, debug=True)