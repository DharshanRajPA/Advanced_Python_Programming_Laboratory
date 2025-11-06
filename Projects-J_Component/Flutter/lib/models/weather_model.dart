class Weather {
  final String cityName;
  final String condition;
  final int temperature;
  final int humidity;
  final double windSpeed;

  Weather({
    required this.cityName,
    required this.condition,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromFlaskResponse(String response, String cityName) {
    final lines = response.split('\n');
    String condition = 'Unknown';
    int temperature = 0;
    int humidity = 0;
    double windSpeed = 0.0;

    for (var line in lines) {
      if (line.contains('Condition:')) {
        condition = line.split('Condition:')[1].trim();
      } else if (line.contains('Temperature:')) {
        final tempStr = line.split('Temperature:')[1].trim().replaceAll('°C', '');
        temperature = int.tryParse(tempStr) ?? 0;
      } else if (line.contains('Humidity:')) {
        final humStr = line.split('Humidity:')[1].trim().replaceAll('%', '');
        humidity = int.tryParse(humStr) ?? 0;
      } else if (line.contains('Wind Speed:')) {
        final windStr = line.split('Wind Speed:')[1].trim().replaceAll(' km/h', '');
        windSpeed = double.tryParse(windStr) ?? 0.0;
      }
    }

    return Weather(
      cityName: cityName,
      condition: condition,
      temperature: temperature,
      humidity: humidity,
      windSpeed: windSpeed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'condition': condition,
      'temperature': temperature,
      'humidity': humidity,
      'windSpeed': windSpeed,
    };
  }

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['cityName'] as String,
      condition: json['condition'] as String,
      temperature: json['temperature'] as int,
      humidity: json['humidity'] as int,
      windSpeed: (json['windSpeed'] as num).toDouble(),
    );
  }
}

