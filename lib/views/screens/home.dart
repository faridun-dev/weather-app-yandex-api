import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_yandex_api/services/weather_service.dart';
import 'package:weather_app_yandex_api/models/weather.dart';
import 'package:weather_app_yandex_api/views/widgets/weather_card.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:string_extensions/string_extensions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Weather _weather;
  bool _isLoading = true;
  Position? _currentPosition;

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      print(_currentPosition);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getWeather() async {
    try {
      _weather = await WeatherApi().getWeather(
        _currentPosition!.latitude.toString(),
        _currentPosition!.longitude.toString(),
      );
      print(_weather.cityName);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  IconData getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case "clear":
        return WeatherIcons.day_sunny;
      case "cloudy":
        return WeatherIcons.cloud;
      case "rain":
        return WeatherIcons.rain;
      case "snow":
        return WeatherIcons.snow;
      case "thunderstorm":
        return WeatherIcons.thunderstorm;
      case "fog":
        return WeatherIcons.fog;
      default:
        return WeatherIcons.day_sunny_overcast; // Default icon
    }
  }

  Color getWeatherIconColor(String condition) {
    switch (condition.toLowerCase()) {
      case "clear":
        return Colors.amber;
      case "cloudy":
        return Colors.blue;
      case "rain":
        return Colors.blue;
      case "snow":
        return Colors.white;
      case "thunderstorm":
        return Colors.yellow;
      case "fog":
        return Colors.white;
      case "partly-cloudy":
        return Colors.blue.shade600;
      default:
        return Colors.amber;
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _initialize() async {
    await _getCurrentPosition();
    if (_currentPosition != null) {
      await _getWeather();
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Weather App",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _getWeather,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          _weather.cityName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                          ),
                        ),
                        Text(
                          "${_weather.temp}°C",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 90,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _weather.condition.capitalize,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Icon(
                              getWeatherIcon(
                                _weather.condition,
                              ),
                              color: getWeatherIconColor(_weather.condition),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: List.generate(24, (int index) {
                            return WeatherCard(
                              hour: _weather.hours[index]["hour"],
                              temp: _weather.hours[index]["temp"],
                              condition: _weather.hours[index]["condition"],
                              conditionIcon: getWeatherIcon(
                                  _weather.hours[index]["condition"]),
                              conditionIconColor: getWeatherIconColor(
                                  _weather.hours[index]["condition"]),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
