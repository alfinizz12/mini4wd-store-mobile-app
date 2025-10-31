class User {
  final String id;
  final String email;
  final String username;
  final String? password;
  final String? phone;
  final String? address;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.password,
    this.phone,
    this.address
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email']
    );
  }
}
