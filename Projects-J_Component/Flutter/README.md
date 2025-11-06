# Flutter Weather App Prototype

A comprehensive Flutter mobile application that integrates with a Flask weather API backend, featuring current weather conditions, 5-day forecasts, location-based weather, and favorites management.

## Features

- **Current Weather Display**: Shows temperature, condition, humidity, and wind speed
- **Location-Based Weather**: Automatically fetches weather for your current location
- **City Search**: Search for any city and view its weather information
- **Favorites Management**: Save and manage your favorite cities
- **5-Day Forecast**: View extended weather forecasts (mock data)
- **Offline Support**: Falls back to mock data if Flask API is unavailable
- **Modern UI**: Material Design 3 with smooth animations

## Prerequisites

1. **Flutter SDK**: Install Flutter (version 3.0.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Verify installation: `flutter doctor`

2. **Flask Weather API**: The Flask server must be running
   - The app expects the Flask API at: `http://127.0.0.1:5005/weather?city=CityName`
   - To start the Flask server, run the weather application from your Jupyter notebook:
     ```python
     # From 22-Lab_04-10-2025.ipynb, Cell 5
     WeatherApplication.run(host='127.0.0.1', port=5005, debug=True)
     ```

3. **Android Studio / Xcode** (for mobile development)
   - Android Studio for Android development
   - Xcode for iOS development (macOS only)

## Installation

1. **Clone or navigate to the project directory**:
   ```bash
   cd Projects-J_Component/Flask/weather_app
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

## Running the App

### For Android

1. **Start the Flask API server** (from your Jupyter notebook):
   ```python
   WeatherApplication.run(host='127.0.0.1', port=5005, debug=True)
   ```

2. **Connect an Android device** or start an emulator

3. **Run the Flutter app**:
   ```bash
   flutter run
   ```

### For iOS (macOS only)

1. **Start the Flask API server** (from your Jupyter notebook)

2. **Connect an iOS device** or start a simulator

3. **Run the Flutter app**:
   ```bash
   flutter run
   ```

### For Web

1. **Start the Flask API server**

2. **Run the Flutter app for web**:
   ```bash
   flutter run -d chrome
   ```

**Note**: For web, you may need to configure CORS on the Flask server to allow requests from the Flutter web app.

## Configuration

### Flask API Connection

The app is configured to connect to the Flask API at `http://127.0.0.1:5005`. If your Flask server runs on a different address or port, update the `baseUrl` in:
- `lib/services/weather_api_service.dart`

### Location Permissions

The app requires location permissions to fetch weather for your current location:

- **Android**: Add to `android/app/src/main/AndroidManifest.xml`:
  ```xml
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
  <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
  ```

- **iOS**: Add to `ios/Runner/Info.plist`:
  ```xml
  <key>NSLocationWhenInUseUsageDescription</key>
  <string>We need your location to show local weather</string>
  ```

## Project Structure

```
weather_app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/                   # Data models
│   │   ├── weather_model.dart
│   │   ├── forecast_model.dart
│   │   └── city_model.dart
│   ├── services/                 # Business logic
│   │   ├── weather_api_service.dart
│   │   ├── mock_weather_service.dart
│   │   ├── location_service.dart
│   │   ├── storage_service.dart
│   │   └── weather_service.dart
│   ├── screens/                  # UI screens
│   │   ├── home_screen.dart
│   │   ├── search_screen.dart
│   │   ├── favorites_screen.dart
│   │   ├── forecast_screen.dart
│   │   └── weather_detail_screen.dart
│   └── widgets/                  # Reusable widgets
│       ├── weather_card.dart
│       └── forecast_item.dart
├── pubspec.yaml                  # Dependencies
└── README.md                     # This file
```

## API Integration

### Flask API Response Format

The app expects the Flask API to return text in this format:
```
Weather Report for {CityName}
Condition: {Condition}
Temperature: {Temperature}°C
Humidity: {Humidity}%
Wind Speed: {WindSpeed} km/h
```

### Fallback Behavior

If the Flask API is unavailable (server not running, network error, timeout), the app automatically falls back to mock data with the same structure.

## Features in Detail

### Home Screen
- Displays weather for your current location
- Pull-to-refresh to update weather
- Navigation to search and favorites
- Quick access to forecast

### Search Screen
- Search for any city by name
- View weather information
- Add/remove cities from favorites

### Favorites Screen
- View all favorite cities
- Swipe to delete favorites
- Tap to view detailed weather

### Forecast Screen
- 5-day weather forecast
- Daily high/low temperatures
- Weather conditions for each day

### Weather Detail Screen
- Comprehensive weather information
- Visual weather representation
- Quick access to full forecast

## Troubleshooting

### Flask API Not Connecting

1. **Verify Flask server is running**:
   - Check that the server is running on port 5005
   - Test the API in a browser: `http://127.0.0.1:5005/weather?city=London`

2. **Check network configuration**:
   - For Android emulator, use `10.0.2.2` instead of `127.0.0.1`
   - For iOS simulator, `127.0.0.1` should work
   - For physical devices, use your computer's IP address

3. **The app will use mock data** if the API is unavailable

### Location Not Working

1. **Check permissions**: Ensure location permissions are granted
2. **Enable location services**: Make sure location services are enabled on your device
3. **Use search**: If location fails, use the search feature to find cities manually

### Build Errors

1. **Clean and rebuild**:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Check Flutter version**: Ensure you're using Flutter 3.0.0 or higher

## Dependencies

- `http`: ^1.1.0 - HTTP client for API calls
- `geolocator`: ^10.1.0 - Location services
- `shared_preferences`: ^2.2.2 - Local storage for favorites
- `intl`: ^0.18.1 - Date and time formatting

## Development Notes

- The app uses Material Design 3
- All weather data is cached during the session
- Favorites are persisted locally using SharedPreferences
- Forecast data is generated using mock service (Flask API doesn't provide forecast)

## License

This is a prototype application for educational purposes.

## Author

Created as part of Advanced Python Programming Laboratory project.

