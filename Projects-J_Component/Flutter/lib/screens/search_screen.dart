import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../models/city_model.dart';
import '../services/weather_service.dart';
import '../services/storage_service.dart';
import '../widgets/weather_card.dart';
import 'weather_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final WeatherService _weatherService = WeatherService();
  final StorageService _storageService = StorageService();
  final TextEditingController _searchController = TextEditingController();
  Weather? _weather;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isFavorite = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchWeather(String cityName) async {
    if (cityName.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a city name';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _weather = null;
    });

    try {
      final weather = await _weatherService.getWeather(cityName.trim());
      final isFav = await _storageService.isFavorite(cityName.trim());
      
      setState(() {
        _weather = weather;
        _isFavorite = isFav;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading weather: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (_weather == null) return;

    final city = City(
      name: _weather!.cityName,
    );

    bool success;
    if (_isFavorite) {
      success = await _storageService.removeFavorite(city);
    } else {
      success = await _storageService.addFavorite(city);
    }

    if (success) {
      setState(() {
        _isFavorite = !_isFavorite;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFavorite
                  ? 'Added to favorites'
                  : 'Removed from favorites',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search City'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Enter city name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: _searchWeather,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _searchWeather(_searchController.text),
                  child: const Text('Search'),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_errorMessage != null)
            Expanded(
              child: Center(
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else if (_weather != null)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    WeatherCard(
                      weather: _weather!,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WeatherDetailScreen(
                              weather: _weather!,
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              _isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: _isFavorite ? Colors.red : null,
                            ),
                            onPressed: _toggleFavorite,
                            tooltip: _isFavorite
                                ? 'Remove from favorites'
                                : 'Add to favorites',
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isFavorite
                                ? 'In Favorites'
                                : 'Add to Favorites',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            const Expanded(
              child: Center(
                child: Text('Search for a city to see weather information'),
              ),
            ),
        ],
      ),
    );
  }
}

