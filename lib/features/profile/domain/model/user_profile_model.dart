import 'dart:convert';

class UserProfileModel {
  final UserProfile? data;

  UserProfileModel({
    this.data,
  });

  factory UserProfileModel.fromRawJson(String str) =>
      UserProfileModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        data: json["data"] == null ? null : UserProfile.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class UserProfile {
  final int? id;
  final String? name;
  final String? username;
  final String? country;
  final String? email;
  final DateTime? createdAt;

  UserProfile({
    this.id,
    this.name,
    this.username,
    this.country,
    this.email,
    this.createdAt,
  });

  factory UserProfile.fromRawJson(String str) =>
      UserProfile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
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
