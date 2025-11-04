import os

ARTIFACTS_DIR = os.getenv("ARTIFACTS_DIR", os.path.join(os.path.dirname(os.path.dirname(__file__)), "artifacts"))
UNIVERSE_CSV = os.path.join(ARTIFACTS_DIR, "universe.csv")
FEATURE_COLS_JSON = os.path.join(ARTIFACTS_DIR, "feature_cols.json")
CLUSTER_MAP_JSON = os.path.join(ARTIFACTS_DIR, "cluster_map.json")
MODEL_PATH = os.path.join(ARTIFACTS_DIR, "model.joblib")

DEFAULT_TOP_N = 5
