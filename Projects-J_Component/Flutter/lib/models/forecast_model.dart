class Forecast {
  final DateTime date;
  final String condition;
  final int highTemperature;
  final int lowTemperature;
  final int humidity;
  final double windSpeed;

  Forecast({
    required this.date,
    required this.condition,
    required this.highTemperature,
    required this.lowTemperature,
    required this.humidity,
    required this.windSpeed,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'condition': condition,
      'highTemperature': highTemperature,
      'lowTemperature': lowTemperature,
      'humidity': humidity,
      'windSpeed': windSpeed,
    };
  }

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: DateTime.parse(json['date'] as String),
      condition: json['condition'] as String,
      highTemperature: json['highTemperature'] as int,
      lowTemperature: json['lowTemperature'] as int,
      humidity: json['humidity'] as int,
      windSpeed: (json['windSpeed'] as num).toDouble(),
    );
  }
}

