import 'dart:io';
import 'package:flutter/material.dart';

Future<dynamic> exitPopupMsg(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Are you sure you want to exit?"),
      actions: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                exit(0);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red.shade400),
              ),
              child: const Text(
                "YES",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(Colors.green.shade400),
              ),
              child: const Text(
                "NO",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
