class User {
  final String? id;
  final String? name;
  final String email;
  final String? token;

  User({this.id, this.name, required this.email, this.token});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map["id"] ?? map["user_id"],
      name: map["name"],
      email: map["email"],
      token: map["token"] ?? map["access_token"],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email, 'token': token};
  }
}
