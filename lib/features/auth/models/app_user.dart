class AppUser {
  const AppUser({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.isVerified,
    required this.createdAt,
  });

  final String id;
  final String username;
  final String email;
  final String password;
  final bool isVerified;
  final DateTime createdAt;

  AppUser copyWith({
    String? id,
    String? username,
    String? email,
    String? password,
    bool? isVerified,
    DateTime? createdAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      isVerified: json['isVerified'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
