import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../widgets/weather_card.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'forecast_screen.dart';
import 'weather_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();
  Weather? _currentWeather;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadWeatherForCurrentLocation();
  }

  Future<void> _loadWeatherForCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final cityName = await _locationService.getCurrentCityName();
      if (cityName != null) {
        final weather = await _weatherService.getWeather(cityName);
        setState(() {
          _currentWeather = weather;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Unable to get location. Please search for a city.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading weather: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshWeather() async {
    await _loadWeatherForCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              ).then((_) => _refreshWeather());
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesScreen()),
              ).then((_) => _refreshWeather());
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshWeather,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadWeatherForCurrentLocation,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : _currentWeather == null
                    ? const Center(
                        child: Text('No weather data available'),
                      )
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            WeatherCard(
                              weather: _currentWeather!,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WeatherDetailScreen(
                                      weather: _currentWeather!,
                                    ),
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ForecastScreen(
                                        cityName: _currentWeather!.cityName,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.calendar_today),
                                label: const Text('View 5-Day Forecast'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadWeatherForCurrentLocation,
        tooltip: 'Refresh Location',
        child: const Icon(Icons.my_location),
      ),
    );
  }
}

