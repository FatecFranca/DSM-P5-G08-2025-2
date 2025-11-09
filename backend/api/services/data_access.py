import os
import json
import pandas as pd
from ..config import UNIVERSE_CSV, FEATURE_COLS_JSON, CLUSTER_MAP_JSON, MODEL_PATH

from pymongo import MongoClient
from dotenv import load_dotenv

class ArtifactStore:
    def __init__(self, universe_csv=UNIVERSE_CSV, feature_cols_json=FEATURE_COLS_JSON, cluster_map_json=CLUSTER_MAP_JSON, model_path=MODEL_PATH):
        load_dotenv()
        connection_string = os.getenv("MONGODB_URI")
        if not connection_string:
            raise ValueError("MONGODB_URI não encontrada. Verifique seu arquivo .env")
            
        client = MongoClient(connection_string)
        db = client["investia"]

        self.assets_collection = db["assets"]


        self.universe_csv = universe_csv
        self.feature_cols_json = feature_cols_json
        self.cluster_map_json = cluster_map_json
        self.model_path = model_path
        self._universe_df = None
        self._feature_cols = None
        self._cluster_map = None

    def has_all(self):
        return all(os.path.exists(p) for p in [self.feature_cols_json, self.cluster_map_json, self.model_path])

    def load_universe(self):
        cursor = self.assets_collection.find(
                    {},  # Filtro vazio {} significa "trazer todos os documentos"
                    {"_id": 0} 
                )
            
        assets_list = list(cursor)
            
        if not assets_list:
            raise RuntimeError("Coleção 'assets' está vazia no MongoDB. Rode o notebook de treino.")
                 
        self._universe_df = pd.DataFrame(assets_list)
        print(f"Carregado {len(self._universe_df)} ativos com features do MongoDB.")
            
        return self._universe_df

    def feature_cols(self):
        if self._feature_cols is None:
            with open(self.feature_cols_json, "r", encoding="utf-8") as f:
                self._feature_cols = json.load(f)
        return self._feature_cols

    def cluster_map(self):
        if self._cluster_map is None:
            with open(self.cluster_map_json, "r", encoding="utf-8") as f:
                self._cluster_map = json.load(f)
        return self._cluster_map
