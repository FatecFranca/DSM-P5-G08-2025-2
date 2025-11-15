class MatchItem {
  final String ticker;
  final String pais;
  final double ret3m;
  final double ret6m;
  final double vol63;
  final double volavg21;
  final double probMatch;

  MatchItem({
    required this.ticker,
    required this.pais,
    required this.ret3m,
    required this.ret6m,
    required this.vol63,
    required this.volavg21,
    required this.probMatch,
  });

  factory MatchItem.fromMap(Map<String, dynamic> map) {
    return MatchItem(
      ticker: map["ticker"],
      pais: map["pais"],
      ret3m: (map["ret_3m"] ?? 0).toDouble(),
      ret6m: (map["ret_6m"] ?? 0).toDouble(),
      vol63: (map["vol_63"] ?? 0).toDouble(),
      volavg21: (map["volavg_21"] ?? 0).toDouble(),
      probMatch: (map["prob_match"] ?? 0).toDouble(),
    );
  }
}
