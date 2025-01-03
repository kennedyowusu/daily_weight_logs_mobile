import 'dart:convert';

class AuthApiResponse {
  final String? message;
  final User? user;
  final String? token;

  AuthApiResponse({
    this.message,
    this.user,
    this.token,
  });

  factory AuthApiResponse.fromRawJson(String str) =>
      AuthApiResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthApiResponse.fromJson(Map<String, dynamic> json) =>
      AuthApiResponse(
        message: json["message"],
        user: json["user"]?["data"] == null
            ? null
            : User.fromJson(json["user"]["data"]),
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
  final DateTime? updatedAt;

  User({
    this.id,
    this.name,
    this.username,
    this.country,
    this.email,
    this.createdAt,
    this.updatedAt,
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
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "country": country,
        "email": email,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
