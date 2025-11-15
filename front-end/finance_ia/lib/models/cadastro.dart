class UserModel {
  final String nome;
  final String email;
  final String senha;

  UserModel({
    required this.nome,
    required this.email,
    required this.senha,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nome: json["nome"],
      email: json["email"],
      senha: json["senha"],
    );
  }

  Map<String, dynamic> toJson() => {
        "nome": nome,
        "email": email,
        "senha": senha,
      };
}
