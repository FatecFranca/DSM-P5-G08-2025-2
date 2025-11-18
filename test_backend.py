#!/usr/bin/env python3
import requests
import json

def test_register():
    url = "http://localhost:8000/auth/register"
    data = {
        "name": "Maria Silva",
        "email": "maria@teste.com", 
        "password": "123456789"
    }
    
    try:
        response = requests.post(url, json=data)
        print(f"Status Code: {response.status_code}")
        print(f"Response: {response.text}")
        
        if response.status_code == 201:
            print("✅ Registro realizado com sucesso!")
        else:
            print("❌ Erro no registro")
            
    except Exception as e:
        print(f"❌ Erro de conexão: {e}")

if __name__ == "__main__":
    test_register()