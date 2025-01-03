import 'dart:convert';

class HeightLogApiResponse {
  final HeightLog? data;

  HeightLogApiResponse({
    this.data,
  });

  factory HeightLogApiResponse.fromRawJson(String str) =>
      HeightLogApiResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HeightLogApiResponse.fromJson(Map<String, dynamic> json) =>
      HeightLogApiResponse(
        data: json["data"] == null ? null : HeightLog.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class HeightLog {
  final int? id;
  final String? height;
  final String? weightGoal;
  final UserId? userId;

  HeightLog({
    this.id,
    this.height,
    this.weightGoal,
    this.userId,
  });

  factory HeightLog.fromRawJson(String str) =>
      HeightLog.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HeightLog.fromJson(Map<String, dynamic> json) => HeightLog(
        id: json["id"],
        height: json["height"],
        weightGoal: json["weight_goal"],
        userId:
            json["user_id"] == null ? null : UserId.fromJson(json["user_id"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "height": height,
        "weight_goal": weightGoal,
        "user_id": userId?.toJson(),
      };
}

class UserId {
  final int? id;
  final String? name;

  UserId({
    this.id,
    this.name,
  });

  factory UserId.fromRawJson(String str) => UserId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
