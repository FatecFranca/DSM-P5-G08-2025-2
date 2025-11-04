def derive_perfil_tipo(payload):
    objetivo = str(payload.get("objetivo","equilibrio")).lower()
    conforto = str(payload.get("conforto_oscilacao","medio")).lower()
    horizonte = str(payload.get("horizonte","medio")).lower()
    if conforto == "baixo":
        return "conservador"
    if conforto == "alto":
        return "ousado"
    if objetivo == "crescer mais rapido":
        return "ousado"
    if horizonte == "longo":
        return "equilibrado"
    return "equilibrado"

def one_hot_perfil(perfil_tipo):
    return {
        "perfil_conservador": 1 if perfil_tipo=="conservador" else 0,
        "perfil_equilibrado": 1 if perfil_tipo=="equilibrado" else 0,
        "perfil_ousado": 1 if perfil_tipo=="ousado" else 0,
    }
