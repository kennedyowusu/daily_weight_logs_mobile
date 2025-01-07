import 'dart:convert';

class WeightLogApiResponse {
  final WeightLogModel? data;

  WeightLogApiResponse({
    this.data,
  });

  factory WeightLogApiResponse.fromRawJson(String str) =>
      WeightLogApiResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeightLogApiResponse.fromJson(Map<String, dynamic> json) =>
      WeightLogApiResponse(
        data:
            json["data"] == null ? null : WeightLogModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class WeightLogModel {
  final int? id;
  final int? weight;
  final String? timeOfDay;
  final String? loggedAt;
  final double? bmi;
  final UserId? userId;

  WeightLogModel({
    this.id,
    this.weight,
    this.timeOfDay,
    this.loggedAt,
    this.bmi,
    this.userId,
  });

  factory WeightLogModel.fromRawJson(String str) =>
      WeightLogModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeightLogModel.fromJson(Map<String, dynamic> json) => WeightLogModel(
        id: json["id"],
        weight: json["weight"],
        timeOfDay: json["time_of_day"],
        loggedAt: json["logged_at"],
        bmi: json["bmi"]?.toDouble(),
        userId:
            json["user_id"] == null ? null : UserId.fromJson(json["user_id"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "weight": weight,
        "time_of_day": timeOfDay,
        "logged_at": loggedAt,
        "bmi": bmi,
        "user_id": userId?.toJson(),
      };
}

class UserId {
  final String? name;

  UserId({
    this.name,
  });

  factory UserId.fromRawJson(String str) => UserId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
