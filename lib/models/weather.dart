class Weather {
  final String cityName;
  final String condition;
  final String temp;
  final List<dynamic> hours;
  final String date;

  Weather({
    required this.cityName,
    required this.condition,
    required this.temp,
    required this.hours,
    required this.date,
  });

  factory Weather.fromJson(dynamic json) {
    return Weather(
      cityName: json["info"]["tzinfo"]["name"] as String,
      condition: json["fact"]["condition"] as String,
      temp: json["fact"]["temp"].toString(),
      hours: json["forecasts"][0]["hours"] as List<dynamic>,
      date: json["forecasts"][0]["date"] as String,
    );
  }

  static List<Weather> weatherFromSnapshot(List snapshot) {
    return snapshot.map(
      (data) {
        return Weather.fromJson(data);
      },
    ).toList();
  }
}
