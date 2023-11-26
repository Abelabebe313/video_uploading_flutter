class User {
  final String id;
  final String first_name;
  final String last_name;
  final String email;

  User({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': first_name,
        'last_name': last_name,
        'email': email,
      };

  @override
  String toString() {
    return 'User{id: $id,first_name: $first_name, last_name: $last_name, email: $email}';
  }
}
