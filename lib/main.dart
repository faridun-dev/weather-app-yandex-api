import 'package:flutter/material.dart';
import 'package:weather_app_yandex_api/views/screens/home.dart';

void main() {
  WidgetsFlutterBinding();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
