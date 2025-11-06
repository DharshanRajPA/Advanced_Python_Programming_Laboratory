import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import 'weather_api_service.dart';
import 'mock_weather_service.dart';

class WeatherService {
  final WeatherApiService _apiService = WeatherApiService();
  final MockWeatherService _mockService = MockWeatherService();

  Future<Weather> getWeather(String cityName) async {
    // Try Flask API first
    final apiWeather = await _apiService.getWeather(cityName);
    
    if (apiWeather != null) {
      return apiWeather;
    }
    
    // Fallback to mock data
    return _mockService.getMockWeather(cityName);
  }

  List<Forecast> getForecast(String cityName) {
    // Flask API doesn't provide forecast, so always use mock data
    return _mockService.getMockForecast(cityName);
  }
}

