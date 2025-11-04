import pandas as pd
from .scoring import derive_profile_weights, compute_score_row

def rank_recommendations(universe_df, perfil_payload, top_n=5, filtros=None):
    weights = derive_profile_weights(
        objetivo=perfil_payload.get("objetivo", "equilibrio"),
        conforto_oscilacao=perfil_payload.get("conforto_oscilacao", "medio"),
        horizonte=perfil_payload.get("horizonte", "medio"),
    )
    df = universe_df.copy()
    if filtros:
        pais = filtros.get("pais")
        setores = filtros.get("setores")
        if pais and pais != "any":
            df = df[df["pais"].str.upper() == pais.upper()]
        if setores and len(setores) > 0:
            df = df[df["setor"].isin(setores)]
    df["__score"] = df.apply(lambda r: compute_score_row(r, weights), axis=1)
    df = df.sort_values("__score", ascending=False)
    df = diversify(df, top_n)
    results = []
    for _, row in df.head(top_n).iterrows():
        selo = "Combina com seu perfil"
        motivos = build_reasons(row)
        item = {
            "ticker": row["ticker"],
            "nome": row.get("name", ""),
            "pais": row.get("pais", ""),
            "setor": row.get("setor", ""),
            "selo_perfil": selo,
            "rotulos": {
                "volatilidade": row.get("vol_label", "media"),
                "liquidez": row.get("liq_label", "media"),
                "tendencia_recente": row.get("trend_label", "estavel")
            },
            "motivos": motivos,
            "disclaimer": "Investimentos envolvem riscos. Este material é educativo e não é recomendação."
        }
        results.append(item)
    return {"perfil": weights["perfil"], "items": results}

def diversify(df, top_n):
    if "setor" not in df.columns:
        return df.head(top_n)
    seen = set()
    selected = []
    for _, r in df.iterrows():
        if r["setor"] not in seen or len(selected) < max(3, top_n // 2):
            selected.append(r)
            seen.add(r["setor"])
        if len(selected) >= top_n:
            break
    if len(selected) < top_n:
        remainder = df[~df.index.isin([x.name for x in selected])].head(top_n - len(selected))
        selected.extend(list(remainder.itertuples(index=True)))
        selected = [s if isinstance(s, pd.Series) else df.loc[s.Index] for s in selected]
    return pd.DataFrame(selected)

def build_reasons(row):
    reasons = []
    vol = str(row.get("vol_label", "media"))
    liq = str(row.get("liq_label", "media"))
    tr = str(row.get("trend_label", "estavel"))
    if vol == "baixa":
        reasons.append("Tende a oscilar menos do que outras ações do universo considerado.")
    elif vol == "alta":
        reasons.append("Pode oscilar mais ao longo do tempo.")
    else:
        reasons.append("Oscilação intermediária em relação ao universo considerado.")
    if liq == "alta":
        reasons.append("Alto volume de negociação, facilita comprar e vender.")
    elif liq == "baixa":
        reasons.append("Baixo volume de negociação, pode ser mais difícil negociar.")
    else:
        reasons.append("Liquidez intermediária.")
    if tr == "alta":
        reasons.append("Desempenho recente positivo, que pode mudar a qualquer momento.")
    elif tr == "baixa":
        reasons.append("Desempenho recente negativo, que pode mudar a qualquer momento.")
    else:
        reasons.append("Sem movimento recente relevante.")
    return reasons
