import 'package:flutter/material.dart';
import 'package:instagram_clone/homeScreen.dart';

void main() => runApp(myApp());

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
          textTheme: TextTheme(title: TextStyle(color: Colors.black87))),
      home: homeScreen(),
    );
  }
}
