import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.green.shade400,
        foregroundColor: Colors.white,
        title: const Text(
          "About",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "This is an open source project created by MD. Sajid Hossain.\n"
          "Source code can be found in :  \n\nhttps://github.com/sajidrec/flutter_prayer_schedule\n\n"
          "Main goal of this project is to help people to find schedule of Salah according to their desired location.\n",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
