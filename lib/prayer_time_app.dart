import 'package:flutter/material.dart';

import 'home_page.dart';

class PrayerTimeApp extends StatelessWidget {
  const PrayerTimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Prayer Time App",
      home: HomePage(),
    );
  }
}
