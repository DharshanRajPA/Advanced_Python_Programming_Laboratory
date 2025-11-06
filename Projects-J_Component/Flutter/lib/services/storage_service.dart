import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/city_model.dart';

class StorageService {
  static const String _favoritesKey = 'favorite_cities';

  Future<List<City>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString(_favoritesKey);
      
      if (favoritesJson == null) {
        return [];
      }

      final List<dynamic> favoritesList = json.decode(favoritesJson);
      return favoritesList
          .map((json) => City.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> addFavorite(City city) async {
    try {
      final favorites = await getFavorites();
      
      // Check if city already exists
      if (favorites.any((c) => c.name.toLowerCase() == city.name.toLowerCase())) {
        return false;
      }

      favorites.add(city);
      return await _saveFavorites(favorites);
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFavorite(City city) async {
    try {
      final favorites = await getFavorites();
      favorites.removeWhere((c) => c.name.toLowerCase() == city.name.toLowerCase());
      return await _saveFavorites(favorites);
    } catch (e) {
      return false;
    }
  }

  Future<bool> isFavorite(String cityName) async {
    try {
      final favorites = await getFavorites();
      return favorites.any((c) => c.name.toLowerCase() == cityName.toLowerCase());
    } catch (e) {
      return false;
    }
  }

  Future<bool> _saveFavorites(List<City> favorites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = json.encode(
        favorites.map((city) => city.toJson()).toList(),
      );
      return await prefs.setString(_favoritesKey, favoritesJson);
    } catch (e) {
      return false;
    }
  }
}

