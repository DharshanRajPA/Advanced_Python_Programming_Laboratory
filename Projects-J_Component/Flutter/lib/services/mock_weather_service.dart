import 'dart:math';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class MockWeatherService {
  static final Random _random = Random();
  static final List<String> _conditions = [
    'Sunny',
    'Cloudy',
    'Rainy',
    'Windy',
    'Stormy',
    'Clear Night',
  ];

  Weather getMockWeather(String cityName) {
    return Weather(
      cityName: cityName,
      condition: _conditions[_random.nextInt(_conditions.length)],
      temperature: 20 + _random.nextInt(19), // 20-38°C
      humidity: 40 + _random.nextInt(51), // 40-90%
      windSpeed: (2.0 + _random.nextDouble() * 10.0).roundToDouble() / 10, // 2.0-12.0 km/h with 1 decimal
    );
  }

  List<Forecast> getMockForecast(String cityName) {
    final List<Forecast> forecast = [];
    final now = DateTime.now();

    for (int i = 0; i < 5; i++) {
      final date = now.add(Duration(days: i + 1));
      final baseTemp = 20 + _random.nextInt(19);
      final highTemp = baseTemp + _random.nextInt(5);
      final lowTemp = baseTemp - _random.nextInt(5);

      forecast.add(Forecast(
        date: date,
        condition: _conditions[_random.nextInt(_conditions.length)],
        highTemperature: highTemp.clamp(20, 38),
        lowTemperature: lowTemp.clamp(15, 35),
        humidity: 40 + _random.nextInt(51),
        windSpeed: (2.0 + _random.nextDouble() * 10.0).roundToDouble() / 10,
      ));
    }

    return forecast;
  }
}

