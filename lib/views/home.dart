import 'package:flutter/material.dart';
import 'package:weather_app_yandex_api/views/widgets/weather_card.dart';
import 'package:weather_icons/weather_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      body: ListView(
        children: const [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Asia/Dushanbe",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                  ),
                ),
                Text(
                  "34°C",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 90,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sunny",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      WeatherIcons.day_sunny,
                      color: Colors.yellow,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                WeatherCard(
                  hour: "00:00",
                  temp: "34°C",
                  condition: "Cloud",
                  conditionIcon: WeatherIcons.cloud,
                  conditionIconColor: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
