class WeightLogApiResponse {
  final List<WeightLogModel> data;

  WeightLogApiResponse({
    required this.data,
  });

  factory WeightLogApiResponse.fromJson(Map<String, dynamic> json) {
    return WeightLogApiResponse(
      data: json["data"] == null
          ? []
          : List<WeightLogModel>.from(
              json["data"].map((x) => WeightLogModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}

class WeightLogModel {
  final int? id;
  final int weight;
  final String timeOfDay;
  final String loggedAt;
  final int? bmi;
  final UserId? userId;

  WeightLogModel({
    required this.id,
    required this.weight,
    required this.timeOfDay,
    required this.loggedAt,
    required this.bmi,
    required this.userId,
  });

  factory WeightLogModel.fromJson(Map<String, dynamic> json) {
    return WeightLogModel(
      id: json["id"],
      weight: json["weight"],
      timeOfDay: json["time_of_day"],
      loggedAt: json["logged_at"],
      bmi: json["bmi"],
      userId: UserId.fromJson(json["user_id"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "weight": weight,
      "time_of_day": timeOfDay,
      "logged_at": loggedAt,
      "bmi": bmi,
      "user_id": userId?.toJson(),
    };
  }
}

class UserId {
  final String name;

  UserId({
    required this.name,
  });

  factory UserId.fromJson(Map<String, dynamic> json) {
    return UserId(
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
    };
  }
}
