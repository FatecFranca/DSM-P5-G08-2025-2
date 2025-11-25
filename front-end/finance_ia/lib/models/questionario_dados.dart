class QuestionnaireData {
  String objetivo;
  String confortoOscilacao;
  String horizonte;
  double aporteMensal;
  String pais;
  List<String> setores;

  QuestionnaireData({
    this.objetivo = "",
    this.confortoOscilacao = "",
    this.horizonte = "",
    this.aporteMensal = 0,
    this.pais = "",
    List<String>? setores,
  }) : setores = setores ?? [];

  factory QuestionnaireData.fromMap(Map<String, dynamic> map) {
    final preferencias = map["preferencias"] ?? {};

    return QuestionnaireData(
      objetivo: map["objetivo"] ?? "",
      confortoOscilacao: map["conforto_oscilacao"] ?? "",
      horizonte: map["horizonte"] ?? "",
      aporteMensal: (map["aporte_mensal"] ?? 0).toDouble(),
      pais: preferencias["pais"] ?? map["pais"] ?? "",
      setores: List<String>.from(
        preferencias["setores"] ?? map["setores"] ?? [],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "objetivo": objetivo,
      "conforto_oscilacao": confortoOscilacao,
      "horizonte": horizonte,
      "aporte_mensal": aporteMensal,
      "pais": pais,
      "setores": setores,
    };
  }
}
