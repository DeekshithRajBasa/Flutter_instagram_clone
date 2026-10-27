import 'package:flutter/material.dart';
import 'homeScreen.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(myApp());
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
          primaryIconTheme: IconThemeData(color: Colors.black87),
          textTheme: TextTheme(titleMedium: TextStyle(color: Colors.black87))),
      home: homeScreen(),
    );
  }
}
