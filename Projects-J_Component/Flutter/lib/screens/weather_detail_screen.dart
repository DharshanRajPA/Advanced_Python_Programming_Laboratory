import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../models/forecast_model.dart';
import '../widgets/forecast_item.dart';
import 'forecast_screen.dart';

class WeatherDetailScreen extends StatelessWidget {
  final Weather weather;

  const WeatherDetailScreen({
    super.key,
    required this.weather,
  });

  String _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return '☀️';
      case 'cloudy':
        return '☁️';
      case 'rainy':
        return '🌧️';
      case 'windy':
        return '💨';
      case 'stormy':
        return '⛈️';
      case 'clear night':
        return '🌙';
      default:
        return '🌤️';
    }
  }

  Color _getWeatherColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return Colors.orange;
      case 'cloudy':
        return Colors.grey;
      case 'rainy':
        return Colors.blue;
      case 'windy':
        return Colors.blueGrey;
      case 'stormy':
        return Colors.purple;
      case 'clear night':
        return Colors.indigo;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherService = WeatherService();
    final forecast = weatherService.getForecast(weather.cityName);

    return Scaffold(
      appBar: AppBar(
        title: Text(weather.cityName),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Main weather display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _getWeatherColor(weather.condition),
                    _getWeatherColor(weather.condition).withOpacity(0.7),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    _getWeatherIcon(weather.condition),
                    style: const TextStyle(fontSize: 80),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    weather.condition,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${weather.temperature}°C',
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Weather details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Weather Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailCard(
                    icon: Icons.water_drop,
                    label: 'Humidity',
                    value: '${weather.humidity}%',
                  ),
                  const SizedBox(height: 8),
                  _buildDetailCard(
                    icon: Icons.air,
                    label: 'Wind Speed',
                    value: '${weather.windSpeed} km/h',
                  ),
                ],
              ),
            ),
            // Forecast preview
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '5-Day Forecast',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForecastScreen(
                                cityName: weather.cityName,
                              ),
                            ),
                          );
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...forecast.take(3).map((f) => ForecastItem(forecast: f)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(label),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

