class ProfileModel {
  final String objetivo;
  final String confortoOscilacao;
  final String horizonte;
  final double aporteMensal;
  final String pais;
  final List<String> setores;

  ProfileModel({
    required this.objetivo,
    required this.confortoOscilacao,
    required this.horizonte,
    required this.aporteMensal,
    required this.pais,
    required this.setores,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    // Handle nested preferences structure from backend
    final preferencias = json["preferencias"] ?? {};

    return ProfileModel(
      objetivo: json["objetivo"] ?? '',
      confortoOscilacao: json["conforto_oscilacao"] ?? '',
      horizonte: json["horizonte"] ?? '',
      aporteMensal: (json["aporte_mensal"] ?? 0).toDouble(),
      pais: preferencias["pais"] ?? json["pais"] ?? '',
      setores: List<String>.from(
        preferencias["setores"] ?? json["setores"] ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "objetivo": objetivo,
    "conforto_oscilacao": confortoOscilacao,
    "horizonte": horizonte,
    "aporte_mensal": aporteMensal,
    "pais": pais,
    "setores": setores,
  };
}
