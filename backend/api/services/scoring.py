import numpy as np
import pandas as pd

VOL_MAP = {"baixa": 2.0, "media": 1.0, "alta": 0.0}
LIQ_MAP = {"baixa": 0.0, "media": 1.0, "alta": 2.0}
TREND_MAP = {"baixa": 0.0, "estavel": 1.0, "alta": 2.0}

def normalize_series(s):
    if s.max() == s.min():
        return pd.Series(np.zeros(len(s)), index=s.index)
    return (s - s.min()) / (s.max() - s.min())

def derive_profile_weights(objetivo, conforto_oscilacao, horizonte):
    perfil = "equilibrado"
    if conforto_oscilacao == "baixo":
        perfil = "conservador"
    elif conforto_oscilacao == "alto":
        perfil = "ousado"
    w_vol = 0.5 if perfil == "conservador" else (0.3 if perfil == "equilibrado" else 0.15)
    w_liq = 0.2 if perfil == "conservador" else (0.25 if perfil == "equilibrado" else 0.25)
    w_trend = 0.15 if perfil == "conservador" else (0.25 if perfil == "equilibrado" else 0.4)
    w_misc = 1.0 - (w_vol + w_liq + w_trend)
    return {"perfil": perfil, "w_vol": w_vol, "w_liq": w_liq, "w_trend": w_trend, "w_misc": w_misc}

def compute_score_row(row, weights):
    vol_score = VOL_MAP.get(str(row.get("vol_label", "media")), 1.0)
    liq_score = LIQ_MAP.get(str(row.get("liq_label", "media")), 1.0)
    trend_score = TREND_MAP.get(str(row.get("trend_label", "estavel")), 1.0)
    ret_3m = row.get("ret_3m", 0.0)
    misc = ret_3m
    score = weights["w_vol"] * vol_score + weights["w_liq"] * liq_score + weights["w_trend"] * trend_score + weights["w_misc"] * misc
    return float(score)

def label_simplified(volatility_q, liquidity_q, ret_1m):
    if volatility_q <= 0.33:
        vol = "baixa"
    elif volatility_q >= 0.66:
        vol = "alta"
    else:
        vol = "media"
    if liquidity_q <= 0.33:
        liq = "baixa"
    elif liquidity_q >= 0.66:
        liq = "alta"
    else:
        liq = "media"
    t = "estavel"
    if ret_1m > 0.03:
        t = "alta"
    elif ret_1m < -0.03:
        t = "baixa"
    return vol, liq, t
