class User {

  String? id;
  String email;
  String? fullName;
  String profilePict;
  String roles;
  String? password;
  String? nimNidn;

  User({this.id, required this.email, this.fullName, required this.profilePict, required this.roles, this.password, this.nimNidn});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString(),
      email: json['email'] ?? '',
      fullName: json['fullName'],
      profilePict: json['profilePict'] ?? '',
      roles: json['roles'] ?? '',
      password: json['password'],
      nimNidn: json['nimNidn']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'email': email,
      'fullName': fullName,
      'profilePict': profilePict,
      'roles': roles,
      if (password != null) 'password': password,
      if (nimNidn != null) 'nimNidn': nimNidn,
    };
  }
}