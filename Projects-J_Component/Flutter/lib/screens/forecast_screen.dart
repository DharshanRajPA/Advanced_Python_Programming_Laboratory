import 'package:flutter/material.dart';
import '../models/forecast_model.dart';
import '../services/weather_service.dart';
import '../widgets/forecast_item.dart';

class ForecastScreen extends StatefulWidget {
  final String cityName;

  const ForecastScreen({
    super.key,
    required this.cityName,
  });

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  final WeatherService _weatherService = WeatherService();
  List<Forecast> _forecast = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadForecast();
  }

  void _loadForecast() {
    setState(() {
      _isLoading = true;
    });

    final forecast = _weatherService.getForecast(widget.cityName);

    setState(() {
      _forecast = forecast;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('5-Day Forecast - ${widget.cityName}'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _forecast.isEmpty
              ? const Center(child: Text('No forecast data available'))
              : ListView.builder(
                  itemCount: _forecast.length,
                  itemBuilder: (context, index) {
                    return ForecastItem(forecast: _forecast[index]);
                  },
                ),
    );
  }
}

