import 'package:flutter/material.dart';
import '../models/city_model.dart';
import '../models/weather_model.dart';
import '../services/storage_service.dart';
import '../services/weather_service.dart';
import '../widgets/weather_card.dart';
import 'weather_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final StorageService _storageService = StorageService();
  final WeatherService _weatherService = WeatherService();
  List<City> _favorites = [];
  Map<String, Weather> _weatherCache = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });

    final favorites = await _storageService.getFavorites();
    
    // Load weather for each favorite
    final Map<String, Weather> cache = {};
    for (var city in favorites) {
      try {
        final weather = await _weatherService.getWeather(city.name);
        cache[city.name] = weather;
      } catch (e) {
        // Skip cities with errors
      }
    }

    setState(() {
      _favorites = favorites;
      _weatherCache = cache;
      _isLoading = false;
    });
  }

  Future<void> _removeFavorite(City city) async {
    final success = await _storageService.removeFavorite(city);
    if (success) {
      await _loadFavorites();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from favorites')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFavorites,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
              ? const Center(
                  child: Text('No favorite cities yet.\nSearch and add cities to favorites.'),
                )
              : RefreshIndicator(
                  onRefresh: _loadFavorites,
                  child: ListView.builder(
                    itemCount: _favorites.length,
                    itemBuilder: (context, index) {
                      final city = _favorites[index];
                      final weather = _weatherCache[city.name];

                      if (weather == null) {
                        return ListTile(
                          title: Text(city.name),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _removeFavorite(city),
                          ),
                          subtitle: const Text('Weather data unavailable'),
                        );
                      }

                      return Dismissible(
                        key: Key(city.name),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          color: Colors.red,
                          child: const Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                        onDismissed: (direction) => _removeFavorite(city),
                        child: WeatherCard(
                          weather: weather,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WeatherDetailScreen(
                                  weather: weather,
                                ),
                              ),
                            ).then((_) => _loadFavorites());
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

