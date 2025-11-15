class TrendModel {
  final String ticker;
  final Map<String, String> rotulos;
  final Map<String, dynamic> janelaReferencia;

  TrendModel({
    required this.ticker,
    required this.rotulos,
    required this.janelaReferencia,
  });

  factory TrendModel.fromJson(Map<String, dynamic> json) {
    return TrendModel(
      ticker: json["ticker"],
      rotulos: Map<String, String>.from(json["rotulos"] ?? {}),
      janelaReferencia: Map<String, dynamic>.from(json["janela_referencia"] ?? {}),
    );
  }
}
