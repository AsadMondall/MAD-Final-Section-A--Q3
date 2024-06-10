import 'package:flutter/material.dart';
import 'news_app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country based News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewsHomePage(),
    );
  }
}
