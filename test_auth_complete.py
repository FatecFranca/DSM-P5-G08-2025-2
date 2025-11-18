#!/usr/bin/env python3
import requests
import json

def test_login():
    """Testa o login com um usuário já registrado"""
    url = "http://localhost:8000/auth/login"
    data = {
        "email": "maria@teste.com",
        "password": "123456789"
    }
    
    try:
        response = requests.post(url, json=data)
        print(f"Login - Status Code: {response.status_code}")
        print(f"Login - Response: {response.text}")
        
        if response.status_code == 200:
            token = response.json().get('access_token')
            print("✅ Login realizado com sucesso!")
            return token
        else:
            print("❌ Erro no login")
            return None
            
    except Exception as e:
        print(f"❌ Erro de conexão no login: {e}")
        return None

def test_register_duplicate():
    """Testa registro com email duplicado"""
    url = "http://localhost:8000/auth/register"
    data = {
        "name": "Maria Silva",
        "email": "maria@teste.com",
        "password": "123456789"
    }
    
    try:
        response = requests.post(url, json=data)
        print(f"Registro Duplicado - Status Code: {response.status_code}")
        print(f"Registro Duplicado - Response: {response.text}")
        
        if response.status_code == 409:
            print("✅ Validação de email duplicado funcionando!")
        else:
            print("❌ Erro na validação de email duplicado")
            
    except Exception as e:
        print(f"❌ Erro de conexão: {e}")

def test_register_invalid():
    """Testa registro com dados inválidos"""
    print("\n--- Testando validações ---")
    
    # Teste sem nome
    url = "http://localhost:8000/auth/register"
    data = {
        "email": "teste@email.com",
        "password": "123456789"
    }
    
    try:
        response = requests.post(url, json=data)
        print(f"Sem nome - Status Code: {response.status_code}")
        if response.status_code == 400:
            print("✅ Validação de nome obrigatório funcionando!")
        else:
            print("❌ Erro na validação de nome obrigatório")
    except Exception as e:
        print(f"❌ Erro: {e}")
    
    # Teste com senha curta
    data = {
        "name": "João Silva",
        "email": "joao2@teste.com",
        "password": "123"
    }
    
    try:
        response = requests.post(url, json=data)
        print(f"Senha curta - Status Code: {response.status_code}")
        if response.status_code == 400:
            print("✅ Validação de senha curta funcionando!")
        else:
            print("❌ Erro na validação de senha curta")
    except Exception as e:
        print(f"❌ Erro: {e}")

if __name__ == "__main__":
    print("=== Testando API de Autenticação ===\n")
    
    # Teste login
    token = test_login()
    
    # Teste registro duplicado
    test_register_duplicate()
    
    # Teste validações
    test_register_invalid()
    
    print("\n=== Testes concluídos ===")