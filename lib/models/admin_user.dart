class AdminUser {
  final int? id;
  final String email;
  final String password;

  AdminUser({this.id, required this.email, required this.password});

  factory AdminUser.fromMap(Map<String, dynamic> json) => AdminUser(
    id: json['id'],
    email: json['email'],
    password: json['password'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'email': email,
    'password': password,
  };
}