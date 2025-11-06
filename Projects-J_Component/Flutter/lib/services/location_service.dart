import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position?> getCurrentPosition() async {
    // Location services are limited on web
    if (kIsWeb) {
      return null;
    }

    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    // Get current position
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
    } catch (e) {
      return null;
    }
  }

  Future<String?> getCityNameFromLocation(Position position) async {
    // Reverse geocoding is not available in geolocator package
    // For web and mobile, we'll need to use a geocoding service
    // For now, return null and let the user search manually
    // In production, you could use:
    // - geocoding package (requires separate package)
    // - Google Geocoding API
    // - OpenStreetMap Nominatim API
    return null;
  }

  Future<String?> getCurrentCityName() async {
    // On web, location services are limited
    if (kIsWeb) {
      return null;
    }

    final position = await getCurrentPosition();
    if (position != null) {
      return await getCityNameFromLocation(position);
    }
    return null;
  }
}

