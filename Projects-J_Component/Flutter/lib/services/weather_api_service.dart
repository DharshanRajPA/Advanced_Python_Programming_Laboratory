import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherApiService {
  // Use localhost for web compatibility, 127.0.0.1 for mobile
  static const String baseUrl = 'http://localhost:5005';
  static const Duration timeout = Duration(seconds: 5);

  Future<Weather?> getWeather(String cityName) async {
    try {
      final uri = Uri.parse('$baseUrl/weather?city=$cityName');
      final response = await http
          .get(uri)
          .timeout(timeout);

      if (response.statusCode == 200) {
        return Weather.fromFlaskResponse(response.body, cityName);
      } else {
        return null;
      }
    } catch (e) {
      // Network error or any other error - Flask server not running or CORS issue
      return null;
    }
  }
}

