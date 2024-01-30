import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:prayer_time/pages/splash_page.dart';
import 'pages/home_page.dart';

class PrayerTimeApp extends StatelessWidget {
  const PrayerTimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Prayer Time App",
      home: AnimatedSplashScreen(
        splash: const SplashScreen(),
        backgroundColor: Colors.green.shade400,
        nextScreen: const HomePage(),
        duration: 1700,
      ),
    );
  }
}
