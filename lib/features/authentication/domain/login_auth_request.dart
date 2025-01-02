import 'dart:convert';

class LoginAuthRequest {
  final String email;
  final String password;

  LoginAuthRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class LoginApiResponse {
  final String? message;
  final User? user;
  final String? token;

  LoginApiResponse({
    this.message,
    this.user,
    this.token,
  });

  factory LoginApiResponse.fromRawJson(String str) =>
      LoginApiResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginApiResponse.fromJson(Map<String, dynamic> json) =>
      LoginApiResponse(
        message: json["message"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "user": user?.toJson(),
        "token": token,
      };
}

class User {
  final int? id;
  final String? name;
  final String? username;
  final String? country;
  final String? email;
  final DateTime? createdAt;

  User({
    this.id,
    this.name,
    this.username,
    this.country,
    this.email,
    this.createdAt,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        username: json["username"],
        country: json["country"],
        email: json["email"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "country": country,
        "email": email,
        "created_at": createdAt?.toIso8601String(),
      };
}
