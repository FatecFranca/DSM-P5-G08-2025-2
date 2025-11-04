import os
import json
import pandas as pd
from ..config import UNIVERSE_CSV, FEATURE_COLS_JSON, CLUSTER_MAP_JSON, MODEL_PATH

class ArtifactStore:
    def __init__(self, universe_csv=UNIVERSE_CSV, feature_cols_json=FEATURE_COLS_JSON, cluster_map_json=CLUSTER_MAP_JSON, model_path=MODEL_PATH):
        self.universe_csv = universe_csv
        self.feature_cols_json = feature_cols_json
        self.cluster_map_json = cluster_map_json
        self.model_path = model_path
        self._universe_df = None
        self._feature_cols = None
        self._cluster_map = None

    def has_all(self):
        return all(os.path.exists(p) for p in [self.universe_csv, self.feature_cols_json, self.cluster_map_json, self.model_path])

    def load_universe(self):
        if self._universe_df is None:
            self._universe_df = pd.read_csv(self.universe_csv)
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
