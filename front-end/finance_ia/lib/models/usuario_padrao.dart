class UserModel {
  final String nome;
  final String email;

  UserModel({required this.nome, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nome: json['name'] ?? json['nome'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'nome': nome, 'email': email};
  }
}
